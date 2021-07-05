# 09. 사용자 정의 변수
- 누가 생성 : 사용자 변수 / 시스템 변수
- 변수 적용 범위 : 서버전체 -> 글로벌 변수 / 커넥션 -> 세션 변수
- 동적 변수 변경 가능 : 동적 변수 / 정적 변수
- 시스템 변수 : 고정 이름 사용 / 사용자 정븨 변수 : 임의 이름 부여 가능

## 9.1 사용자 정의 변수 소개 
- 사용자 정의 변수는 스토어드 프로시저, 함수뿐 아니라 SQL 문장에서 사용가능
- 사용자 변수 이름은 "@" 시작
- 별도의 타입을 정의하지 않고 저장하는 값에 의해서 그 타입이 정해짐
- 저장할 수 있는 값은 Integer, Decimal, Float, Binary, 문자열, NULL(초기값을 설정하지 않을때 때도 NULL)
- SET 문장으로 값이 할당됨가 동시에 생성
- 연산 결과를 다시 사용자 변수에 할당하는 것도 가능
- MySQL 버전별로 사용자 변수의 동작 방식 일관성을 보장하지 않으므로 '절대 동일 SQL문장에서 변수에 값을 할당하고 동시에 값을 참조하지 말라' 라고 한다.
- 하지만 동일한 버전에서는 일관된 결과를 보장받을 수 있다.
- 사용자 변수 사용 주의 사항
  - MySQL 5.0 미만의 버전에서는 대소문자 구분
  - 쿼리 캐시 기능 사용 못함
  - 초기화 하지 않으면 문자열 타입의 NULL
  - 사용자 정의 변수 연산 순서는 안정해져있음
  - 여러 버전에서 동일한 연산 일관성을 보장하지 않음

## 9.2 사용자 변수의 기본 활용
- 커넥션 간에는 공유되지 않지만 하나의 커넥션에서는 공유된다.
- 커넥션 풀을 사용하는 어플리케이션에서는 변수를 초기화하지 않는다면 상호 영향을 끼칠 수 있음
- 매번 set을 통해 초기화 하는 작업이 필요함
- 보통 FROM절을 사용한 초기화를 많이 사용함

```sql
SELECT (@rownum:=@rownum+1) AS rownum, emp_no, first_name
  FROM employees, (SELECT @rownum:=0) der_tab
 LIMIT 5;
```

- FROM 절의 (SELECT @rownum:=0)는 SET 명령과 동일한 역할을 수행한다. FORM 절은 쿼리 실행시 한번만 참조되기 때문에 변수 초기화에 좋은 위치이다.
- (SELECT @rownum:=0) 절은 employees와 조건없이 조인되지만 스칼라값만을 출력하는 테이블이어서 성능에 영햐을 끼치지 않는다.
- 다만 JOIN UPDATE, JOIN DELETE 문장에서는 테이블이 2개 이상일때 ORDER BY 절을 사용할 수 없으므로 사용할 수 없다.
- (@rownum:=@rownum+1) 는 성공 여부를 반환하는게 아니라 할당한 값을 반환한다.

## 9.3 사용자 변수의 적용 예제

### 9.3.1 N번째 레코드만 가져오기
- 5.x  버전에서 동작
```sql
select *
  from departments, (select @rn:=0) as x
 where (@rn:=@rn+1) = 3
 order by dept_name
```

### 9.3.2 누적 합계 구하기
- 사용자 정의 변수를 활용해 읽어 오는 레코드 순서대로 누적 합계도 쉽계 처리 가능
```sql
select emp_no, salary, (@acc_salary:=@acc_salary+salary) as acc_salary
  from salaries, (select @acc_salary:=0) x
 limit 10;

```
### 9.3.3 그룹별 랭킹 구하기
```sql
select emp_no, first_name, last_name, if(@prev_firstname=first_name, @rank:=@rank+1, @rank:=1 + LEAST(0, @prev_firstname:=first_name)) rnak
  from employees, (select @rank:=0) x1, (select @prev_firstname:='DUMMY') x2
 where first_name in('Georgi', 'Bezalel')
 order by first_name, last_name;
```
- 위와 같은 쿼리를 직접 select 해서 결과를 확인해 보면 더 쉽게 이해할 수 있다.

### 9.3.4 랭킹 업데이트 하기
- 사용자 정의 변수는 UPDATE 문에서도 사용할 수 있다.
- 위에서 이야기 했던것과 같이 update문장안에 (select @변수) 를 사용한다면 join update 문장은 order by절을 사용할 수 없으므로 따로 사용자 변수를 초기화 하는 부분이 필요하다.


### 9.3.5 GROUP BY 와 ORDER BY 가 인덱스를 사용하지 못하는 쿼리
- 임시 테이블을 사용할 경우 임시 테이블에 저장된 순서대로 사용자 변수가 연산되어 버리기 때문에 문제가 발생할 수 있음
- 이럴 때는 쿼리 전체를 임시 테이블(파생 테이블)로 만들어 이후 사용자 변수를 사용하는 바업ㅂ이 있음
- 만약 임시 테이블로 만들기 부담이 된다면 인덱스를 사용할 수 있도록 개선이 필요


