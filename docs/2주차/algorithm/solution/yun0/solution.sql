# 1.  Department Highest Salary(184)
WITH Max_Salary AS (
    SELECT DepartmentId,
           MAX(Salary) AS Salary
    FROM Employee
    GROUP BY DepartmentId
)
SELECT D.Name   AS Department,
       E.Name   AS Employee,
       E.Salary AS Salary
FROM Employee E
         INNER JOIN Department D
                    ON E.DepartmentId = D.Id
         INNER JOIN Max_Salary M
                    ON M.Salary = E.Salary
                        AND M.DepartmentId = E.DepartmentId
;

# 2.  Rank Scores (178)
SELECT S.score                                   AS Score,
       DENSE_RANK() OVER (ORDER BY S.Score DESC) AS "Rank"
FROM Scores S
ORDER BY S.Score DESC
;

# 3.  Department Top Three Salaries (185)
WITH Salary_Rank AS (
    SELECT DISTINCT DepartmentId,
                    Salary,
                    DENSE_RANK() OVER (PARTITION BY DepartmentId ORDER BY Salary DESC) `Rank`
    FROM Employee
)
SELECT D.Name AS Department,
       E.Name AS Employee,
       E.Salary
FROM Employee E
         INNER JOIN Department D
                    ON E.DepartmentId = D.Id
         INNER JOIN Salary_Rank R
                    ON R.DepartmentId = E.DepartmentId
                        AND E.Salary = R.Salary
WHERE R.`Rank` <= 3
;

