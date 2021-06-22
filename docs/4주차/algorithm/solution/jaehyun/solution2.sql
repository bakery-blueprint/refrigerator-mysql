select u.user_id as 'buyer_id', u.join_date, count(t1.buyer_id) as 'orders_in_2019'
  from Users u left join (select o1.buyer_id
                            from Orders o1
                           where o1.order_date between '2019-01-01 00:00:00' and '2019-12-31 23:59:59') t1 on t1.buyer_id = u.user_id
 group by u.user_id, u.join_date