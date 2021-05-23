

## 1주차 아키텍처

## 1.1 MySQL 전체구조

MySQL는 크게 응용프로그램 / MySQL 서버 / 운영체제 & 하드웨어 나뉘고

MySQL 서버는 크게 MySQL 엔진 / 스토리지 엔진으로 구분해서 볼 수 있다. 



### MySQL 엔진

- 클라이언트로부터 접속 및 쿼리 요청을 처리하는 커넥션 핸들러
- SQL 파서 및 전처리기
- 옵티마이저

3가지가 중심을 이룬다. 또한 성능 향상을 위해 MyISAM의 키 캐시, InnoDB의 버퍼 풀, 보조 저장소 기능이 포함되어있다.



### 스토리지 엔진

MySQL엔진은 요청된 SQL 문장을 분석하거나 최적화하고

실제 데이터를 디스크 스토리지에 저장하거나 디스크 스토리지로부터 데이터를 읽어오는 부분은 스토리지 엔진이 전담한다. 



MySQL 서버에서 MySQL 엔진은 하나지만 스토리지 엔진은 여러개를 사용할 수 있다. 



### 핸들러 API

MySQL 엔진의 쿼리 실행기에서 데이터 쓰거나 읽어야 할 때는 스토리지 엔진에게 요청을 "핸들러 요청"이라고 한다. 

핸들러 API를 이용해 MySQL 엔진과 데이터를 주고 받는다. 

~~~sql
show global status like 'Handler%'
~~~

: show status - MySQL 데이타베이스의 현재 상황을 확인한다. 

global : 시스템 전역 변수값 반대로 SESSION이 존재하고 현재 연결에 유요한 값을 표시한다.

![MySQL](../img/show.png)

- referencs : https://dev.mysql.com/doc/refman/8.0/en/server-status-variables.html

 - Handler_read_first : Index의 첫번째 Node Access, FULL_INDEX_SCAN
 - Handler_read_key : 특정값으로 Tree Search를 통해 index Node를 선택하는 경우, INDEX_SEEK
 - Handler_read_next : 인덱스의 leaf노드들의 링크를 Range스캔할 경우
 - Handler_read_prev : 위와 반대로 역순 Range스캔
 - Handler_read_random : Sorting같은 Buffer에 저장된 row에 대한 Access
 - Handler_read_random_next : 데이터Block나 Temp Table에서 순차적으로 row를 읽는 경우,FULL_TABLE_SCAN

: 추후 index에서... 
















