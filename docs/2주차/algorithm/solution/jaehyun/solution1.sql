select d.Name as 'Department'
     , e.Name as 'Employee'
     , e.Salary
  from Employee e
 inner join Department d on e.DepartmentId = d.Id
 where (e.DepartmentId, e.Salary) in (select e.DepartmentId, max(e.Salary)
                                        from Employee e
                                       group by e.DepartmentId);


