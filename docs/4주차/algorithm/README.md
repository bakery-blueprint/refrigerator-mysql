Article Views II
https://leetcode.com/problems/article-views-ii/

Market Analysis I
https://leetcode.com/problems/market-analysis-i/

Market Analysis II
https://leetcode.com/problems/market-analysis-ii/

7.3.3 ~ 7.4

## 7.3.3 MySQL 내장 함수 (397p)
DBMS의 종류과 관계없이 대부분의 SQL 함수는 동일하게 제공되지만 함수의 이름이나 사용법은 달라질 수 있다.
MySQL의 함수는 기본적으로 제공되는 내장함수와 사용자가 직접 C/C++ API를 사용해 추가할 수 있는 사용자 정의 함수 (UDF)로 구분된다.

### NULL 값 대체 : IFNULL, ISNULL
> hychul 알고리즘 4주차 2번  

- IFNULL : 해당 값이 NULL인 경우, 두번째 파라메터를 반환한다.  
- ISNULL : 해당 값이 NULL인 경우 TRUE(1), 아닌경우 FALSE(0)를 반환한다.

### 현재 시간 조회 : NOW, SYSDATE
두 함수 모두 현재 시간을 반환하지만 작동방식에 차이가 존재한다.

- NOW : 하나의 SQL문 안에서 항상 동일한 값을 반환한다.  
- SYSDATE : 같은 SQL문 안에서도 실제 호출되는 시점에 따라 다른 값을 반환한다.

쿼리가 오래 걸리는 경우 값이 달라지기 때문에 꼭 필요한 경우가 아니라면 SYSDATE 사용을 지양하는 편이 좋지만, 이미 사용하고 있다면 `sysdate-is-now` 같은 설정을 통해 NOW 처럼 동작하도록 설정할 것을 권장한다.

### 날짜와 시간 포맷 : DATE_FORMAT, STR_TO_DATE
| 지정문자 | 설명 |
| - | - |
| %Y | 4자리 년도 |
| %m | 2자리 숫자 월 |
| %d | 2자리 숫자 일 |
| %H | 2자리 숫자 시 |
| %i | 2자리 숫자 분 |
| %s | 2자리 숫자 초 |

포맷을 사용하여 TEXT - DATE 간의 변환을 지원한다.

### 날짜와 시간 연상 : DATE_ADD, DATE_SUB
특정 날짜나 시간의 연상에서 사용된다.  
DATE_ADD 만으로도 파라메터를 통해 빼기가 가능하기 때문에 DATE_SUB 가 크게 필요하지 않다.

두번째 파라메터로 숫자 이외에 단위를 `INTERVAL n [YEAR, MONTH...]` 형태로 입력해야한다.

| 키워드 | 설명 |
| - | - |
| YAER | 년도 |
| MONTH | 월 |
| DAY | 일 |
| HOUR | 시 |
| MINUTE | 분 |
| SECOND | 초 |
| QUARTER | 분기 |
| WEEK | 주 |

### 타임 스탬프 연산 : UNIX_TIMESTAMP, FROM_UNIXTIME
- UNIX_TIMESTAMP : '1970-01-01 00:00:00'을 기준으로 현재까지 경과된 초의 수를 반환한다.
- FROM_UNIXTIME : UNIX 타임 스탬프를 DATE로 변환한다.

> Unix 타임 스탬프는 4바이트로 저장되기 때문에 1970-01-01 00:00:00 ~ 2038-01-09 03:14:07 사이의 값만 저장이 가능하다.  

### 문자열 처리 : RPAD, LPAD / RTRIM, LTRIM, TRIM
- RPAD : 문자열 우측에 문자를 덧붙여서 지정된 길이의 문자열로 변환한다. 
- LPAD : 문자열 좌측에 문자를 덧붙여서 지정된 길이의 문자열로 변환한다.

```sql
mysql > SELECT RPAD('Cloee', 10, '_');
+------------------------------+
| Clee______                   |
+------------------------------+
mysql > SELECT LPAD('123', 10, '0');
+------------------------------+
| 0000000123                   |
+------------------------------+
```

