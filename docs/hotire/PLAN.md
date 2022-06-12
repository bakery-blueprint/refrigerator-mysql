# PLAN

: SQL 파서 <-> SQL 옵티마이저 <-> SQL 실행기 <-> 데이터 읽기/쓰기 <-> 디스크 스토리지

쿼리 문장을 토큰(MySQL이 인식할 수 있는 최소 단위의 어휘나 기호)으로 분리해 트리 형태의 구조 파스 트리로 만들어 내어 문법 오류 체크를 한다. 

옵티마이저 단계 -> 최적화 및 실행 계획 수립 단계이다.

- 불필요한 조건의 제거 및 복잡한 연산의 단순화
- 여러 테이블의 조인이 있는 경우 어떤 순서로 테이블을 읽을지 결정
- 각 테이블에 사용된 조건과 인덱스 통계 정보를 이용해 사용할 인덱스 결정
 
MySQL 엔진(SQL 파서, 옵티마이저, 실행기)에서 처리되고, 마지막 "데이터 읽기/쓰기" 작업만 스토리지 엔진에 의해 처리된다.


## 종류 

예전에 통계정보가 없고 느린 CPU로 COST 연산이 부담스러웠을 때 사용했던 방식이 RBO이고 

현재는 대부분 CBO를 사용한다.

### 1. 비용 기반 최적화(Cost-Based Optimizer, CBO)

여러가지 방법 중 대상 테이블의 예측된 통계 정보를 바탕으로 비용을 산출하고 최소 비용을 선택한다.
     
### 규칙 기반 최적화(Rule-Based Optimizer, RBO)

대상 테이블의 특성을 고려하지 않고 내장된 우선순위를 적용하는 방식이다. 

## 통계 

CBO에서 가장 중요한 것은 통계 정보이다. 통계 정보가 정확하지 않으면 코스트 측정이 잘못될수 있기 때문이다.

기본적으로 관리되는 정보는 레코드 건수와 인덱스의 유니크 값의 개수 정도이다.

- SHOW TABLE STATUS 'table'
- SHOW INDEX FROM 'table'

ANALYZE 을 통해 강제로 업데이트 할 수 있지만, 도중 쓰기와 읽기가 불가능하기 때문에 실핼할수 없다.


## 분석 

EXPLAIN 

- EXPLAIN EXTENDED : MySQL Optimizer에 의해서 최종적으로 어떻게 쿼리가 변환되었는지를 알 수 있다. 
- EXPLAIN PARTITIONS : 테이블의 파티션중 어떤 파티션을 사용했는 지 알 수 있다.


### 1. ID

쿼리 별로 부여되는 식별자의 값이다.

### 2. select_type

SELECT 쿼리가 어떤 타입의 쿼리인지 표시되는 칼럼

- SIMPLE : UNION이나 서브 쿼리를 사용하지 않는 단순 SELECT쿼리인 경우에 표시된다. (단 하나만 존)

- PRIMARY : UNION이나 서브 쿼리가 포함된 SELECT 쿼리의 실행 계획에서 가장 바깥쪽 쿼리는 select_type이 PRIMARY로 표시된다. (단 하나만 존재)

- UNION : UNION으로 결합하는 단위 SELECT 쿼리 가운데 첫 번째를 제외한 두 번째이후 SELECT 쿼리의 select_type은 UNION으로 표시된다.

- UNION RESULT : UNION의 결과를 담아두는 테이블을 의미한다 (임시테이블)

- SUBQUERY : FROM 절 이외에서 사용되는 서브 쿼리만을 의미한다.

- DERIVED :  FROM 절에 사용된 서브 쿼리을 의미한다.

- INSERT : inset 시 

- UPDATE : update 시 

- DELETE: DELETE 시 


### 3. table
            
사용할 테이블을 명시한다.

<> 둘러 쌓인 경우 임시 테이블을 의미한다.

### 4. type

테이블의 레코드를 어떤 방식으로 읽었는지 의미한다. 가장 중요하다.

