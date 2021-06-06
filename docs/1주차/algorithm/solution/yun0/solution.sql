### 1
SELECT product_id
FROM Products
WHERE low_fats = 'Y'
  AND recyclable = 'Y'
;

### 2
SELECT a.sale_date,
       a.sold_num - o.sold_num AS diff
FROM Sales a
         LEFT JOIN
     Sales o
     ON a.sale_date = o.sale_date
         AND o.fruit = 'oranges'
WHERE a.fruit = 'apples'
ORDER BY a.sale_date
;

SELECT a.sale_date,
       sum(CASE
               WHEN a.fruit = 'apples'
                   THEN a.sold_num
               WHEN a.fruit = 'oranges'
                   THEN - a.sold_num
           END) AS diff
FROM Sales a
GROUP BY a.sale_date
ORDER BY a.sale_date
;

WITH Apples AS (
    SELECT *
    FROM Sales
    WHERE fruit = 'apples'
),
     Oranges AS (
         SELECT *
         FROM Sales
         WHERE fruit = 'oranges'
     )
SELECT A.sale_date,
       sum(A.sold_num) - sum(O.sold_num) AS diff
FROM Apples A
         LEFT JOIN
     Oranges O
     ON A.sale_date = O.sale_date
GROUP BY A.sale_date
;


### 3
WITH RECURSIVE Counts (n) AS (
    SELECT 1 AS a
    UNION ALL
    SELECT n + 1
    FROM Counts c
    WHERE n <= 20
)
SELECT T.task_id,
       C.n AS subtask_id
FROM Tasks T
         LEFT JOIN
     Counts C
     ON C.n <= T.subtasks_count
         LEFT JOIN
     Executed E
     ON T.task_id = E.task_id
         AND C.n = E.subtask_id
WHERE E.subtask_id IS NULL
;