- RTRIM : 문자열 우측에 연속된 공백 문자를 제거한다.
- LTRIM : 문자열 좌측에 연속된 공백 문자를 제거한다.
- TRIM : 문자열 우측과 좌측의 연속된 공백 문자를 제거한다.

### 문자열 결합 : CONCAT, CONCAT_WS
- CONCAT : 여러개의 문자열을 하나의 문자열로 빤환하는 함수이다.
- CONCAT_WS : CONCAT과 동일하게 문자열을 합쳐주지만, 구분자를 추가해준다는 차이점이 있다.

### GROUP BY 문자열 결합 : GROUP_CONCAT
COUNT(), MAX(), MIN(), AVG() 와 같은 그룹 함수 중 하나이다.  
주로 GROUP BY와 함께 사용하며, GROUP BY가 없는 경우 단일 값을 반환한다.
구분자나 정렬 순서등을 설정하여 사용할 수 있다.

```sql
mysql> SELECT GROUP_CONCAT(dept_no) FROM department;
+----------------------------------------------+
| d001,d002,d003,d004,d005,d006,d007,d008,d009 |
+----------------------------------------------+

mysql> SELECT GROUP_CONCAT(dept_no SEPARATOR '|') FROM department;
+----------------------------------------------+
| d001|d002|d003|d004|d005|d006|d007|d008|d009 |
+----------------------------------------------+

mysql> SELECT GROUP_CONCAT(dept_no ORDER BY dept_name DESC) FROM department;
+----------------------------------------------+
| d007,d008,d006,d004,d001,d003,d002,d005,d009 |
+----------------------------------------------+
```

### 값의 비교와 대체 : CASE WHEN ... THEN ... END
> hychul 알고리즘 4주차 3번

CASE WHEN는 함수가 아니라 SQL 구문이다.  
프로그래밍 언어의 switch 문과 동일하게 사용되며 CASE로 시작하고 반드시 END로 끝나야 한다.  
WHEN ... THEN ... 구문은 뭔하는 만큼 반복하여 사용할 수 있고, ELSE를 통해 WHEN 절 이외의 값을 처리 할 수 있다.

### 타입의 변환 : CAST, CONVERT
Prepare Statement를 제외하면 SQL은 텍스트를 기반으로 작동한다.
- CAST : 명시적으로 타입을 변환한다 : DATE, TIME, DATETIME, BINARY, CHAR, DECIMAL, SIGNED INTEGER, UNSIGNED INTEGER
- CONVERT : CAST와 같이 타입을 변환하고 USING 절을 사용하는 경우 문자열의 Character Set을 변환할 수 있다.

> Prepare Statement  
> 
> `PREPARE [stmt_name] FROM '[query]';`  
> PREPARE, EXECUTE, DEALLOCATE PREPRE 순서로 동작한다.  
> PREPARE에서 ? 문자를 통해 파라메터를 설정하고, EXECUTE에서 바인딩을 통해 ?에 값을 할당하여 구문이 수행된다.  
> ```sql
> mysql> PREPARE stmt1 FROM 'SELECT SQRT(POW(?,2) + POW(?,2)) AS hypotenuse'; 
> mysql> SET @a = 3; 
> mysql> SET @b = 4; 
> mysql> EXECUTE stmt1 USING @a, @b;
> +------------+ 
> | hypotenuse | 
> +------------+ 
> |          5 | 
> +------------+ 
> mysql> DEALLOCATE PREPARE stmt1;
> ```

### 이진값과 16진수 문자열 변환 : HEX, UNHEX
- HEX : 사람이 읽을 수 있는 16진수 문자열로 변환
- UNHEX : 16진수 문자열을 읽어 이진값 (BINARY)로 변환

### 암호화 및 해시 함수 : MD5, SHA
비대칭형 암호화 알고리즘으로, 인자로 전달한 문자열을 각각지정된 비트 수의 해시값을 만들어낸다.
- MD5 : 메세지 다이제스트<sup>Message Digest</sup> 알고리즘을 사용해 128비트 해시값을 반환한다.
- SHA : SHA-1 암호화 알고리즘을 사용하여 160비트 해시 값을 반환한다.