## 9.4 주의 사항
- 참조와 할당을 같이 사용하고 있기 때문에 안정적인 결과를 버전별로 일관성 있게 보장하지 않음

# 10. 파티션
-  MySQL 입장에서는 데이터를 별도의 테이블로 분리해서 저장하지만 사용자 입장에서는 여전히 하나의 테이블로 읽기와 쓰기를 할 수 있게 해주는 솔루션이다.
-  일반적으로 파티션은 하나의 서버에서 테이블을 분산하는 것
-  기본적으로 해시와 리스트, 그리고 키와 레인지로 4가지 파티션 방법을 제공

## 10.1 개요
### 10.1.1 파티션을 사용하는 이유
- 하나의 테이블이 너무 커서 인덱스의 크기를 물리적인 메모리보다 훨씬 클때
- 데이터 특성상 주기적인 삭제 작업이 필요한 경우

#### 단일 insert와 단일 또는 범위 select의 빠른 처리
- update, delete 처리 대상을 찾기 위해서도 인덱스를 사용
- 만약 한 테이블의 인덱스 크기가 물리적으로 사용가능한 메모리 공간보다 크다면 문제가 발생할 수 있음
- 파티션을 통해 데이터와 인덱스를 조각화 해서 물리적 메모리를 효율적으로 사용 할 수 있게 만들어 준다

#### 데이터의 물리적인 저장소를 분리
- 데이터 / 인덱스 파일이 파일 시스템에서 차지하는 공간이 크다면 백업이나 관리 측면에서 부담이감
- 이러한 문제는 파티션을 통해 파일의 크기를 조절하여 파티션별로 관리가 가능

#### 이력 데이터의 효율적인 관리
- 로그 테이블의 데이터는 일정 기간이 지나면 쓸모가 없어짐
- 또한 단기간 대량 데이터 특성을 가짐
- 파티션 테이블로 관리한다면 불필요한 데이터의 삭제 작업은 파티션 추가나 삭제하는 방법으로 해결 가능

### 10.1.2 MySQL 파티션의 내부 처리

-  예제 테이블
```sql
create table tb_article (
                            article_id int not null,
                            reg_date datetime not null,
                            primary key (article_id, reg_date)
)
    PARTITION BY RANGE (year(reg_date)) (
        PARTITION p2009 VALUES LESS THAN (2010),
        PARTITION p2010 VALUES LESS THAN (2011),
        PARTITION p2011 VALUES LESS THAN (2012),
        PARTITION p9999 VALUES LESS THAN maxvalue
        );

```
#### 파티션 테이블의 레코드 INSERT

- INSERT 되는 칼럼의 값 중에서 파티션 키인  reg_date칼럼의 값을 이용해 파티션 표현시을 평가
- 레코드 파티션이 결정되면 나머지 과정은 파티션되지 않은 일반 테이블과 마찬가지로 처리 된다.
  

#### 파티션 테이블의 UPDATE 
-  변경 대상 레코드가 어느 파티션에 저장돼 있는지 찾아야 한다.
-  WHERE 조건에 파티션 키 컬럼이 조건을 존재하면 그 값을 이용해 레코드가 저장된 파티션에 빠르게 대상 레코드를 검색할 수 있다.
-  조건에 파티션 키 컬럼이 없다면 모든 테이블 파티션 검색을 해야 한다.
-  파티션 키 컬럼이 변경될 때는 기존 레코드가 저장된 파티션에서 해당 레코드를 삭제함
-  이후 파티션 표현식 평가 후 새로운 파티션을 결정해서 레코드를 저장

#### 파티션 테이블의 검색
- 파티션 테이블을 검색할 때 성능에 크게 영향을 미치는 조건
  - WHERE절 조건으로 검색해야 할 파티션을 선택할 수 있는가?
  - WHERE절의 조건이 인덱스를 효율적(인덱스 레인지 스캔)으로 사용할 수 있는가?
- 파티션 선택 가능 + 인덱스 효율적 사용가능
  - 파티션의 개수에 상관없이 꼭 필요한 파티션의 인덱스만 레인지 스캔
- 파티션 선택 불가 + 인덱스 효율적 사용가능
  - 모든 파티션을 대상으로 검색
  - 파티션 개수만큼 인덱스 레인지 스캔을 수행한 다음 결과를 병합
- 파티션 선택 가능 + 인덱스 효율적 사용 불가
  - 대상 파티션 풀 테이블 스캔
- 파티션 선택 불가 + 인덱스 효율적 사용 불가
  - 각 파티션 작업 자체도 풀 테이블 스캔 

#### 파티션 테이블의 인덱스 스캔과 정렬
- 파티션 통합 인덱스 지원 X
- 각 파티션에 대해 인덱스 스캔을 수행할 때, 파티션으로 부터 조건에 일치하는 레코드를 정렬되 ㄴ순서대로 읽음
- 그리고 우선순위 큐에 임시로 저장
- 큐에서 다시 필요한 순서대로 데이터를 가져감


