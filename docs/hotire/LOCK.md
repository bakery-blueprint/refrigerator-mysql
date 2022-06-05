# Lock
 
### Exclusive lock vs Shared lock

- https://jeong-pro.tistory.com/94
- https://www.letmecompile.com/mysql-innodb-lock-deadlock/
- https://kimdubi.github.io/mysql/insert_on_duplicate_lock/
- https://kukuta.tistory.com/215 
 
### MySQL 엔진의 잠금

MySQL애서 사용되는 잠금은 크게 1. 스토리지 엔진 레벨과 2. MySQL 엔진 레벨

MySQL 엔진은 MySQL 서버에서 스토리지 엔진을 제외한 나머지 부분으로 이해하면 되는데, MySQL 엔진 레벨의 잠금은 모든 스토리지 엔진에 영향을 미치게 되지만 스토리지 엔진 레벨의 잠금은 스토리지 엔진 간 상호 영향을 미치지 않는다. 

MySQL 엔진에서는 테이블 데이터 동기화를 위한 테이블 락 말고도 사용자의 필요에 맞게 사용할 수 있는 유저 락과 테이블 명에 대한 잠금을 위한 네임 락이라는 것도 제공한다.

### 글로벌 락(GLOBAL LOCK)

글로벌 락은 FLUSH TABLES WITH READ LOCK 명령으로만 획득할 수 있으며, MySQL에서 제공하는 잠금 가운데 가장 범위가 크다.

한 세션에서 글로벌 락을 획득하면 다른 세션에서 SELECT를 제외한 대부분의 DDL문장이나 DML 문장을 실행하는 경우 글로벌 락이 해제될 때까지 해당 문장이 대기 상태로 남는다.

### 테이블 락(TABLE LOCK)

개별 테이블 단위로 설정되는 잠금이며, 명시적 또는 묵시적으로 특정 테이블의 락을 획득할 수 있다. 명시적으로는 LOCK TABLES table_name[ READ | WRITE ] 명령으로 특정 테이블의 락을 획득할 수 있다.

명시적으로 획득한 잠금은 UNLOCK TABLES명령으로 잠금을 반납(해제)할 수 있다.

InnoDB 테이블에서는 테이블 락이 설정되지만 대부분 데이터 변경(DML) 쿼리에서는 무시되고 스키마를 변경하는 쿼리(DDL)의 경우에만 영향을 미친다.

### 유저 락(USER LOCK)

GET_LOCK() 함수를 이용해 임의로 잠금을 설정할 수 있다. 

- 대상이 테이블이나 레코드 또는 AUTO_INCREMENT와 같은 데이터베이스 객체가 아니라는 것이다. 
- 유저락은 단순히 사용자가 지정한 문자열(String)에 대해 획득하고 반납(해제)하는 잠금이다.
- 자주 사용하지 않지만 특정 경우에 사용한다. ex ) 많은 레코드를 한 번에 변경하는 트랜잭션의 경우에 유용하게 사용할 수 있다. 배치 프로그램처럼 한거뻔에 많은 레코드를 변경하는 쿼리는 자주 데드락의 원인이 되곤 한다. 이러한 경우에 동일 데이터를 변경하거나 참조하는 프로그램끼리 분류해서 유저 락을 걸고 쿼리를 실행 하면 아주 간단히 해결할 수 있다.

### 네임 락

데이터베이스 객체(대표적으로 테이블이나 뷰)의 이름을 변경하는 경우 획득하는 잠금이다. 

- 네임락은 명시적으로 획득하거나 해체할 수 있는 것이 아니고 RENAME TABLE tab_a TO tab_b같이 테이블의 이름을 변경하는 경우 자동으로 획득하는 잠금이다. 
- RENAME TABLE 명령의 경우 원본 이름과 변경될 이름 두 개 모두 한꺼번에 잠금을 설정한다.

### InnoDB 스토리지 엔진의 잠금

