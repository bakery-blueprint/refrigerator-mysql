# 1. 입양 시각 구하기(1) - level2
SELECT HOUR(DATETIME)   AS HOUR,
       COUNT(ANIMAL_ID) AS COUNT
FROM ANIMAL_OUTS
WHERE HOUR(DATETIME) >= 9
  AND HOUR(DATETIME) < 20
GROUP BY HOUR(DATETIME)
ORDER BY HOUR(DATETIME);

# 2. 입양 시각 구하기(2) - level4
WITH RECURSIVE Hours (n) AS (
    SELECT 0 AS a
    UNION ALL
    SELECT n + 1
    FROM Hours c
    WHERE n < 23
)
SELECT c.n     AS HOUR,
       IFNULL(o.COUNT, 0) AS COUNT
FROM Hours c
         LEFT JOIN (SELECT HOUR(DATETIME)   AS HOUR,
                           COUNT(ANIMAL_ID) AS COUNT
                    FROM ANIMAL_OUTS
                    GROUP BY HOUR(DATETIME)) o
                   ON o.HOUR = c.n
ORDER BY c.n;

# 3. 없어진 기록 찾기 - level3
SELECT o.ANIMAL_ID, o.NAME
FROM ANIMAL_OUTS o
         LEFT JOIN ANIMAL_INS i
                   ON i.ANIMAL_ID = o.ANIMAL_ID
WHERE i.ANIMAL_ID IS NULL;
