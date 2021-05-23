# Refrigerator-MySQL

지옥에서 온 MySQL 

### 책 && 알고리즘

- 책 : https://book.naver.com/bookdb/book_detail.nhn?bid=6886962
- 알고리즘 : https://leetcode.com/problemset/database/


### 스터디 방법

- 수업 리딩 (2장)
- 알고리즘 리뷰 (3문제)
- 다음 알고리즘 문제 선택

### 스터디 시간 및 장소

- 화요일 20시 ~ 22시
- 온라인 진행

### 벌금

- 결석 : 2만원
- 지각 : 30분당 5천원
- 과제 : 1만원

최소 5일전 변경 가능 


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

- solution
~~~sql
SELECT name, population, area FROM World WHERE area > 3000000 OR population > 25000000;
~~~