- MySQL에서 제공하는 잠금과는 별개로 스토리지 엔진 내부에서 레코드 기반의 잠금 방식을 탑재하고 있다.

- INFORMATION_SCHEMA라는 데이터베이스에 존재하는 INNODB_TRX, INNODB_LOCKS, INNODB_LOCK_WAITS라는 테이블을 조인해서 조회하면 현재 어떤 트랜잭션이 어떤 잠금을 대기하고 있고,해당 잠금은 어느 트랜잭션이 가지고 있는지 확인할 수 있으며 장시간 잠금을 가지고 있는 클라이언트를 종료시키는 것도 가능하다.

### InnoDB의 잠금 방식

- 비관적 잠금 : 현재 트랜잭션에서 변경하고자 하는 레코드에 비해 잠금을 획득하고 변경 작업을 처리하는 방식을 비관적 잠금이라고 한다. 
- 낙관적 잠금 : 우선 변경 작업을 수행하고 마지막에 잠금 충돌이 있었는지 확인해 문제가 있었다면 ROLLBACK 처리하는 방식을 의미한다.

레코드 기반의 잠금 기능을 제공하며, 잠금 정보가 상당히 작은 공간으로 관리되기 때문에 레코드 락이
페이지 락으로 또는 테이블 락으로 레벨업되는 경우(락 에스컬레이션)는 없다.


### 레코드 락

- 레코드 자체만을 잠근 것을 레코드 락이라고 한다. InnoDB 스토리징 엔진은 레코드 자체가 아니라 인덱스의 레코드를 잠근다.
- 만약 인덱스가 하나도 없는 테이블이라 하더라도 내부적으로 자동 생성된 클러스터 인덱스를 이용해 잠금을 설정한다.
- 프라이머리 키 또는 유니크 인덱스에 의한 변경 작업은 갭에 대해서는 잠그지 않고 레코드 자체에 대해서만 락을 건다.

### 갭락 
- 갭 락은 레코드 자체가 아니라 레코드와 바로 인접한 레코드 사이의 간격만을 잠그는 것을 의미한다.
- 갭 락의 역할은 레코드와 레코드 사이의 간격에 새로운 레코드가 생성되는 것을 제어하는 것이다.

갭 락은 READ_COMMITED 이하에서는 거의 발생하지 않고 REPEATABLE_READ 이상 격리 수준일 때에 주로 발생한다. 

('거의'라고 한 이유는 외래 키 검사나 중복 키 검사할 때는 READ_COMMITED에서도 발생하기 때문이다.)

이것은 실존하는 것이 아니라 개념일뿐이며, 넥스트 키 락의 일부로 사용된다.

- https://medium.com/daangn/mysql-gap-lock-%EB%8B%A4%EC%8B%9C%EB%B3%B4%EA%B8%B0-7f47ea3f68bc
- https://dba.stackexchange.com/questions/237549/gap-locking-in-read-committed-isolation-level-in-mysql

1. Repeatable Read 격리 수준 보장
2. Replication 일관성 보장 (Binary Log Format = Statement 또는 Mixed)
-> Read Committed에서 update name = 'a' where id between 1 ,3 / insert id 2 name 'b'
update가 먼저 시작 insert가 먼저 끝날 수 있고 이로 인해 복제시 이상현상이 발생한다. 
3. Foreign Key / 일관성 보장


### 넥스트 키 락
- 레코드 락과 갭 락을 합쳐 놓은 형태의 잠금을 합쳐놓은 형태로 앞 또는 뒤에 있는 인덱스 레코드의 갭도 락을 건다.
- 변경을 위해 검색하는 레코드에는 넥스트 키 락 방식으로 잠금이 걸린다.
- InnoDB의 갭 락이나 넥스트 키 락은 바이너리 로그에 기록되는 쿼리가 슬레이브에서 실행될 때 마스터에서 만들어낸 결과와 동일한 결과를 만들어내도록 보장하는 것이 주 목적이다.