```sql
mysql> SELECT MD5('abc')
+----------------------------------+
| 900150983cd24fb0d6963f7d28e17f72 |
+----------------------------------+
mysql> SELECT SHA('abc')
+------------------------------------------+
| a9993e364706816aba3e25717850c26c9cd0d89d |
+------------------------------------------+
```

두 함수 모두 비대칭 암호화 알고리즘을 사용하고, 결과 값이 중복 가능성이 매우 낮기 때문에 길이가 긴 데이터의 크기를 줄여 인데싱하는 용도로 사용된다.

### 처리 대기 : SLEEP
- SLEEP : 함수가 호출될 때 마다 (레코드의 로우수 만큼) 일정시간 대기한다.

### 벤치마크 : BENCHMARK
- BENCHMARK : 반복해서 수행할 횟수, 스칼라 값을 반환하는 표현식을 파라메터로 받아 해당 표현식이 수행되는데 걸리는 시간을 보여준다.

### IP 주소 변환 : INET_ATOM, INET_NTOA
- INET_ATOM : IP 문자열을 정수형으로 변환한다.
- INET_NTOA : 정수형 IP를 문자열로 변환한다.

### MySQL 전용 암호화 : PASSWORD, OLD_PASSWORD
일반 사용자가 사용해서는 안된다.  
이 함수의 알고리즘이 4.1 부터 변경이 되었고 앞으로도 변경될 가능성이 존재한다.  
때문에 MySQL 유저의 비밀번호를 관리하기 위한 함수이지, 일반 서비스의 고객 정보를 위해 사용할 때는 적합하지 않다.

고객 정보에 사용할 때는 MD5() 혹은 SHA 알고리즘을 사용하는 것이 좋다.

### VALUES()
INSERT INTO ... ON DUPLICATE KEY UPDATE ... 문장에서만 사용할 수 있다.  
REPLACE와 비슷한 기능의 쿼리 문장인데, UPSERT로 동작하는 문장이다.  
VALUES()를 사용하면 컬럼에 INSERT 하려고 했던 값을 참조하는 것이 가능하다.

```sql
INSERT INTO tab_statistics (member_id, visit_count)
  SELECT student_id, COUNT(*) AS cnt
  FROM tab_statistics
  GROUP BY member_id
ON DUPLICATE KEY
  UPDATE visit_count = visit_count + VALUE(visit_count);
```

### COUNT()
결과 레코드의 로우 수를 반환하는 함수이다.

COUNT(*) 와 같은 표현을 사용할 때 LEFT JOIN이나 ORDER BY 와 함께 사용하면 소용이 없다.

COUNT() 함수를 컬럼명이나 표현식과 함께 사용할 때, 결과값이 NULL이 아닌 레코드의 갯수만 반환한다. 때문에 NULL 값을 갖는 컬럼에서 사용할 때 유의해야한다.

### 부록: RANK(), DENSE_RANK()
MySQL 함수에서 설명하지 않아 따로 추가했다.  
인자로 컬럼명이나 DISTINCT, ORDER BY 등의 구문과 함께 사용하여 해당 컬럼의 순서를 1부터 반환한다.
RANK()의 경우 동일한 랭크가 존재한다면 그 다음 랭크는 해당 랭크의 갯수만큼 증가한 값을 갖지만, DENSE_RANK()의 경우 중복 값과 상관없이 +1 만큼 증가하는 랭크를 갖는다.

## 7.3.4 SQL 주석
SQL에서 정의하는 두가지 방식의 주석을 모두 지원한다.
```sql
-- comment for single line

/*
comment 
for 
multiple 
line
*/
```

셸 스크립트에서 지원하는 '#' 문자를 통한 주석도 지원한다.
```sql
# comment for single line
```

