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