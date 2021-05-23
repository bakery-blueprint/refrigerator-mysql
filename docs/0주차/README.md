# 0주차 

## MySQL 

1995년에 발표된 오픈 소스 DBMS. '마이에스큐엘'이라고 읽는다. 'SQL' 부분을 '스큐엘'로 읽는게 공식인[1] PostgreSQL과는 달리 MySQL은 SQL을 '에스큐엘'로 끊어서 읽는게 공식으로 정해진 발음이다.

제작사는 MySQL AB이다. 이 회사는 썬 마이크로시스템즈에게 10억 달러에 인수되었는데, 이후 2010년 오라클이 썬을 72억 달러에 인수하면서 같이 넘어갔다. 따라서 MySQL의 실질적인 소유주는 오라클이다. 그런데 오라클은 자체 상용 DBMS인 오라클 데이터베이스를 가지고 있고, 오픈 소스에 대해 호의적이지 않은데다 프로그램이 갈수록 복잡해지고 있어서 MySQL 사용자들 사이에서도 불안감이 커지고 있다.

그래서 오픈 소스 진영에서 MySQL을 모태로 MariaDB라는 DBMS를 만들었다. 리눅스 배포판 중 페도라와 오픈수세는 MySQL을 버리고 MariaDB를 장착했다. 기사1 기사2 애플은 OS X 서버 버전에서 MySQL을 버리고 PostgreSQL을 채용했다.

상징 동물은 돌고래이다.




## leetcode 알고리즘 예시

### 595. Big Countries 

https://leetcode.com/problems/big-countries/

There is a table World

+-----------------+------------+------------+--------------+---------------+
| name            | continent  | area       | population   | gdp           |
+-----------------+------------+------------+--------------+---------------+
| Afghanistan     | Asia       | 652230     | 25500100     | 20343000      |
| Albania         | Europe     | 28748      | 2831741      | 12960000      |
| Algeria         | Africa     | 2381741    | 37100000     | 188681000     |
| Andorra         | Europe     | 468        | 78115        | 3712000       |
| Angola          | Africa     | 1246700    | 20609294     | 100990000     |
+-----------------+------------+------------+--------------+---------------+
A country is big if it has an area of bigger than 3 million square km or a population of more than 25 million.

Write a SQL solution to output big countries' name, population and area.

For example, according to the above table, we should output:

+--------------+-------------+--------------+
| name         | population  | area         |
+--------------+-------------+--------------+
| Afghanistan  | 25500100    | 652230       |
| Algeria      | 37100000    | 2381741      |
+--------------+-------------+--------------+