- system : 레코드가 1건만 존재하는 테이블 또는 한 건도 존재하지 않는 테이블을 참조하는 형태의 접근 방법을 system이라 한다. (InnoDB 없다.)
- const: 쿼리가 프라이머리 키나 유티크 키 칼럼을 이용하여 반드시 1건을 반환하는 쿼리의 처리방식이다.
- eq_ref : 여러 테이블이 조인되는 쿼리에서 처음 테이블이 두번쨰 테이블의 프라이머리 키나 유니크 키 칼럼 조건으로 사용됨
- ref : 프라이머리 키나 유티크 키가 아닌 일반적인 인덱스 
- fulltext : MySQL 전문 검색(Fulltext) 인덱스를 사용해 레코드를 읽는 접근 방법
- ref_or_null : ref 접근 방식과 같은데 NULL 비교가 추가된 형태다. 말 그대로 or 조건에 null
- unique_subquery : in절에 사용하는 subquery가 중복되지 않는 유니크 값만 반환된 경우 
- index_subquery : in절에 사용하는 subquery가 중복된 값이 있어서 인덱스를 이용해 중복을 제거함 
- range : 인덱스 레인지 스캔 형태이다. "<, >, IS NULL, BETWEEN, IN, LIKE"등의 연산자로 인덱스를 검색할 때 사용된다. 생각보다 우선순위가 낮지만 어느정도 성능은 보장된다.
- index_merge : 2개 이상의 인덱스를 이용해 각각의 검색 결과를 만든 후 그 결과를 병합하는 처리 방식이다.       
- index :  인덱스를 처음부터 끝까지 읽는 인덱스 풀 스캔을 의미한다.
- ALL : 풀 테이블 스캔을 의미하는 접근 방식이다. 한번에 Read Ahead 기능을 통해 한꺼번에 여러 페이지를 읽어드린다.

index 접근 방식은 풀 스캔 방식과 레코드 건수는 같다. 하지만 인덱스는 데이터 전체 파일보다는 크기가 작아 풀 테이블 스캔보다 효율적이고 빠르다

range 나 const 또는 ref 방식으로 인덱스를 사용하지 못하는 상황에서 인덱스에 포함된 칼럼으로만 처리가 가능하거나, 인덱스를 이용해 정렬이나 그룹핑 작업이 가능한 경우

index 방식이 사용된다.

위에서 아래 순서로 느려진다.

### 5. possible_keys

최적의 실행계획을 만들기 위해 후보로 선정했던 인덱스 목록이다.

### 6. Key
실행 계획에 사용된 인덱스를 의미한다. 쿼리 튜닝시 Key 칼럼에 의도했던 인덱스가 표시되는지 확인해야 한다.

### 7. key_len

실제로 사용할 인덱스의 길이

### 8. ref

접근 방법이 ref 방식이면 참조 조건(Equal 비교 조건)으로 어떤 값이 제공되었는지 보여준다. 

상수값을 지정하면 ref는 const, 다른 테이블의 칼럼이면 칼럼명이 표시된다. 

### 9. rows 

실행 계획의 효율성을 판단하기 위해 예측했던 레코드 건수를 보여준다.
스토리지 엔진별로 가지고 있는 통계정보를 참조한 예상 값이기 때문에 정확하지는 않다.

### 10. Extra

성능에 관련된 내용을 보여준다.

