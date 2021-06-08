## 1
SELECT 
		(SELECT NAME FROM Department d WHERE 1=1 AND d.Id = B.DepartmentId) as Department
		, Name as Employee
		, SALARY
FROM
(
	SELECT    e.Name 
			, e.SALARY
			, e.DepartmentId
			, DENSE_RANK() OVER (PARTITION  by Departmentid ORDER BY Salary DESC) as RNK
	FROM	 Employee e
	       , Department dep
	where 1=1
	and dep.id = e.DepartmentId
	ORDER by Salary desc
) B
WHERE 1=1
and rnk = 1
;

## 2
SELECT  
		 score
	   , DENSE_RANK() OVER (ORDER BY score desc) as 'Rank'
from     Scores 

## 3
SELECT 
		(SELECT NAME FROM Department d WHERE 1=1 AND d.Id = B.DepartmentId) as Department
		, Name as Employee
		, SALARY
FROM
(
	SELECT    e.Name 
			, e.SALARY
			, e.DepartmentId
			, DENSE_RANK() OVER (PARTITION  by Departmentid ORDER BY Salary DESC) as RNK
	FROM	 Employee e
	       , Department dep
	where 1=1
	and dep.id = e.DepartmentId
) B
WHERE 1=1
and rnk <= 3
	