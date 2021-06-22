SELECT
    u.user_id AS seller_id,
    CASE WHEN u.favorite_brand = i.item_brand THEN 'yes' ELSE 'no' END AS 2nd_item_fav_brand
FROM
    Users u
LEFT JOIN
    (
        SELECT
            a.seller_id AS seller_id,
            a.item_id AS item_id,
            DENSE_RANK() OVER (
                PARTITION BY a.seller_id 
                ORDER BY a.order_date ASC
            ) AS `rank`
        FROM
            Orders a
            
    ) o
    ON o.rank = 2 AND u.user_id = o.seller_id
LEFT JOIN
    Items i
    ON o.item_id = i.item_id;
