-- @hotire 1757. Recyclable and Low Fat Products
SELECT product_id
FROM   products
WHERE  low_fats = 'Y'
       AND recyclable = 'Y'
-- @hotire 1445. Apples & Oranges
SELECT sale_date,
       Sum(CASE fruit
             WHEN 'apples' THEN sold_num
             ELSE -sold_num
           END) AS diff
FROM   sales
GROUP  BY sale_date

-- @hotire 1767. Find the Subtasks That Did Not Execute
WITH recursive q AS
(
       SELECT tasks.task_id,
              1                    AS subtask_id,
              tasks.subtasks_count AS subtasks_count
       FROM   tasks
       UNION ALL
       SELECT task_id,
              subtask_id + 1,
              subtasks_count
       FROM   q
       WHERE  subtask_id < subtasks_count )
SELECT    q.task_id,
          q.subtask_id
FROM      q
LEFT JOIN executed
ON        q.task_id = executed.task_id
AND       q.subtask_id = executed.subtask_id
WHERE     executed.task_id IS NULL
ORDER BY  q.task_id,
          q.subtask_id

