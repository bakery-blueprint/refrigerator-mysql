with recursive cte (task_id, subtask_id) as (
    select task_id, subtasks_count
      from Tasks
    union all
    select c.task_id, c.subtask_id - 1
      from cte c
     where subtask_id > 1
)
-- Common Table Expression


select c.*
  from cte c
 left join Executed e 
   on c.task_id = e.task_id 
  and c.subtask_id = e.subtask_id
 where e.task_id is null;