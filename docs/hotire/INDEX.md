# Index 

DBMS에서 인덱스는 데이터의 저장(INSERT, UPDATE, DELETE) 성능을 희생하고 그 대신 데이터의 읽기 속도를 높이는 기능이다. 인덱스를 역할로 구분해본다면 PK와 보조 키로 구분할 수 있다.

- PK : 레코드를 대표하는 칼럼의 값으로 만들어진 인덱스

- 보조키 : PK를 제외한 나머지 모든 인덱스
PK를 제외한 나머지 모든 인덱스는 보조 인덱스라고 분류한다, 유니크 인덱스는 PK와 성격이 비슷하고 PK를 대체해서 사용할 수 있다고
해서 대체 키라고도 하는데, 별도로 분류하기도 하고 그냥 보조 인덱스로 분류하기도 한다.

대표적으로 B-Tree 인덱스와 Hash 인덱스를  사용한다.

- 유니크 인덱스의 경우 1건만 찾으면 더 찾지 않아도 되기 때문에 옵티마이저 최적화에 도움이 된다. 

## B-Tree 

B-Tree의 "B"는 Binary의 약자가 아니라 Balanced를 의미한다.

B-Tree는 트리 구조로 되어있다.  트리 구조에서 루트 노드도 아니고 리프 노드도 아닌 중간의 노드를 "브렌치 노드"라고 한다. 

데이터베이스에서 인덱스와 실제 데이터가 저장된 데이터는 따로 관리되는데, 인덱스의 리프 노드는 항상 실제 데이터 레코드를 찾아가기 위한 주소 값을 가지고 있다.

### B-Tree 인덱스 키 추가 및 삭제

- 인덱스 키 추가 : B-Tree에 저장될 때는 저장될 키 값을 이용해 B-Tree상의 적절한 위치를 검색해야 한다. 
저장될 위치가 결정되면 레코드의 키값과 대상 레코드의 주소 정보를 B-Tree의 리프 노드에 저장한다. 
만약 리프 노드가 꽉 차서 더는 저장할 수 없을 떄는 리프 노드가 분리돼야 하는데, 이는 상위 브랜치 노드까지 처리의 범위가 넓어진다. 
이러한 탓에 B-Tree는 상대적으로 쓰기 작업(새로운 키를 추가 하는 작업)에 비용이 많이 드는 것으로 알려졌다.

- 인덱스 추가로 인해 INSERT나 UPDATE 문장이 어떤 영향을 받을까? : 테이블의 칼럼 수, 칼럼의 크기, 인덱스 칼럼의 특성 등을 확인해야 한다

대략적으로 계산하는 방법은 테이블에 레코드를 추가하는 작업 비용을 1이라고 가정하면 해당 테이블의 인덱스에 키를 추가하는 작업 비용을 1~1.5 정도로 예측하는 것이 일반적이다. 
일반적으로 테이블에 인덱스가 3개(테이블의 모든 인덱스가 B-Tree라는 가정하에)가 있다면 이때 테이블에 인덱스가 하나도 없는 경우 작업 비용이 1이고, 
3개인 경우에는 5.5 정도의 비용(1.5 * 3 + 1)정도로 예측해 볼 수 있다. 중요한 것은 이 비용의 대부분이 메모리와 CPU에서 처리하는 시간이 아니라 디스크로부터 인덱스 페이지를 읽고 쓰기를 해야 하기 때문에 시간이 오래 걸린다는 것이다.

InnoDB 스토리지 엔진은 적절하게 인덱스 키 추가 작업을 지연시켜 나중에 처리할지, 아니면 바로 처리할지 결정한다.

1. 사용자의 쿼리 실행
2. InnoDB 버퍼 풀에 새로운 키 값을 추가해야 할 페이지(B-Tree의 리프 노드)가 존재한다면 즉시 키 추가 작업 처리
3. 버퍼 풀에 B-Tree의 리프 노드가 없다면 인서트 버퍼에 추가할 키 값과 레코드의 주소를 임시로 기록해 두고 작업 완료(사용자의 쿼리는 실행 완료됨)
4. 백그라운드 작업은 인덱스 페이지를 읽을 때마다 인서트 버퍼에 머지해야 할 인덱스 키값이 있는지 확인한 후, 있다면 병합함(B-Tree에 인덱스 키와 주소를 저장)
5. 데이터베이스 서버 자원의 여유가 생기면 MySQL 서버의 인서트 버퍼 머지 스레드가 조금씩 인서트 버퍼에 임시 저장된 인덱스 키와 주소 값을 머지(B-Tree에 인덱스 키와 주소를 저장)시킴

