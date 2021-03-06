\* 재현님이 대량 데이터 넣어놓으신 테이블을 이용했습니다.

1.

- 대상 테이블 : dept_emp

```mysql
CREATE TABLE dept_emp
(
    emp_no    INT     NOT NULL,
    dept_no   CHAR(4) NOT NULL,
    from_date DATE    NOT NULL,
    to_date   DATE    NOT NULL,
    PRIMARY KEY (emp_no, dept_no)
);
```

1-1. 사원 번호가 30000보다 작고, 부서가 d005인 사원 목록을 조회한다. Index Full Scan(bad practice) 타는 쿼리를 작성해보자.

1-2. 사원 번호가 30000보다 작고, 부서가 d005인 사원 목록을 조회한다. Index Range Scan(best practice) 타는 쿼리를 작성해보자.

3.

- 대상 테이블 : employees

```mysql
CREATE TABLE employees
(
    emp_no     INT             NOT NULL
        PRIMARY KEY,
    birth_date DATE            NOT NULL,
    first_name VARCHAR(14)     NOT NULL,
    last_name  VARCHAR(16)     NOT NULL,
    gender     ENUM ('M', 'F') NOT NULL,
    hire_date  DATE            NOT NULL
);
```

```mysql
# 추가 인덱스
CREATE INDEX employees_last_name_first_name_index
    ON employees (last_name, first_name);
```

3-1. 각 부서의 매니저와 부서원 리스트 중 매니저의 사번이 110000 이상이고 부서원의 이름이 'M#### S####'인 리스트를 조회한다.

아래의 쿼리를 변경해 성능을 향상시켜보자.
```mysql
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
WHERE CONCAT(e.first_name, ' ', e.last_name) LIKE 'M% S%'
;
```
