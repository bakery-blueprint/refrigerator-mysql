# Transaction

- 작업의 단위 

## 트랜잭션 격리 수준(isolation Level)

- https://jupiny.com/2018/11/30/mysql-transaction-isolation-levels/

ACID 원자성(Atomicity), 일관성(Consistency), 격리성(Isolation), 지속성(Durability)

### READ UNCOMMITTED

커밋하기 전에 읽을 수 있다.
"DIRTY READ"라고도 하는 READ UNCOMMITTED는 일반적인 데이터베이스에서는 거의 사용하지 않는다.

### READ COMMITTED

커밋된 데이터를 읽을 수 있다. 

NON-REPEATABLE READ	발생한다. (트랜잭션 안에서 같은 select의 결과가 일치하지 않는다.)

### REPEATABLE READ

- SELECT시 현재 시점의 스냅샷을 만들고 스냅샷을 조회한다.
- 동일 트랜잭션 내에서 일관성을 보장한다.

PHANTOM READ 발생한다. (InnoDB 발생하지 않음) 넥스크 키락 

### SERIALIZABLE

SELECT 문에 사용하는 모든 테이블에 shared lock이 발생한다.