#### 파티션 프루닝
- 파티션 가운데 전부가 아닌 몇개만 읽어도 된다고 판단되면 불필요한 파티션에 접근하지 않는다.

## 10.2 주의사항

### 10.2.1 파티션의 제한 사항
- 숫자 값만 파티션 가능 (5.5 이상부터는 문자열도 가능)
- 키 파티션은 해시 함수를 직접 선택하기 때문에 컬럼 타입 제한 없음
- 최대 1024개 파티션 가능
- 스토어드 루틴이나 UDF 그리고 사용자 변수 등을 파티션 함수나 식에 사용 불가능
- 파티션 생성 이후 서버의 sql_mode 파라미터 변경은 추천하지 않음
- 파티션 테이블에서는 외래키 사용 불가
- 파티션 테이블은 전문 검색 인덱스 생성 불가
- 공장 확장 기능에서 제공되는 컬럼 타입은 파티션 테이블에 사용 불가
- 임시 테이블은 파티션 기능 사용 불가
- MyISAM 파티션 테이블의 경우 키 캐시를 사용할 수없음(5.5는 버그 보완)
- 파티션 키 표현식은 컬럼 or 내장함수 (year, to_days, to_seconds)
- 인덱스는 모두 로컬 인덱스
- 파티션 단위로 인덱스 변경 / 추가 불가능


### 10.2.2 파티션 사용시 주의 사항
- 범위를 좁히기 위해 사용하는 파티션에서는 유니크 키에 대한 체크 작업 때문에 제약사항이 많음

#### 파티션과 유니크(프라이머리 키 포함)
- 파티션 키는 모든 유니크 인덱스의 일부 또는 모든 칼럼을 포함해야 한다.
- 각 유니크 키에 대해 값이 주어지면 해당 레코드가 어느 파티션에 저장돼 있는지 계산할 수 있어야 한다는 점을 기억하자.

#### 파티션과 open_files_limit 파라미터
- 파티션이 많아질 경우 open_files_limit 시스템 변수 설정을 통해 오픈할 수있는 적절한 파일 개수를 설정하는 것이 좋다.

#### 파티션 테이블과 잠금
- 쿼리에 필요한 파티션만 선별하는 파티션 프루닝 작업은 쿼리의 최적화 단계에서 수행되므로 어떤 파티션만 사용될지 알아낼 방법이 업삳.
- 파티션 테이블에 쿼리가 실행되면 서버는 테이블의 파티션 개수에 관계없이 모든 파티션을 열고 잠금을 걸게 된다.
- 적정 수준의 파티션이 있는 테이블에서 느려지는 현상이 발생함
- 파티션이 많이 포함된 테이블에서는 LOCK TABLES 명령으로 테이블을 잠그고 INSERT나 UPDATE를 수행하면 조금 더 빠르게 처리할 수있다.

## 10.3 MySQL 파티션 종류
- 레인지 파티션
- 리스트 파티션
- 해시 파티션
- 키 파티션

### 10.3.1 레인지 파티션
- 다음과 같은 성격을 지닌 테이블에서 유리
  - 날짜를 기반으로 데이터가 누적, 년도나 월/일 단위로 분석 및 삭제를 해야할 때
  - 범위 기반으로 데이터를 여러 파티션에 균등하게 나눌 수 있을 때
  - 파티션 키 위주로 검색이 자주 실행될 때

#### 레인지 파티션 테이블 생성
- PARTITION BY RANGE 키워드로 생성
- 뒤에 컬럼 또는 내장함수를 이용해 파티션 키 명시
- VALUES LESS THAN으로 명시된 값보다 작은 값만 해당 파티션에 저장되도록 설정, 다만 명시된 값은 포함 X
- VALUES LESS THAN maxvalue로 명시되지 않은 레코드 저장 파티션 설정
- VALUES LESS THAN maxvalue가 없다면 파티션을 못찾으면 에러가 발생
- 테이블과 각 파티션은 같은 스토리지 엔진으로 정의한다.

#### 레인지 파티션의 분리와 병합
- **단순 파티션의 추가**
- VALUES LESS THAN maxvalue 가 정의돼 있을 때는 테이블에 새로운 파티션을 추가할 수 없다. 이때는 파티션을 분리하는 방법으로 새로운 파티션을 끼워 넣어야 한다.

- **단순 파티션 삭제**
- ALTER TABLE emplotees DROP PARTITION p0;