-> 체인지 버퍼링이라고한다. 관련 설정 파라미터로 innodb_chanage_buffering가 있다

버퍼에 의해 인덱스 키 추가 작업이 지연되어 처리된다 하더라도, 이는 사용자에게 아무런 악영향 없이 투명하게 처리되므로 개발자는 이를 신경쓰지 않아도 된다. innodb_chanage_buffering설정 값을 이용해 키 추가 작업과 키 삭제 작업 중 어느 것을 지연처리할지 설정해야 한다.

- 인덱스 키 삭제

해당 키 값이 저장된 B-Tree의 리프 노드를 찾아서 그냥 삭제 마크만하면 작업이 완료된다. 이렇게 삭제 마키된 인덱스 키 공간은 계속 그대로 방치하거나 또는 재활용할 수 있다. 인덱스 키 삭제로 인한 마킹 작업 또한 디스크 쓰기가 필요하므로 이 작업 역시 디스크 I/O가 필요한 작업이다.

- 인덱스 키 변경

인덱스의 키 값은 그 값에 따라 저장될 리프 노드의 위치가 결정되므로 B-Tree의 키값이 변경되는 경우에는 단순히 인덱스상의 키값만 병경하는 것은 불가능하다. B-Tree의 키값 변경 작업은 먼저 키값을 삭제한 후, 다시 새로운 키값을 추가하는 형태로 처리된다.

- 인덱스 키 검색

INSERT, UPDATE, DELETE 작업을 할 떄 인덱스 관리에 따르는 추가 비용을 감당하면서 인덱스를 구축하는 이유는 바로 빠른 검색을 위해서다.


### 인덱스 키값의 크기

인덱스의 페이지 크기(16KM)와 키 값의 크기의 따라 B-tree의 자식 노드의 개수가 결정된다.

만약 12바이트의 키 값을 갖는다면 16*1024/(16+12) = 585 개수의 자식 노드를 갖는다.

B-Tree 인덱스의 깊이는 상당히 중요하지만 직접적으로 제어할 방법이 없다.

인덱스의 키 값이 증가할 경우, 하나의 인덱스 페이지에 담을 수 있는 인덱스 개수가 줄어들고 이로 인해 

같은 레코드라도 깊이가 깊어져 디스크 IO가 늘어난다.

하지만 아무리 대용량의 데이터베이스라도 B-Tree의 깊이(Depth)가 4~5 이상까지 깊어지는 경우는 거의 발생하지 않습니다.

### Selectivity / Cardinality

높을 수록 중복되는 값이 없다. 


- ex) country 인덱스, country, city 조건 검색시 country Cardinality가 낮을 경우 city를 찾기 위해 불필요한 데이터를 가져오게된다.

### 옵티마이저 인덱스 판단 

일반적인 DBMS의 옵티마이저에서는 인덱스를 통해 레코드1건을 읽는 것이 테이블에서 직접 레코드 1건을 읽는 것보다 4~5배 정도 더 비용이 많이 드는 작업인 것으로 예측한다.

즉, 전체 테이블 레코드에 20%~25%를 넘어서면 인덱스를 이용하지 않고 직접 테이블을모두 읽어서 필요한 레코드만 가려내는(필터링) 방식으로 처리하게 된다.

-> 그래도 힌트로 인덱스르 주어보자. 빨라질수 있다.

### 인덱스 레인지 스캔

인덱스 레인지 스캔은 검색해야 할 인덱스의 범위가 결정됐을 때 사용하는 방식이다. 

루트 노드로부터 브랜치, 리프노드까지 원하는 시작점을 찾고 멈추는 지점까지 노드간의 링크를 이용해서 스캔하여 레코드를 반환한다. 


### 인덱스 풀 스캔

인덱스 레인지 스캔과 마찬가지로 인덱스를 사용하지만 인덱스 레인지 스캔과는 달리 인덱스의 처음부터 끝까지 스캔하는 방식이다. 

쿼리가 인덱스에 명시된 컬럼만으로 조건을 처리할 수 있는 경우 주로 사용된다. 

### 루스 인덱스 스캔

중간마다 필요하지 않는 인덱스 키를 skip 한다. group by 에서 max, min 최적화에 사용된다. 

### 다중 컬럼(Multi-column) 인덱스

두 개 이상의 컬럼으로 구성된 인덱스로 순서가 중요하다. 