'/*' 주석에 띄어쓰기 없이 '!' 문자를 붙여 변형된 C 언어 스타일의 주석도 사용이 가능하다.  
해당 주석은 선택적인 처리나 힌트를 주는 두가지 방식으로 동작한다.

5.0 부터 프로시저에 의해 주석이 모두 삭제되기도 하는데 C 언어 스타일의 주석은 이를 막기 위해 사용되기도 한다.

# 7.4 SELECT
여러 개의 테이블로부터 데이터를 조합해서 빠르게 가져와야하기 때문에 여러 개의 테이블을 어떻게 읽을 것인가에 많은 주의를 기울여야 한다.

## 7.4.1 SELECT 각 절의 처리 순서
```sql
SELECT s.emp_no, COUNT(DISTINCT e.first_name) AS cnt
FROM salaries s
  INNER JOIN employee e ON e.emp_no = s.emp_no
WHERE s.emp_no IN (10001, 10002)
GROUP BY s.emp_no
HAVING AVG(s.salary) > 1000
ORDER BY AVG(s.salary)
LIMIT 10;
```
SELECT 문장에서 어느 절이 먼저 실행되는지 모르면 내용이나 처리 결과를 예측할 수 없다.  

`[드라이빙 테이블 -(JOIN)- 드리븐 테이블 -(WHERE)- 드리븐 테이블] - GROUP BY - DISTINCT - HAVING - ORDER BY - LIMIT`

대부분의 경우 위의 순서가 바뀌어 동작하는 경우는 거의 없다. 또한 SQL에는 ORDER BY 나 DISTINCT 절이 있다고 하더라도 인덱스를 통해 처리할 때는 그 단계가 불필요하므로 생략된다.

위의 실행 순서를 벗어난 쿼리가 필요하다면 서브 쿼리로 작성된 인라인 뷰를 사용해야한다. LIMIT을 먼저 적용하고 ORDER BY를 실행하려면 다음과 같이 변경해야한다.

```sql
SELECT emp_no, first_name, max_salary
FROM (
  SELECT s.emp_no, COUNT(DISTINCT e.first_name) AS cnt
  FROM salaries s
    INNER JOIN employee e ON e.emp_no = s.emp_no
  WHERE s.emp_no IN (10001, 10002)
  GROUP BY s.emp_no
  HAVING AVG(s.salary) > 1000
  LIMIT 10
) temp_view
ORDER BY max_salary;
```

## 7.4.2 WHERE 절과 GROUP BY 절, 그리고 ORDER BY 절의 인덱스 사용
앞서 GROUP BY, ORDER BY 절에서 인덱스를 사용해 빠르게 처리할 수 있다고 언급하였다.  
인덱스를 사용하기 위해 조건을 알아본다.

### 인덱스를 사용하기 위한 기본 규칙
**기본적으로 인덱스된 컬럼의 값 자체를 변환하지 않고 그대로 사용하는 조건을 만족해야한다.**  
인덱스와 같이 WHERE 조건이나 GROUP BY, ORDER BY 절에선 원본값을 검색하거나 정렬할 때만 B-Tree를 사용한다.  

추가로 **WHERE 절에 사용되는 비교 조건에서 연산자의 양쪽의 비교 대상 값은 데이터 타입이 일치해야한다.**  

### WHERE 절의 인덱스 사용
WHERE 절에서 인덱스를 사용하는 방법은 크게 범위 제한 조건과 체크 조건으로 두 가지 방식으로 구분해 볼 수 있다.  
범위 제한 조건은 동등 비교 조건이나 IN으로 구성된 비교 조건이 인덱스를 구성하는 컬럼과 얼마나 좌측부터 일치하는가에 따라 달라진다.

```sql
INDEX(A, B, C)
```
위와 같은 인덱스가 존재할 떄 
A = '1', B > 2, C = '3'
로 구성된 비교 연산자의 AND 조합이 존재할 경우 연산자의 순서와 상관없이 인덱스를 설정한 컬럼의 순서에 따라서 C 컬럼의 비교 연산자는 범위 연산자로 구성되지 못하고 체크 연산자로 동작하게 된다.