- **기존 파티션의 분리**
- REORGANIZE PARTITION 명령어를 사용
```sql
create table tb_article (
                            article_id int not null,
                            reg_userid varchar(10),
                            reg_date datetime not null,
                            primary key (article_id, reg_date)
)
    PARTITION BY RANGE (year(reg_date)) (
        PARTITION p1 VALUES LESS THAN (2010),
        PARTITION p2 VALUES LESS THAN (2011),
        PARTITION p3 VALUES LESS THAN (2012),
        PARTITION p4 VALUES LESS THAN maxvalue
        );

ALTER TABLE tb_article  REORGANIZE PARTITION p4 INTO (
    PARTITION p4 VALUES LESS THAN (2013),
    PARTITION p5 VALUES LESS THAN MAXVALUE
    );

```

- **기존 파티션의 병합**
- 병합하는 작업 또한 REORGANIZE PARTITION 사용
  

#### 레인지 파티션 주의사항
- NULL값은 어떤 값보다 작은 값으로 간주
- 날짜 값으로 파티션을 만들 경우, 다음과 같은 파티션 키를 사용하는 파티셔닝은 피하는 것이 좋다.
  - UNIX_TIMESTAMP()를 이용한 변환 식을 파티션 키로 사용
  - 날짜를 문자열로 포맷팅한 형태('2021-01-01')의 파티션 키
  - YEAR()나 TO_DAYS() 함수 이외의 함수가 사용된 파티션 키

- 아래 두개의 함수 추천
  -  YEAR(), TO_DAYS()

### 10.3.2 리스트 파티션
- 레인지 파티션과 가장 큰 차이는 키 값 하나하나를 리스트로 나열해야 한다.
- 또한 maxvalue 를 정의할 수 없음

#### 리스트 파티션 용도
- 파티션 키 값이 코드 값이나 카테고리와 같이 고정적일 때
- 키 값이연속되지 않고 정렬 순서와 관계없이 파티션을 해야 할 때
- 파티션 키 값을 기준으로 레코드의 건수가 균일하고, 검색 조건에 파티션 키가 자주 사용 될 때

#### 리스트 파티션 테이블 생성

```sql
CREATE TABLE product(
    id INT NOT NULL ,
    name VARCHAR(30),
    category_id INT NOT NULL
)
PARTITION BY LIST (category_id) (
    PARTITION pappliance VALUES IN (3),
    PARTITION pcomputer VALUES IN (1, 9),
    PARTITION psports VALUES IN (2, 6, 7),
    PARTITION petc VALUES IN (4, 5, 8, NULL)

    )
```

- PARTITION BY LIST 키워드로 생성
- PARTITION BY LIST 뒤에 파티션 키 정의
- VALUES IN (3)을 사용해 키 값의 목록 나열


#### 리스트 파티션의 분리와 병합
- 레인지 파티션의 추가, 삭제, 병합 작업이 모두 같음
- 병합과 분리 또한 같음

#### 리스트 파티션 주의 사항
- 명시되지 않은 나머지 값을 저장할 방법이 없음 
- NULL 저장 파티션 별도 생성 가능

### 10.3.3 해시 파티션
- MySQL에서 정의한 해시 함수에 의해 레코드가 저장될 파티션을 결정하는 방법
- 파티션 표현식의 결과값을 파티션의 개수로 나눈 나머지로 저장될 파티션을 결정하는 방식
- 파티션 키는 항상 정수 타입의 칼럼이거나 정수를 반환하는 표현식만 사용될 수 있다.
- 파티션을 추가하거나 삭제하는 작업에는 테이블 전체 적으로 레코드를 재분배 한다.

#### 해시 파티션의 용도
- 레인지 파티션이 리스트 파티션으로 데이터를 균등하게 나누는 것이 어려울 때
- 테이블의 모든 레코드가 비슷한 사용 빈도를 보이지만 테이블이 너무 커서 파티션을 적용해야 할 때

#### 해시 파티션 테이블 생성
```sql
-- // 파티션 개수만 지정할 때
create table tb_partition (
    fd1 int not null ,
    fd2 int not null ,
    fd3 int not null ,
    unique key (fd1, fd2, fd3),
    unique key (fd3)
) PARTITION BY HASH ( fd3)
PARTITIONS 4;
-- // 파티션 이름 별도 지정
create table tb_partition (
    fd1 int not null ,
    fd2 int not null ,
    fd3 int not null ,
    unique key (fd1, fd2, fd3),
    unique key (fd3)
) PARTITION BY HASH ( fd3)
PARTITIONS 4 (
    PARTITION p0 ENGINE=INNODB,
    PARTITION p1 ENGINE=INNODB,
    PARTITION p2 ENGINE=INNODB,
    PARTITION p3 ENGINE=INNODB
    );
```

- PARTITION BY HASH 키워드로 파티션 종류 지정
- PARTITION BY HASH 키워드 뒤에 키 명시
- PARTITIONS n 으로 몇 개의 파티션을 생성할 것인지 명시
  
#### 해시 파티션의 분리와 병합
- 분리와 병합시 모든 레코드를 재분배 하는 작업이 필요함
- 전체적인 파티션이 영향을 받음

- **해시 파티션 추가**
- 파티션 개수의 의해 파티션 알고리즘이 변하는 것이어서 모든 레코드가 재배치되야 함
```sql
-- // 단순 파티션 수만 명시
ALTER TABLE tb_partition ADD PARTITION PARTITIONS 8;
```

