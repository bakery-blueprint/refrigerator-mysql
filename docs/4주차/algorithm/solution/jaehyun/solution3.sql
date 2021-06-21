select u.user_id as 'seller_id', case when favorite_brand = ifnull(item_brand, '') then 'yes'
                                      else 'no'
                                  end as '2nd_item_fav_brand'
  from Items i inner join ( select o2.seller_id, o2.order_date, o2.item_id
                              from Orders o2 
                             inner join Orders o1 
                                on o1.seller_id = o2.seller_id and o2.order_date > o1.order_date
                             group by o2.seller_id, o2.order_date
                            having count(*) = 1) t1
                  on i.item_id = t1.item_id
               right join Users u on u.user_id = t1.seller_id