OR로 연산자가 조합되는 경우 옵티마이저는 뒤에 설정된 컬럼의 인덱스에 대해서 풀스캔을 할 수 밖에 없다. 때문에 WHERE 절에 OR 연산자가 있다면 주의해야한다.

### GROUP BY 절의 인덱스 사용
비교 연산자를 가지지 않기 때문에 범위 제한 조건을 고려할 필요는 없다.  
GROUP BY 절에 명시돈 컬럼의 순서가 인덱스를 구성하는 컬럼의 순서와 같으면 인덱스를 사용할 수 있다.  

- GROUP BY 절에 명시된 컬럼이 인덱스 컬럼의 순서와 위치가 같아야 한다.
- 인덱스를 구성하는 컬럼 중에서 뒷쪽에 있는 컬럼은 GROUP BY 절에 명시되지 않아도 인덱스를 사용할 수 있지만, 인덱스 앞쪽에 있는 컬럼이 GROUP BY 절에 명시되지 않으면 인덱스를 사용할 수 없다.
- WHERE 절과 달리 GROUP BY 절에 명시된 컬럼이 하나라도 인덱스에 존재하지 않으면 인덱스를 사용하지 못한다.

### ORDER BY 절의 인덱스 사용
GROUP BY와 처리 방법이 상당히 비슷한다. 하지만 ORDER BY 절에선 조건이 하나 더 존재하는데, 정렬되는 각 컬럼의 오름차순 및 내림차순 옵션이 인덱스와 같거나 또는 정반대의 경우에만 사용할 수 있다.  

- ORDER BY 절에 명시된 컬럼이 인덱스 컬럼의 순서와 위치가 같아야 한다.
- 인덱스를 구성하는 컬럼 중에서 뒷쪽에 있는 컬럼은 ORDER BY 절에 명시되지 않아도 인덱스를 사용할 수 있지만, 인덱스 앞쪽에 있는 컬럼이 GROUP BY 절에 명시되지 않으면 인덱스를 사용할 수 없다.
- WHERE 절과 달리 ORDER BY 절에 명시된 컬럼이 하나라도 인덱스에 존재하지 않으면 인덱스를 사용하지 못한다.
- MySQL의 인덱스는 오름차순으로 정렬이 되기 때문에, ORDER BY 절의 모든 컬럼이 오름차순이거나 모두 내림차순일 때에만 인덱스가 동작한다.

### WHERE 조건과 ORDER BY(혹은 GROUP BY) 절의 인덱스 사용
WHERE과 ORDER BY 절의 사용
- WHERE 절과 ORDER BY 절이 동시에 같은 인덱스를 사용
- WHERE 절만 인덱스를 사용
- ORDER BY 절만 인덱스를 사용
WHERE 절과 ORDER BY에서 중첩되어 인덱스를 사용하는 부분은 문제가 되지 않지만, 빠지는 부분은 WHERE와 ORDER BY 모두 인덱스를 사용할 수 없다.

GROUP BY의 조합도 동일한 기준이 적용된다. WHERE와 ORDER BY, GROUP BY 절의 조합에서 인덱스 사용 여부를 판단하는 능력을 중요하므로 여러 가지 경우에 대해서 직접 테스트하는 것이 좋다.

### GROUP BY 절과 ORDER BY 절의 인덱스 사용
GROUP BY절과 ORDER BY 절에서 사용된 컬럼과 순서와 내용이 모두 같아야 한다. 두 절 중 하나라도 인덱스를 사용하지 못하는 경우엔 인덱스를 사용하지 못한다.  
MySQL에서 GROUP BY 절는 컬럼에 대한 정렬까지 수행하기 때문에 ORDER BY 절을 생략해도 동일하게 동작한다. 물론 ORDER BY를 추가하더라도 별도의 작업이 추가적으로 발생하지 않는다.

### WHERE 조건과 ORDER BY 절, 그리고 GROUP BY 절의 인덱스 사용
세 절이 조합된 SQL문의 경우 다음의 세가지 질문을 통해 인덱스의 동작 여부를 알 수 있다.

