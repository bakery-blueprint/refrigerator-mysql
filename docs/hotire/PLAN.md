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
- fulltext : 
- ref_or_null
- unique_subquery
- index_subquery
- range
- index_merge
- index
- ALL

위에서 아래 순서로 느려진다.








 

## References

- https://weicomes.tistory.com/145?category=669169
- https://weicomes.tistory.com/154