ex) SELECT c1 FROM t WHERE c1 BETWEEN 10 AND 20 FOR UPDATE;
    
반드시 인덱스 레코드 사이에 있는 갭만 락을 거는 게 아니라 제일 앞 또는 뒤에 있는 인덱스 레코드의 갭도 락을 건다. 

예를 들어 c1=10인 레코드 인덱스 바로 앞에 c1=8인 레코드 인덱스가 있는 상태라면, c1=9인 레코드를 insert 하려고 하면 막힌다. (그 갭에도 락이 걸려있기 때문에!)

갭 잠금은 공존할 수 있습니다. 한 트랜잭션에 의해 취해진 갭 잠금은 다른 트랜잭션이 동일한 갭에 대해 갭 잠금을 취하는 것을 방지하지 않습니다

- https://ktdsoss.tistory.com/382
- https://www.letmecompile.com/mysql-innodb-lock-deadlock/
- https://dev.mysql.com/doc/refman/5.6/en/innodb-locking.html#innodb-gap-locks

생각해보면 어쩌면 당연하겠지만, Unqiue 인덱스의 unique 한 row를 찾을때는 gap lock이 설정되지 않습니다.

- Primary Key와 Unique Index
    - 쿼리의 조건이 1건의 결과를 보장하는 경우, Gap Lock은 사용되지 않고 Record Lock만 사용됨
    - 쿼리의 조건이 1건의 결과를 보장하지 못하는 경우, Record Lock + Gap Lock이 동시에 사용됨 (레코드가 없거나, 여러 컬럼으로 구성된 복합 인덱스를 일부 컬럼만으로 WHERE 조건이 사용된 경우 포함)
- Non-Unique Secondary Index
    - 쿼리의 결과 대상 레코드 건수에 관계없이 항상 Record Lock + Gap Lock이 사용됨


~~~sql
SELECT * FROM a_table WHERE id='taes' FOR UPDATE;
## -> gap lock 설정되지 않음

SELECT * FROM a_table WHERE name='김태성' FOR UPDATE;
## -> name_number_unq_idx 에서 gap lock 설정 될 수 있음
~~~

### 자동 증가 락(AUTO_INCREMENT lock)

- AUTO_INCREMENT 락은 트랜잭션과 관계없이 INSERT나 REPLACE 문장에서 AUTO_INCREMENT 값을 가져오는 순간만 AUTO_INCREMENT 락이 걸렸다가 즉시 해제된다.

### 인덱스와 잠금

- InnoDB의 잠금은 레코드를 잠그는 것이 아니라 인덱스를 잠그는 방식으로 처리된다.
- 즉, 변경해야 할 레코드를 찾기 위해 검색한 인덱스의 레코드를 모두 잠가야 한다.
- 만약 테이블에 인덱스가 하나도 없다면 테이블을 풀 스캔하면서 작업을 한다. 이럴경우 테이블에 있는 모든 레코드를 잠그게되기 때문에 좋은 설계라 할 수 없다


하나의 테이블에 update 문장이 실행되면 Mysql의 InnoDB는 인덱스로 사용된 컬럼의 값과 동일한 레코드 들에 락을 건다. 

만약 인덱스가 없다면 해당 테이블의 레코드에 모두 락을 건다.


### 데드락 

- https://happyer16.tistory.com/entry/MySQL-12%EC%9E%A5-%EC%BF%BC%EB%A6%AC-%EC%A2%85%EB%A5%98%EB%B3%84-%EC%9E%A0%EA%B8%88
- https://jinhokwon.github.io/devops/mysql-deadlock/

1. 상호 거래 패턴 : A, B 가 서로 동시에 포인트 선물을 하고 차감 , 증가 순으로 처리한다. -> 해결 user id 순으로 처리한다. 
2. 유니크 인덱스 : 트랜잭션 1번이 insert 쓰기 잠금을 얻는다. 이후 트랜잭션 2번, 3번이 동일한 키 쓰기를 하려고 할 떄 공유 락을 얻는다. 