- WHERE 절이 인덱스를 사용할 수 있는가?
- GROUP BY 절이 인덱스를 사용할 수 있는가?
- GROUP BY 절과 ORDER BY 절이 동시에 인덱스를 사용할 수 있는가?

## 7.4.3 WHERE 절의 비교 조건 사용시 주의사항
WHERE 절의 비교 조건의 표현식은 인덱스와 함께 사용되게 하기 위해 상당히 중요하다.

### NULL 비교
MySQL에서는 NULL 값이 포함된 레코드도 인덱스로 관리된다.  
ISNULL() 함수를 사용하는 경우 인덱스를 사용하지 못하기 때문에 IS NULL 표현식의 사용을 권장한다.

### 문자열이나 숫자 비교
문자열이나 숫자에 맞는 타입을 사용하여 비교할 것을 권장한다.

### 날짜 비교
MySQL의 날짜는 그 타입이 다양하기 때문에 비교의 경우 주의해야한다.

#### DATE나 DATETIME 문자열 비교
DATE나 DATETIME 타입의 값과 문자열을 비교할 땐 문자열을 자동으로 타입으로 내부적으로 변환하여 비교한다.  
비교하는 값에 함수를 통해 변환하는 것은 상관없지만 인덱스가 존재하는 컬럼을 함수로 변환하는 경우 인덱스를 사용할 수 없게 된다.

#### DATE나 DATETIME 비교
문자열과 마찬가지로 면시적으로 변환하지 않더라도 내부적으로 변환하여 비교한다.

#### DATETIME과 TIMESTAMP의 비교
명시적으로 변환하지 않더라도 내부적으로 변환하여 비교하지만 인덱스를 사용하진 못한다.  
UNIX_TIMESTAMP() 함수를 사용해 TIMESTAMP 값을 DATETIME과 비교한다면 FROM_UNIXTIME() 함수를 사용하며 DATETIME을 TIMESTAMP로 변환하여 비교해야한다.

## 7.4.4 DISTINCT
컬럼의 유니크한 값을 조회하기 위해 사용한다.  

### SELECT DISTINCT ... : 집합함수와 사용되지 않은 경우
GROUP BY와 거의 같은 방식으로 사용되지만, 정렬이 보장되지 않는다.  

DISTINCT는 유니크한 레코드를 조회하기 위해 사용된다 그리고 DISTINCT는 함수가 아니기 때문에 괄호안에 컬럼은 MySQL에 의해서 제거되어 실행된다.

### 집합함수와 사용된 경우
SELECT에서의 DISTINCT는 레코드에서 유일한 값을 조회하지만, 집합 함수와 함께 사용된 DISTINCT의 경우 컬럼의 조합 가운데 유일한 값을 조회한다.

## 7.4.5 LIMIT n
오라클과 달리 항상 마지막에 동작하며 WHERE 절의 조건에 일치하는 레코드를 전부 구한 후에 동작하게 된다.

## 7.4.6 JOIN

- 두 칼럼 모두 각각 인덱스가 있는 경우 : 모든 경우에 대해서 드라이빙 테이블에 대한 인덱스를 사용할 수 있다.
- 한쪽에만 인덱스가 있는 경우 : 풀스캔을 막기 위해 인덱스가 없는 테이블을 옵티마이저가 드라이빙 테이블로 선택한다.
- 두 컬럼 모두 인덱스가 없는 경우 : 풀 스캔이 발생하기 때문에 옵티마이저가 적절히 드라이빙 테이블을 선택한다.

### JOIN 컬럼의 데이터 타입
조인 컬럼 간의 비교에서 각 컬럼의 데이터 타입이 일치하지 않으면 인덱스가 동작하지 않는다.

[중략]

## 7.4.7 GROUP BY

### 사용시 주의사항
GROUP BY 절에 명시되지 않은 컬럼은 일반적으로 집합 함수로 감싸서 사용해야한다.

