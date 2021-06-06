
-- 184. Department Highest Salary
SELECT d.NAME   AS Department,
       e.NAME   AS Employee,
       e.salary AS Salary
FROM   employee e
       LEFT JOIN department d
              ON e.departmentid = d.id
       LEFT JOIN (SELECT departmentid  AS Id,
                         Max(e.salary) AS Salary
                  FROM   employee e
                  GROUP  BY e.departmentid) AS sub
              ON d.id = sub.id
WHERE  sub.salary = e.salary


-- 178. Rank Scores
SELECT s.score,
       (SELECT Count(DISTINCT( score ))
        FROM   scores
        WHERE  score > s.score)
       + 1 AS `Rank`
FROM   scores s
ORDER  BY `rank`

-- {"headers": ["id", "select_type", "table", "partitions", "type", "possible_keys", "key", "key_len", "ref", "rows", "filtered", "Extra"],
-- [1, "PRIMARY", "s", null, "ALL", null, null, null, null, 6, 100.0, "Using temporary; Using filesort"],
-- [2, "DEPENDENT SUBQUERY", "scores", null, "ALL", null, null, null, null, 6, 33.33, "Using where"]]

--
SELECT s.score,
       sub.`rank`
FROM   scores s
       LEFT JOIN (SELECT DISTINCT(s.score ),
                                 (SELECT Count(DISTINCT( score ))
                                  FROM   scores
                                  WHERE  score > s.score)
                                 + 1 AS`Rank`
                  FROM  scores s) sub
              ON s.score = sub.score
ORDER  BY sub.`rank`

-- 테이블 좁히기
SELECT s.score,
       sub.`rank`
FROM   scores s
       LEFT JOIN (SELECT s.score,
                                 (SELECT Count(sub.score )
                                  FROM  (SELECT DISTINCT(score) FROM scores) sub
                                  WHERE  sub.score > s.score)
                                 + 1 AS`Rank`
                  FROM (SELECT DISTINCT(score) FROM scores) s) sub
              ON s.score = sub.score
ORDER  BY sub.`rank`


-- 가상 테이블 생성

WITH dis_scores AS
(
  SELECT DISTINCT(score) from scores
)


SELECT s.score,
       sub.`rank`
FROM   scores s
       LEFT JOIN (SELECT s.score,
                                 (SELECT Count(sub.score )
                                  FROM  dis_scores sub
                                  WHERE  sub.score > s.score)
                                 + 1 AS`Rank`
                  FROM dis_scores s) sub
              ON s.score = sub.score
ORDER  BY sub.`rank`


-- rank 사용
SELECT    s.score,
          sub.`rank`
FROM      scores s
LEFT JOIN
          (
                   SELECT   sub.score,
                            rank() OVER(ORDER BY sub.score DESC) AS `rank`
                   FROM     (
                                            SELECT DISTINCT(score)
                                            FROM            scores ) sub ) sub
ON        s.score = sub.score
ORDER BY  sub.`rank`
-- [1, "PRIMARY", "s", null, "ALL", null, null, null, null, 6, 100.0, "Using temporary; Using filesort"],
-- [1, "PRIMARY", "<derived2>", null, "ref", "<auto_key0>", "<auto_key0>", "3", "test.s.Score", 2, 100.0, null],
-- [2, "DERIVED", "<derived3>", null, "ALL", null, null, null, null, 6, 100.0, "Using filesort"],
-- [3, "DERIVED", "Scores", null, "ALL", null, null, null, null, 6, 100.0, "Using temporary"]]}



-- 185. Department Top Three Salaries