첫번째 컬럼 기준 정렬, 두번째 컬럼 기준 정렬 순으로 두번째 컬럼은 첫번째 컬럼에 의존하여 정렬된다. 

### B-Tree 인덱스의 정렬 및 스캔 방향

인덱스는 항상 오름차순으로 정렬된다. 인덱스 읽는 방향으로 오름차순 내림차순을 결정한다. 

컬럼 단위 정렬 방식(ASC와 DESC)을 혼합해서 생성하는 기능을 아직 지원하지 않는다. 

컬럼의 값을 반대로 저장하는 것이 유일한 방법이다.

### B-Tree 인덱스의 가용성과 효율성

- NOT-EQUAL 인 경우

- LIKE '%??' (앞부분이 아닌 뒷부분 일치) 

- 스토어드 함수나 다른 연산자로 인덱스 컬럼이 변형된 후 비교된 경우

- 데이터 타입이 서로 다른 비교(인덱스 컬럼의 타입을 변환해야 비교가 가능한 경우)

  
해당 경우 인덱스를 타지 않는다.
  
  
### 유니크 인덱스

유니크란 사실 인덱스라기보다는 제약 조건에 가깝다. (2개 이상 저장될 수 없음)

MySQL에서는 인덱스 없이 유니크 제약만 설정할 방법이 없다.

- 인덱스 읽기 : 
보조 인덱스와 비교했을 때 유니크 인덱스가 빠르다고 생각하지만 아니다. (디스크 작업이 아닌 CPU작업)
물론 카디널리티가 떨어져 중복된 값이 많으면 느리긴 하다. 이것은 인덱스가 느린 것이 아니라 레코드가 많아서 느리다고 말할 수 있다. 

- 인덱스 쓰기 : 유니크는 중복된 값인지 체크하는 과정이 필요해 더 느리다. 중복된 값을 체크하는 과정 중 읽기/쓰기 잠금을 사용해 데드락이 자주 발생한다.

또한 보조 인덱스는 인서트 버퍼를 통해 빨리 처리되지만 유니크는 사용할 수 없다.

### 외래키 

외래키 제약이 설정되면 자동으로 연관되는 테이블의 칼럼에 인덱스까지 생성된다.

외래키 변경시 부모 테이블에 공유락을 건다.

### 외래키 잠금 

외부키 제약으로 인해 자식테이블에서 지정하는 부모의 id가 부모 테이블에 존재함(정합성)을 보증하기 위해 공유락을 걸게 된다.

데드락이 자주 발생하는데, 자식 테이블의 외래키를 변경시, 부모테이블의 잠금을 체크하게 된다.(공유락 )

- 자식 테이블의 변경이 대기하는 경우 (자식 테이블의 외래키를 변경시)

- 부모 테이블의 변경이 대기하는 경우 (ON DELETE CASCADE)

- https://m.blog.naver.com/parkjy76/220639066476

## 인덱스 팁

- https://jojoldu.tistory.com/243

## 클러스터링 인덱스 

- https://enterone.tistory.com/230
- https://kosaf04pyh.tistory.com/m/293
- https://opentutorials.org/course/1555/8764


## FullText

단어 또는 구문에 대한 검색 기능이다. 

- 자연어 검색(natural search)
검색 문자열을 단어 단위로 분리한 후, 해당 단어 중 하나라도 포함되는 행을 찾는다.
- 불린 모드 검색(boolean mode search)
검색 문자열을 단어 단위로 분리한 후, 해당 단어가 포함되는 행을 찾는 규칙을 추가적으로 적용하여 해당 규칙에 매칭되는 행을 찾는다.
- 쿼리 확장 검색(query extension search)
2단계에 걸쳐서 검색을 수행한다. 첫 단계에서는 자연어 검색을 수행한 후, 첫 번째 검색의 결과에 매칭된 행을 기반으로 검색 문자열을 재구성하여 두 번째 검색을 수행한다. 
이는 1단계 검색에서 사용한 단어와 연관성이 있는 단어가 1단계 검색에 매칭된 결과에 나타난다는 가정을 전제로 한다. 
 
- https://kmongcom.wordpress.com/2014/03/28/mysql-%ED%92%80-%ED%85%8D%EC%8A%A4%ED%8A%B8fulltext-%EA%B2%80%EC%83%89%ED%95%98%EA%B8%B0/ 
 
## References 

- https://junghyungil.tistory.com/m/137
- https://12bme.tistory.com/150?category=682920
- https://12bme.tistory.com/138