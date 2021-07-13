-- 1-1

-- 1-2
select emp_no
  from dept_emp
 where dept_no = 'd005'
   and emp_no < 30000;


-- 3
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
         INNER JOIN (SELECT *
                     FROM employees
                     WHERE emp_no >= 110000) dme
                    ON dm.emp_no = dme.emp_no
WHERE e.first_name like 'M%'
  AND e.last_name like 'S%';