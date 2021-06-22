##1
select distinct A.viewer_id as id
from (
	select count(viewer_id) as viewer_cnt, count(distinct article_id) as article_cnt , viewer_id
	from Views v 
	group by  viewer_id, view_date
	order by view_date
) as A
where 1=1
and article_cnt > 1
order by id
;


##2
select 
		 user_id as buyer_id 
	   , join_date
	   , (select count(buyer_id)
	   	    from orders o 
	   	   where 1=1
	   	     and o.buyer_id = u.user_id
	   	     and o.order_date > STR_TO_DATE('2019','%Y')
	   	  ) as orders_in_2019
from   Users u 




##3
with recursive CTE as (
	select a.* 
	from (
			select  seller_id,
					item_id,
					row_number() over(partition by o.seller_id order by order_date asc) rn, 
					LEAD(item_id ,1) OVER ( PARTITION BY o.seller_id ORDER BY order_date asc ) as next_item_id		
			from orders o
			where 1=1
		) a
	where a.rn = 1
)

select u.user_id as seller_id,
	   case when u.favorite_brand = (select i.item_brand from Items i where 1=1 and i.item_id = c.next_item_id)
	        then 'yes'
	        else 'no'
	   end as 2nd_item_fav_brand    
from Users u 
left outer join CTE c
on u.user_id = c.seller_id

;