- **해시 파티션 삭제**
- 어떤 데이터를 특정할 수 없기 때문에 삭제하는 작업은 의미도 없고 해서도 안 될 작업
  

- **해시 파티션 분할**
- 분할 기능 없음

- **해시 파티션 병합**
- 통합 기능 없음


#### 해시 파티션 주의 사항
- 특정 파티션 drop 불가능
- 새로운 파티션 추가 작업은 데이터 재배치가 일어남


### 10.3.4 키 파티션
- 해시 파티션과 사용법과 특성이 거의 같음
- 해시 파티션은 해시 대상 컬럼이나 표현식을 사용자가 지정하지만 키 파티션은 모든것을 MySQL 서버가 수행



#### 키 파티션 생성
```sql
create table tb_partition (
                              fd1 int not null ,
                              fd2 int not null ,
                              fd3 int not null ,
                              unique key (fd1, fd2, fd3),
                              unique key (fd3)
) PARTITION BY KEY();
```
- PARTITION BY KEY 키워드로 정으 
- PARTITION BY KEY 뒤 키 칼럼 명시 가능, 아무것도 없으면 프라이머리 키나 유니크 키를 자동 배정
- PARTITIONS 키워드로 생성 개수 지정

### 10.3.5 리니어 해시 파티션/리니어 키 파티션
- 해시/키 파티션은 전체 레코드 재분배 작업이 발생
- 이것을 최소화 하기 위해 2의 승수 알고리즘을 이용한 리니어 파티션이 있음
- 일반적인 해시/키 파티션 보다는 건수가 덜 균등해질 수 있음

### 10.3.6 서브 파티션
- 예를 들면 레인지 파티션을 생성하고 그 파티션 내에서 다시 지역별로 서브 파티션을 구현 가능 
- MySQL에서는 최대 파티션 수가 제한적이라 이점이 별로 없음

### 10.3.7 파티션 테이블의 실행 계획
- 모든 파티션이 검색 대상인지 아니면 일부의 파티션만 읽는지는 성능에 큰 영향을 끼침
- 필요한 파티션만을 걸러내는 과정을 파티션 프루닝이라고 하는데, 쿼리의 성능은 테이블에서 얼마나 많은 파티션을 프루닝 할 수 있는지가 관건이다.
- 프루닝 정보를 확인하기 위해서는 explain partitions 사용해야 한다.

- explain partitions 명령으로 쿼리 실행 계획을 확인하면 'partitions' 라는 컬럼이 표시됨
- 프루닝을 사용하지 못하면 여기에 모든 파티션 이름이 명시
- 예측했던 파티셔니 맞는지 확인 필요

### 10.3.8 파티션 테이블 관련 벤치마킹

#### 테이블 크기
- 파티션을 사용했을 때 디스크의 공간적인 이점은 없음 

#### INSERT 성능 테스트
- 더 빠른 속도를 보여줌
- 다만 파티션이 많은 테이블은 앞에서 설명한 잠금 이슈로 인해서 오히려 속도가 떨어질 수 있음

#### SELECT 성능 테스트
- 최적화 상태라면 큰 성능 차이는 보여주지 않음

### 10.3.9 파티션 기능에 대한 결론
- select 쿼리 성능에는 그다지 큰 도움을 주지 못한
- 쓰기 성능에는 어느 정도 도움이 됨 
- insert 나 delete와 같은 쓰기 작업이 심각하게 느려지고 있다면 파티션 적용을 고려해 보는 것도 좋다.

# 11. 스토어드 프로그램
- 스토어드 루틴은 스토어드 프로시저, 함수, 트리거, 이벤트 등을 모두 아우르는 명칭

## 11.1 스토어드 프로그램 장단점

### 11.1.1 스토어드 프로그램 장점
#### 데이터베이스의 보안 향상
- 특정 테이블의 일기와 쓰기 도는 컬럼에 대해서만 권한을 설정할 수 있다.
#### 기능의 추상화
- 특정 기능을 여러 가지 언어로 개발할 필요가 없이 스토어드 프로그램으로 구현 가능
#### 네트워크 소요시간 절감
- 반복적인 쿼리 작업을 스토어드 프로그램으로 작업 한다면 네트워크 소요 시간을 절감할 수 있다.

#### 절차적 기능 구현
- 절차적 기능을 구현할 수 있다.
#### 개발 업무의 구분
- 구현된 기능을 api 처럼 사용 가능

### 11.1.2 스토어드 프로그램 단점
####  낮은 처리 성능
- MySQL 은 절차적 코드 처리 목적이 아니므로 처리 성능이 다른 프로그램 언어에 비해 상대적으로 떨어짐

#### 애플리케이션 코드의 조각화
- 기능이 언어 레벨의 어플리케이션과 MySQL 스토어드 프로그램으로 분산된다면 관리가 힘듬

## 11.2 스토어드 프로그램의 문법
  
