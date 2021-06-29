# Article Views II
SELECT DISTINCT viewer_id AS id
FROM Views
GROUP BY viewer_id, view_date
HAVING COUNT(DISTINCT article_id) > 1
ORDER BY viewer_id
;

# Market Analysis I
SELECT u.user_id                  AS buyer_id,
       u.join_date                AS join_date,
       IFNULL(COUNT(buyer_id), 0) AS orders_in_2019
FROM Users u
         LEFT JOIN Orders o
                   ON o.buyer_id = u.user_id
                       AND YEAR(o.order_date) = '2019'
GROUP BY u.user_id
;

# Market Analysis II
SELECT u.user_id                                    AS seller_id,
       IF(item_brand = favorite_brand, 'yes', 'no') AS 2nd_item_fav_brand
FROM Users u
         LEFT JOIN
     (SELECT seller_id, item_id
      FROM (SELECT *, DENSE_RANK() OVER (PARTITION BY user_id ORDER BY order_date) AS order_rank
            FROM Orders o
                     LEFT JOIN Users u
                               ON o.seller_id = u.user_id) a
      WHERE order_rank = 2) b
     ON u.user_id = b.seller_id
         LEFT JOIN Items i
                   ON i.item_id = b.item_id
ORDER BY u.user_id
;