-- Table: Tasks

-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | task_id        | int     |
-- | subtasks_count | int     |
-- +----------------+---------+
-- task_id is the primary key for this table.
-- Each row in this table indicates that task_id was divided into subtasks_count subtasks labelled from 1 to subtasks_count.
-- It is guaranteed that 2 <= subtasks_count <= 20.
 

-- Table: Executed

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | task_id       | int     |
-- | subtask_id    | int     |
-- +---------------+---------+
-- (task_id, subtask_id) is the primary key for this table.
-- Each row in this table indicates that for the task task_id, the subtask with ID subtask_id was executed successfully.
-- It is guaranteed that subtask_id <= subtasks_count for each task_id.
 

-- Write an SQL query to report the IDs of the missing subtasks for each task_id.

-- Return the result table in any order.

-- The query result format is in the following example:

 

-- Tasks table:
-- +---------+----------------+
-- | task_id | subtasks_count |
-- +---------+----------------+
-- | 1       | 3              |
-- | 2       | 2              |
-- | 3       | 4              |
-- +---------+----------------+

-- Executed table:
-- +---------+------------+
-- | task_id | subtask_id |
-- +---------+------------+
-- | 1       | 2          |
-- | 3       | 1          |
-- | 3       | 2          |
-- | 3       | 3          |
-- | 3       | 4          |
-- +---------+------------+

-- Result table:
-- +---------+------------+
-- | task_id | subtask_id |
-- +---------+------------+
-- | 1       | 1          |
-- | 1       | 3          |
-- | 2       | 1          |
-- | 2       | 2          |
-- +---------+------------+
-- Task 1 was divided into 3 subtasks (1, 2, 3). Only subtask 2 was executed successfully, so we include (1, 1) and (1, 3) in the answer.
-- Task 2 was divided into 2 subtasks (1, 2). No subtask was executed successfully, so we include (2, 1) and (2, 2) in the answer.
-- Task 3 was divided into 4 subtasks (1, 2, 3, 4). All of the subtasks were executed successfully.

-- Solution --

SELECT t.task_id, s.subtask_id
FROM Tasks t
JOIN (
    SELECT 1 AS subtask_id UNION 
    SELECT 2 AS subtask_id UNION 
    SELECT 3 AS subtask_id UNION
    SELECT 4 AS subtask_id UNION 
    SELECT 5 AS subtask_id UNION 
    SELECT 6 AS subtask_id UNION
    SELECT 7 AS subtask_id UNION 
    SELECT 8 AS subtask_id UNION 
    SELECT 9 AS subtask_id UNION
    SELECT 10 AS subtask_id UNION 
    SELECT 11 AS subtask_id UNION 
    SELECT 12 AS subtask_id UNION
    SELECT 13 AS subtask_id UNION 
    SELECT 14 AS subtask_id UNION 
    SELECT 15 AS subtask_id UNION
    SELECT 16 AS subtask_id UNION 
    SELECT 17 AS subtask_id UNION 
    SELECT 18 AS subtask_id UNION
    SELECT 19 AS subtask_id UNION 
    SELECT 20 AS subtask_id
) s
WHERE 
    s.subtask_id <= t.subtasks_count 
    AND (t.task_id, s.subtask_id) NOT IN (
        SELECT task_id, subtask_id FROM Executed
    );