### 11.2.1  예제 테스트 시 주의 사항
- 공백 설정
- 스레드 스택 크기 설정

### 11.2.2 스토어드 프로시저
- 서로 데이터를 주고 받아야 하는 여러 쿼리를 하나의 그룹으로 묶어서 독립적으로 실행하기 위해 사용
- 배치에서 첫번째 쿼리 결과를 이용해서 두 번째 쿼리를 실행해야 할때가 대표적이다.
- 스토어드 프로시저는 반드시 독립적으로 호출돼야 하며 select나 update 같은 sql 문장에서 스토어드 프로시저를 참조할 수 없다.

#### 스토어드 프로시저 생성 및 삭제
- create procedure 명령으로 생성
```sql
create procedure sp_sum(IN param1 INTEGER, IN param2 INTEGER, OUT param3 INTEGER )
BEGIN
    SET param3 = param1 + param2;
end;
```
- 스토어드 프로시저는 기본 반환값이 없다. 즉 프로시저 내부에서 RETURN 명령을 사용할 수 없다.
- 각 파라미터는 in, out, inout 타입을 가진다.
- in 파라미터는 프로시저 내부에서 읽기 전용, out 은 값을 전달하는 용도, inout 은 모두 가능
- 프로시저를 변경할 때는 alter procedure, 삭제할 때는 drop procedure를 사용
- 처리 내용 및 파라미터를 변경할 때는 alter 은 사용불가능
- 그렇기 때문에 삭제한 후 다시 생성하는 것이 유일한 방법

#### 스토어드 프로시저 실행
- select 쿼리에서 사용 불가능
- call 명령어로 실행
```sql
set @result:=0;
select @result;

call sp_sum(1, 2, @result);
select @result;
```

- 마지막 out 타입 파라미터는 값을 넘겨받아야 하기 때문에 세션변수를 사용해야 한다.


#### 스토어드 프로시저의 커서 반환
- 프로시저 내부에서 커서를 오픈하지 않거나 select쿼리의 결과 셋을 패치하지 않으면 해당 쿼리의 결과 셋은 클라이언트로 바로 전송된다.
- 해당 방법을 통해 로그를 대체하여 값을 화면에 표시하도록 할 수 있다.

### 11.2.3 스토어드 함수
- 스토어드 함수는 하나의 sql 문장으로 작성이 불가능한 기능을 하나의 sql 문장으로 구현해야 할 때 사용한다.
- 독립적으로 실행 가능하다면 프로시저를 사용하자
- 프로시저에 비해 유일한 장점은 SQL 문장으로 사용 할 수 있다는 것

#### 스토어드 함수 생성 및 삭제
- create function 명령어로 생성 가능
- 모든 입력 파라미터는 읽기 전용이라 in/out 명령어 불필요
- returns 키워드로 반환되는 값의 타입을 명시해야 함
```sql
create function sf_sun(param1 integer, param2 integer)
returns integer
begin
    declare param3 integer default 0;
    set param3 = param1 + param2;
    return param3;
end;

```

- 프로시저와 다른점
  - returns 로 반환 타입을 명시
  - 정의에 지정한 타입과 동일한 타입의 값을 return 명령으로 반환

- 단순 select 쿼리만을 실행해서는 안된다.
- 프로시저와 동일하게 alter 문을 통해 파라미터나 내용은 변경 못하고 스토어드 함수의 특성만 변경 가능

#### 스토어드 함수 실행
```sql
select sf_sun(1, 2) as sum;
```

### 11.2.4 xmflrj
- 레코드가 저장되거나 변경될 때 미리 정의해둔 작업을 자동으로 실행해주는 스토어드 프로그램
- 테이블 레코드가 insert/update/delete 될 때 설정 가능
- 사실 필요성이 많이 떨어짐
- 테이블에 대해서만 생성 가능
- 해당 테이블에 발생하는 조작에 대해 지정된 시점에 트리거 루틴 실행

#### 트리거 생성
- create trigger 명령어로 실행
- before이나 after 키워드로 이벤트를 명시할 수 있음
```sql
create trigger on_delete before delete on employees
    for each row
begin
    delete from salaries where emp_no = old.emp_no;
end;
```

- truncate / drop table 에서는 이벤트 발생 안함
- new / old 객체 사용가능, 각 객체는 변겨되기 이후와 이전 컬럼 값을 가지고 있다.

#### 트리거 실행
- 명시적 실행 방법은 없음
- 데이터 insert, delete, update 를 수행해서 작동을 확인

### 11.2.5 이벤트
- 특정한 시간에 스토어드 프로그램을 실행할 수 있는 스케줄러 기능을 이벤트라고 한다.


#### 이벤트 생성
- 일회성 이벤트와 반복성 이벤트가 있음