### GROUP BY ... ORDER BY NULL
ORDER BY NULL 을 사용하여 GROUP BY가 불필요한 정렬을 하지 않도록 할 수 있다.

### GROUP BY col1 ASC col2 DESC
정렬 순서를 명시할 수 있다.

### GROUP BY ... WITH ROLLUP
WITH ROLLUP을 사용하여 그룹핑된 값의 소계 레코드를 추가할 수 있다. 소계 레코드는 NULL값을 가진다.

## 7.4.8 ORDER BY
검색된 레코드를 어떤 순서로 정렬할 지 결정한다.

### 사용시 주의사항
ORDER BY 뒤의 상수값을 통해 몇 번째의 컬럼으로 정렬할지 결정할 수 있지만 이 경우 인덱스를 사용하지 못하게 된다.

## 7.4.9 SUB QUERY
서브 쿼리를 사용하면 단위 처리별로 쿼리를 독립시킬 수 있다. 하지만 MySQL에서 서브 쿼리는 최적으로 실행하지 못할 떄가 많다.  

- 상관 서브 쿼리 : 외부에서 정의된 테이블을 참조하는 경우. 외부 쿼리는 서브 쿼리 이후 동작하기 때문에 범위 조건으로 사용되지 못한다.
- 독립 서브 쿼리 : 독립적으로 서브 쿼리만을 먼저 사용하며 범위 조건으로 사용할 수 있지만 MySQL에선 제약 사항이 존재한다.

### 서브 쿼리의 제약 사항
  
### SELECT 절에 사용된 서브 쿼리
SELECT 절에 사용된 서브 쿼리의 경우 임시 테이블을 생성하지 않기 때문에 크게 주의할 사항은 없다.

### WHERE 절에 단순 비교를 위해 사용된 서브 쿼리
독립 서브 쿼리가 먼저 실행되어 상수로 변환하는게 효율적이지만 MySQL은 풀스캔을 해버린다.

### FROM 절에 사용된 서브 쿼리
FROM 절에 사용된 서브 쿼리는 항상 임시 테이블을 생성하기 때문에 조인 쿼리로 변경하는 것이 좋다.

## 7.4.10 집합 연산
조인이 테이블의 컬럼을 연결하는 것이라면 집합 연산을 레코드를 연결하는 것이다.

### UNION
두개의 집합을 하나로 묶는 역할을 한다.  

두 집합의 중복 레코드를 제거하는 경우 UNION (DISTINCT), 유지하는 경우 UNION ALL로 나뉘어 진다.  
중복의 판단은 임시 테이블을 통해 동작시키기 때문에 중복 되는 경우가 없는 경우 UNION ALL을 권장한다.

### INTERSECT
두 집합 중 교집합만 가져오는 쿼리로 INTERSECT의 연산은 INNER JOIN과 동일하다는 것을 알 수 있다.  
INNER JOIN의 연산이 더 빠르기 때문에 INNER JOIN을 사용하는 것을 권장한다.

### MINUS
첫번째 집합에서 두번째 집합을 빼는 것이다... MySQL에서는 지원도 안되는데 왜...
NOT EXIST나 LEFT JOIN을 통해 구현할 수 있는데 LEFT JOIN의 성능이 더 좋기 때문에 조인을 사용할 것을 권장한다.

## 7.4.11 LOCK IN SHARE MODE와 FOR UPDATE
InnoDB에선 SELECT 시에 테이블에 락을 걸지 않지만, 다른 트랜젝션에서 값을 변경하지 못하게 하기 위해 락이 필요한 경우에 사용한다.

- LOCK IN SHARE MODE : Shared Lock을 설정한다.
- FOR UPDATE : Exclusive Lock을 설정한다.

## 7.4.12 SELECT INTO OUTFILE
결과를 파일로 저장하게 할 수 있다.

- MySQL이 동작중인 서버에 저장된다.
- 서버를 기동중인 운영체제의 계정이 쓰기 권한을 갖고 있어야한다.
- 동일한 이름의 파일이 있는 경우 에러를 발생시키고 종료한다.
