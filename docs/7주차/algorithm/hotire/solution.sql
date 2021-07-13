-- 1.1
select emp_no from dept_emp
where CONCAT(emp_no, '') < 3000
  and CONCAT(dept_no, '') = 'd005'

-- 1.2
select emp_no from dept_emp
where emp_no < 3000
  and dept_no = 'd005'


-- 3.1
SELECT d.dept_no,
       dm.emp_no                                  AS manager_emp_no,
       CONCAT(dme.first_name, ' ', dme.last_name) AS manager_name,
       e.emp_no                                   AS member_emp_no,
       CONCAT(e.first_name, ' ', e.last_name)     AS member_name
FROM dept_manager dm
         INNER JOIN departments d
                    ON d.dept_no = dm.dept_no
         INNER JOIN dept_emp de
                    ON dm.dept_no = de.dept_no
         INNER JOIN employees e
                    ON de.emp_no = e.emp_no
         INNER JOIN employees dme on de.emp_no = dme.emp_no and dme.emp_no >= 110000
WHERE dme.last_name LIKE 'S%' and dme.first_name LIKE 'M%'