```sql
-- // 반복성 이벤트, 2011년 말까지 반복해서 실행하는 daily_ranking 이벤트
create event daily_ranking
    on schedule every 1 day starts '2011-01-01 01:00:00' ends '2011-12-31 12:59:59'
do
    insert into daily_ranking_log values(now(), 'Done');

-- // 일회성 이벤트, 1시간 뒤에 실행될 이벤트 등록
create event onetime_job
    on schedule at current_timestamp + interval 1 hour 
do
    insert into daily_ranking_log values(now(), 'Done');
```

- do 절에서는 하나의 쿼리나 스토어드 프로시저를 호출할 수 있고, begin...end 로 구성된 복합 절을 사용할 수 있다.

#### 이벤트 실행 및 결과 확인
- 스케줄링 결과나 실행 시간 정보는 mysql db의 event 테이블을 통해 조회하거나 INFORMATION_SCHEMA.event 테이블을 통해 조회할 수 있다.
- 하지만 두 테이블 데이터가 조금 차이가 나는데 그 이유는 타임존이 조금씩 다르기 때문이다.

### 11.2.6 스토어드 프로그램 본문 (Body) 작성
#### BEGIN ...END 블록과 트래잭션
- 하나의 BEGIN ...END 블록은 또다른 BEGIN ...END 블록을 포함할 수 있음
- BEGIN ...END 블록에서 주의해야 할 것은 트랜잭션 처리다.
- BEGIN ...END 블록에서 트랜잭션 시작은 'BEGIN' 명령어가 아니라 'START TRANSACTION' 을 사용
- 스토어드 프로시저나 이벤트의 본문에서만 트랜잭션을 사용할 수 있음

#### 프로시저 내부에서 트랜잭션 완료
- 내부에서 commit 이나 rollback 명령으로 트랜잭션을 완료하면 프로시저 외부에서 commit 이나 rollback 을 실행해도 의미가 없음

#### 프로시저 외부에서 트랜잭션 완료
- 내부와 동일하게 정상 작동
- 스토어드 프로시저 내부에서 트랜잭션을 완료할지, 호출하는 클라이언트에서 확인 과정을 거친 후에 커밋이나 롤백할지 고민해야 함

#### 변수
- 프로그램의 BEGIN ...END 블록 사이에서 사용하는 변수는 사용자 변수와 다르므로 혼동하지 않도록 주의 하자
- BEGIN ...END 변수를 로컬 변수라고 한다면 로컬 변수는 프로그램 내에서만 사용할 수 있다.
- 로컬 변수는 DECLARE 명령으로 정의되고 타입도 명시해야 한다.
- **DECLARE** 
  - 로컬 변수를 정의 하기 위한 명령어
  - 디폴트 값을 명시하지 않으면 NULL
  - 타입도 반드시 필요

- **SET**
  - DECLARE 로 정의한 변수에 값을 할당하는 명령어

- **SELECT ...INTO**
  - SELECT 한 값을 로컬 변수에 할당하는 명령어

- 변수 우선순위
  - DECLARE 로 정의한 변수 
  - 스토어드 프로그램의 입력 파라미터
  - 테이블의 컬럼

- 구분하기 위해 프리픽스를 사용하는것도 좋은 방법이다.

#### 제어문
- 대부분의 프로그래밍 언어와 흡사함
  
- **IF ... ELSEIF ... ELSE ... END IF**
```sql
create function sf_greatest(p_value1 int, p_value2 int)
    returns int
begin
    if p_value1 is null then
        return p_value2;
    elseif p_value2 is null then
        return p_value1;
    elseif p_value1 >= p_value2 then
        return p_value1;
    else
        return p_value2;
    end if;
end;
```


- **CASE WHEN ... THEN ... ELSE ... END CASE**
```sql
create function sf_greatest2(p_value1 int, p_value2 int)
    returns int
begin
    CASE
        WHEN p_value1 is null then
            return p_value2;
        WHEN p_value2 is null then
            return p_value1;
        WHEN p_value1 >= p_value2 then
            return p_value1;
        else
            return p_value2;
end case ;
end;
```

- **반복 루프**
- loop 구분에서는 반복문을 벗어나려면 leave 명령어 사용
- repeat 은  do while 과 유사
- while 구문은 일반적인 프로그래밍 언어와 유사

#### 핸들러와 컨디션을 이용한 에러 핸들링
- 안정적이고 견고한 스토어드 프로그램은 반드시 핸들러를 이용한 예외 처리를 해야함 

- **SQLSTATE와 에러 번호**
- 보통  'ERROR ERROR-NO (SQL-STATE) : ERROR-MESSAGE' 형태를 보임
- ERROR-NO
  - MySQL 에서만 유효한 식별 번호
- SQL-STATE
  - DBMS가 다르다고 하더라도 ANSI SQL 표준을 준수한 DBMS라면 모두 똑같은 의미를 가짐
- SQL-STATE로 핸들러를 정의 하는게 더 좋음

#### 핸들러
  
