###1
select  product_id
from    products
where   1=1
and     low_fats = 'Y'
and     recyclable = 'Y'
;


###2
select  s1.sale_date
      , (s1.sold_num - s2.sold_num) as diff
from  sales s1
left join sales s2
on s1.sale_date = s2.sale_date
where 1=1
and   s1.fruit = 'apples' 
and   s2.fruit = 'oranges'

###3
with recursive cte as (
select task_id, 1 as subtask_id, subtasks_count
from tasks
union all
select task_id, subtask_id + 1, subtasks_count
from cte
where subtask_id < subtasks_count
)

select c.task_id, c.subtask_id 
from cte c
left join executed e
on c.task_id = e.task_id
and c.subtask_id = e.subtask_id
where e.subtask_id is null
order by c.task_id, c.subtask_id
;