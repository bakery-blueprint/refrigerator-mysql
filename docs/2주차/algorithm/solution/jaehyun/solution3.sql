select d.Name as 'Department'
     , t3.Name as 'Employee'
     , t3.Salary
  from (select t2.DepartmentId
             , t2.Salary
             , t2.Name
             , (select count(*) + 1
                  from (select *
                         from Employee
                        group by DepartmentId, Salary ) t1
                 where t1.DepartmentId = t2.DepartmentId
                   and t1.Salary > t2.Salary) as 'rank'
         from Employee t2) t3
 inner join Department d on t3.DepartmentId = d.Id
 where t3.`rank` < 4;
