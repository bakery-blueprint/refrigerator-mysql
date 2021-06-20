-- 1149. Article Views II
SELECT DISTINCT viewer_id AS id
FROM   views
GROUP  BY view_date,
          viewer_id
HAVING Count(DISTINCT article_id) > 1
ORDER  BY id

-- author_id and viewer_id indicate the same person. author_id도 중요한줄..


-- 1158. Market Analysis I
SELECT user_id  AS buyer_id,
       join_date,
       Sum(CASE
             WHEN orders.order_date >= '2019-01-01'
                  AND orders.order_date <= '2020-12-31' THEN 1
             ELSE 0
           END) AS orders_in_2019
FROM   users
       LEFT JOIN orders
              ON orders.buyer_id = users.user_id
GROUP  BY user_id,
          join_date
ORDER  BY buyer_id


-- 1159. Market Analysis II
SELECT user_id AS seller_id,
       ( CASE
           WHEN favorite_brand = (SELECT i.item_brand
                                  FROM   orders o
                                         LEFT JOIN items i
                                                ON o.item_id = i.item_id
                                  WHERE  o.seller_id = u.user_id
                                  ORDER  BY o.order_date
                                  LIMIT  1 offset 1) THEN "yes"
           ELSE "no"
         end ) AS "2nd_item_fav_brand"
FROM   users u