- const row not found : const 접근 방식으로 테이블을 읽었지만 해당 테이블에 레코드가 1건도 존재 하지 않는 경우
- Distinct : Distinct 사용시
- Full scan on NULL key : column IN (subquery) 같은 상황에서 column이 null 이 올 경우 Full scan을 할 수도 있다는 것을 의미한다. null이 알수 없는 값으로 정의한다.
- Impossible HAVING : HAVING 절의 조건을 만족하는 레코드가 없을 때 
- Impossible WHERE : WHERE 조건이 항상 FALSE가 될 수밖에 없는 경우
- Impossible WHERE noticed after reading const tables: 쿼리 플랜만으로 레코드가 없다는 것을 아는 경우
- 잡다한게 있지만... 
- Using filesort : ORDER BY 인덱스를 사용하지 못하는 경우
- !! Using index(커버링 인덱스) : 데이터 파일을 전혀 읽지 않고 인덱스만 읽어서 쿼리를 모두 처리할 수 있을 때
- Using index for group-by : GROUP BY 처리에 인덱스를 사용할 경우 
- Using temporary : 정렬하거나 그룹핑을 위해 임시, 가상테이블 생성 
- Range checked for each record (index map: N) : 레코드 읽을 때마다 쿼리 계산 기준 값이 바뀌는 경우, 조인 조건이 <, >
- !! Using where  : 각 스토리지 엔진은 디스크나 메모리상에서 필요한 레코드를 읽거나 저장하는 역할을 하며, MySQL 엔진은 스토리지 엔진으로부터 받은 레코드를 가공 또는 연산하는 작업을 수행한다. 
MySQL 엔진 레이어에서 별도의 가공을 해서 필터링(여과) 작업을 처리한 경우에만 Extra 칼럼에 "Using where" 코멘트가 표시된다.
스토리지 엔진으로 인덱스로 검색 이후, MySQL 엔진으로 필터링 하는 경우이다. 인덱스를 효율적으로 만들면 MySQL 엔진으로 필터링이 없어서 더 빠르다.
- Using join buffer : 드라이빙 테이블에서 일치하는 레코드 수만큼 드리븐 테이블 검색하며 처리한다.
드리븐 테이블 레코드의 결과가 항상 같다면 join buffer 메모리에 캐시해두고 사용하게 된다.
드리븐 테이블의 풀 테이블 스캔이나 인덱스 풀 스캔을 피할 수 없다면 옵티마이저는 드라이빙 테이블에서 읽은 레코드를 메모리에 캐시한 후 드리븐 테이블과 이 메모리 캐시를 조인하는 형태로 조인한다.                        



## 풀 테이블 스캔

리드 어헤드를 통해 한번에 여러 페이지를 읽을 수 있다.

## 카테시안 조인 

카테시안 조인은 FULL JOIN 또는 CROSS JOIN이라 부른다.

이 조인 조건 자체가 없이 2개 테이블의 모든 레코드 조합을 결과로 가져오는 조인 방식이다. 


## NESTED LOOP JOIN (네스티드-루프 조인)  드라이빙, 드리븐 테이블 

https://devuna.tistory.com/36

- 드라이빙:  JOIN시 먼저 액세스 돼서 ACCESS PATH를 주도하는 테이블을 드라이빙테이블이라고 한다.
- 드리븐 : JOIN시 나중에 액세스 되는 테이블을 드리븐 테이블(DRIVEN TABLE, INNER TABLE)
  
작업 대상이 되는 행(rows)의 수가 적은 테이블부터 액세스 되어야 전체 탐색이 줄어든다.

- 두 칼럼 모두 각각 인덱스가 있는 경우 : 건수가 적은 테이블이 드라이빙 테이블이 된다.
- 한쪽에만 인덱스가 있는 경우 : 인덱스 없는 테이블을 드라이빙 테이블이 된다.





 

## References

- https://weicomes.tistory.com/145?category=669169
- https://weicomes.tistory.com/154
- https://weicomes.tistory.com/149?category=669169
- https://velog.io/@jsj3282/26.-MySQL-%EC%8B%A4%ED%96%89-%EA%B3%84%ED%9A%8D-%EC%8B%A4%ED%96%89-%EA%B3%84%ED%9A%8D-%EB%B6%84%EC%84%9D4
- https://velog.io/@jsj3282/27.-MySQL-%EC%8B%A4%ED%96%89-%EA%B3%84%ED%9A%8D-%EC%8B%A4%ED%96%89-%EA%B3%84%ED%9A%8D-%EB%B6%84%EC%84%9D5
