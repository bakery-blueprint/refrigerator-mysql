
-- 오랜 기간 보호한 동물(1)
SELECT ins.name, ins.DATETIME FROM ANIMAL_INS ins LEFT JOIN ANIMAL_OUTS outs on ins.ANIMAL_ID = outs.ANIMAL_ID
WHERE outs.ANIMAL_ID IS NULL
ORDER BY ins.DATETIME
LIMIT 3

-- 헤비 유저가 소유한 장소
SELECT PLACES.ID, PLACES.NAME, PLACES.HOST_ID from
(SELECT HOST_ID FROM PLACES
GROUP BY HOST_ID
HAVING count(HOST_ID) >= 2
) as heavy LEFT JOIN PLACES on heavy.HOST_ID = PLACES.HOST_ID
ORDER BY PLACES.ID

id	select_type	table	partitions	type	possible_keys	key	key_len	ref	rows	filtered	Extra
1	PRIMARY			ALL					14	100	Using temporary; Using filesort
1	PRIMARY	PLACES		ALL					14	100	Using where; Using join buffer (hash join)
2	DERIVED	PLACES		ALL					14	100	Using temporary


-- 우유와 요거트가 담긴 장바구니
SELECT CART_ID
FROM CART_PRODUCTS
GROUP BY CART_ID
HAVING
sum(case when NAME = 'Milk' then 1 else 0 end) > 0 AND
sum(case when NAME = 'Yogurt' then 1 else 0 end) > 0

or

SELECT CART_ID
FROM CART_PRODUCTS
GROUP BY CART_ID
HAVING
count(case when NAME = 'Milk' then 1 end) > 0 AND
count(case when NAME = 'Yogurt' then 1 end) > 0



