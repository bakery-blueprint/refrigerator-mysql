## 1
SELECT ANIMAL_TYPE, COUNT(ANIMAL_TYPE) as count
FROM ANIMAL_INS
WHERE 1=1
GROUP BY ANIMAL_TYPE
ORDER BY COUNT(ANIMAL_TYPE) ASC

## 2
WITH RECURSIVE CTE AS (
SELECT ID, NAME, HOST_ID
FROM PLACES
WHERE 1=1
GROUP BY HOST_ID
HAVING COUNT(HOST_ID) >= 2
)

SELECT P.ID, P.NAME, P.HOST_ID
FROM PLACES P
INNER JOIN CTE C
ON  P.HOST_ID = C.HOST_ID
;

## 3
SELECT DISTINCT A.CART_ID
FROM (
        SELECT  ID, CART_ID, NAME, PRICE
        FROM CART_PRODUCTS
        WHERE NAME = 'Yogurt'
    ) A
INNER JOIN
    (
    SELECT  ID, CART_ID, NAME, PRICE
    FROM CART_PRODUCTS
    WHERE NAME = 'Milk'
    ) B
ON A.CART_ID = B.CART_ID
;