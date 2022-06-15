# HINT

SQL 문장에 특별한 키워드를 지정해 MySQL 옵티마이저에게 어떻게 데이터를 읽는 것이 최적인지 알려줄 수 있다. 

### STRAIGHT_JOIN

### USE INDEX / FORCE INDEX / IGNORE INDEX

- USE INDEX : 가장 자주 사용되는 인덱스 힌트로, MySQL 옵티마이저에게 특정 테이블의 인덱스를 사용하도록 권장한다.

- FORCE INDEX: 더 강한 힌트이다.

- IGNORE INDEX : 인덱스 사용 제한