- DECLARE ... HANDLER 구문을 이용해 정의
```sql
DECLARE handler_type HANDLER
    FOR condition_value [,condition_value]...
    handler_statments
```
- handler_type이 continue로 정의되면 handler_statments를 실행하고 스토어드 프로그램의 마지막 실행 지점으로 다시 돌아가서 코드 처리
- handler_statments exit 로 정의 됐따면 이 핸들러가 정의된 begin ... end 불럭을 벗어남
- condition_value 같은 경우 여러 가지 형태의 값이 사용 가능
  - SQLSTATE sqlstate_value를 사용하면 SQLSTATE 일치할 때 실행되는 핸들러를 정의
- SQLWARNING 키워드는 코드를 실행하던 중 경고가 발생했을 때 실행 되는 핸들러를 정의
- NOT FOUND 키워드는 SELECT 건수가 1도 없을 때 발생
- SQLEXCEPTION 은 NOT FOUN, 정상처리 로 시작하는 SQLSTATE 외에 모든 케이스를 의미
- 사용자 정의 condition 정의 가능

#### 컨디션

- 핸들러는 이베트가 발생했을 때 실행할지를 명시하는 여러 가지 방법이 있는데 그 중 하나가 컨디션이다.
- SQLSTATE 는 가독성 측면에서 별로이다. 어떤 의미인지 조건의 이름을 등록하는 것이 컨디션이다ㅏ.
- SQLWARNING, NOT FOUND, SQLEXCEPTION 은 MySQL 에서 미리 만들어둔 컨디션이다.
  

#### 시그널을 이용한 예외 발생(MySQL 5.5 이상)
- 예외를 사용자가 직접 발생시킬 수 있는 기능
- java와 비교하면 핸들러는 catch 구문이고 시그널은 throw 구문에 해당한다.

#### 스토어드 프로그램의 BEGIN ... END 블럭에서 SINGLE 사용
```sql
create function sf_devide (p_dividend int, p_divisor int)
returns int
begin
    declare null_divisor condition for SQLSTATE '45000';

    if p_divisor is null then
        SIGNAL null_divisor set message_text = 'Divisor can not be null', MYSQL_ERRNO=9999;
    elseif p_divisor = 0 then
        SIGNAL sqlstate '45000' set message_text = 'Divisor can not be 0', MYSQL_ERRNO=9998;
    elseif p_dividend is null then
        SIGNAL sqlstate '01000' set message_text = 'Dividend is null, so regarding dividend as 0', MYSQL_ERRNO=9997;
    return 0;
    end if;

    return floor(p_dividend / p_divisor);
end;

```


#### 핸들러 코드에서 SIGNAL 사용
- 핸들러에서 SIGNAL명령어를 사용해서 발생된 에러나 예외를 다른 사용자 정의 예외로 변환해서 다시 던지는 것도 가능


#### 커서
- 스토어드 프로그램의 커서는 JDBC 프로그램에서 자주 사용하는 ResultSet이다.
- 다만 기능은 조금 제약적이다.
  - 스토어드 프로그램의 커서는 전방향 읽기만 가능하다.
  - 스토어드 프로그램에서는 커서의 컬럼을 바로 업데이트 하는 것이 불가능하다.
  
- 커서는 인센서티브 커서와 센서티브 커서로 구분 가능
  - 센서티브 커서
    - 센서티브 커서는 일치하는 레코드에 대한 정보를 실제 레코드의 포인터 만으로 유지하는 형태
    - 커서를 이용해 컬럼의 데이터를 변경하거나 삭제하는 것이 가능
  - 인센서티브 커서
    - 일치하는 레코드를 별도의 임시 테이블로 복사해서 가지고 있는 형태
    - 인센서티브 커서는 select 쿼리에 부합되는 결과를 복사해야 하기 때문에 느리다.

- 정의된 커서를 open 하면 실제로 쿼리가 실행되고 결과를 가져온다.
- 오픈된 커서는 패치 명령으로 레코드 단위로 읽어서 사용할 수 있다.
- 완료된 후에는 close 명령으로 커서를 닫아주면 자원이 모두 해제된다.

## 11.3 스토어드 프로그램의 권한 및 옵션
## 11.4 스토어드 프로그램의 참고 및 주의 사항

### 11.4.1 한글 처리
- 스토어드 프로그램의 소스 코드에 한글 문자열값을 사용해야 한다면 확인이 필요

### 11.4.2 스토어드 프로그램과 세션 변수
- 만약 스토어드 프로그램에서 세션(사용자) 변수를 사용할 경우, 세션 변수는 타입을 지정하지 않기 때문에 타입에 대해 안전하지 않다
- 또한 커넥션이 남아 있는 상태에서는 그 값을 유지한채 남아 있기 때문에 적절한 초기화가 필요하다.
  
### 11.4.3 스토어드 프로시저와 재귀 호출
- 스토어드 프로시저에서는 사용가능
- 너무 많은 반복은 스택이 터져버릴 수 있다.
- 최대 재귀 호출 횟수를 지정할 수 있음

### 11.4.4 중첩된 커서 사용
두개의 커서를 동시에 열어서 사용할 경우 예외 핸들링 부분에 주의해야 한다.