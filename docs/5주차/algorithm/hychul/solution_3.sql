SELECT
    a.cart_id AS cart_id
FROM
    (SELECT * FROM cart_products WHERE name = 'Milk') a
LEFT JOIN
    (SELECT * FROM cart_products WHERE name = 'Yogurt') b
    ON a.cart_id = b.cart_id
WHERE
    a.cart_id IS NOT NULL
    AND b.cart_id IS NOT NULL;

-- 

SELECT
    a.cart_id AS cart_id
FROM
    (SELECT cart_id FROM cart_products WHERE name = 'Milk') a
WHERE
    a.cart_id IN (SELECT cart_id FROM cart_products WHERE name = 'Yogurt');

