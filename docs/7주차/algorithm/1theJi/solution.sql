select emp_no, dept_no, from_date, to_Date
from dept_emp de ignore index(primary, emp_no, dept_no)
where 1=1
and dept_no = 'd005'
and emp_no < 30000
;

select emp_no, dept_no, from_date, to_Date
from dept_emp de 
where 1=1
and dept_no like 'd005%'
and emp_no < 30000
;

show index from employees
;

SELECT /*+ index(employees employees_last_name_first_name_index) index(employees employees_last_name_first_name_index)*/
	   count(*)
FROM dept_manager dm
         INNER JOIN departments d
                    ON d.dept_no = dm.dept_no
         INNER JOIN dept_emp de
                    ON dm.dept_no = de.dept_no
         INNER JOIN employees e
                    ON de.emp_no = e.emp_no
         INNER JOIN (SELECT *
                     FROM employees
                     WHERE emp_no >= 110000) dme
                    ON dm.emp_no = dme.emp_no
WHERE 1=1
and e.first_name like 'M%'
and e.last_name like 'S%'
;