### 6.2.10 Extra
- 성능과 관련된 몇개의 고정된 문장이 표시됨
- 해당 컬럼을 통해 쿼리가 어떤 방식으로 실행이 되고 있는지 알 수 있는 중요한 컬럼  


#### **const row not found(MySQL 5.1 부터)**
- 쿼리 실행 계획에서 const 로 읽었지만 const에 해당하는 레코드가 없음


#### **Distinct**
- 조인하지 않아도 되는 항목은 모두 무시하고 필요한 레코드를 유니크하게 가져오기 위한 표현


#### **Full scan on NULL key**
- col1 IN (select  col2 from ...) 과 같은 쿼리에서 발생함
- col1 이 null 일 경우 해당 연산 조건은 아래와 같음
  - 서브 쿼리가 1건이라도 결과 레코드를 가진다면 최종 비교 결과는 NULL
  - 서브 쿼리가 1건도 결과 레코드를 가지지 않는다면 최종 비교 결과는 FALSE
- 위 두 연산 조건 때문에 서브 쿼리가 1건이라도 데이터가 있는지 없는지 알기 위해서는 full table scan 이 발생한다.
- col1 IN (select  col2 from ...) 조건절 앞에 col1 is not null 조건이 있다면 col1이 null일 경우 실행이 안되기 때문에 해당 상황을 피해갈 수 있다.


#### **Impossible HAVING(MySQL 5.1 부터)**
- HAVING 조건절에 해당하는 레코드가 없을 때 표시되는 키워드
- 쿼리 내용을 다시 점검하는게 좋음

#### **Impossible WHERE(MySQL 5.1 부터)**
- Impossible HAVING 과 비슷하게 WHERE 조건이 항상 FALSE 일 경우 표시되는 키워드
- 쿼리 내용을 다시 점검하는게 좋음

#### **Impossible WHERE noticed after reading const tables**
- 조건을 비교하는 부분에서 옵티마이저가 미리 쿼리를 실행해 볼 수 있고, 이것을 const 방식으로 비교 진행할 수 있을 때(대표적으로 프라이머리키를 기반), 비교 조건에 일치하는 조건이 없을 경우 표시되는 키워드
  
#### **No matching min/max row (MySQL 5.1 부터)**
- MIN(), MAX()와 같은 집합 함수가 있는 쿼리의 조건절에 일치하는 레코드가 없을 때 표시

#### **no matching row in const table (MySQL 5.1 부터)**
- 조인이 사용된 테이블에서 const 방식으로 접근할때 일치하는 레코드가 없다면 표시되는 키워드
  
> const 라는 키워드가 들어가면 옵티마이저가 내부적으로 실행을 해서 상수형식으로 만드는 과정이 있다고 생각하면 편함

#### **No tables used (MySQL 5.0 의 "No tables"에서 키워드 변경됨)**
- from 절이 없는 쿼리에서 표시되는 키워드

#### **Not exists**
- A 테이블에는 존재하지만 B 테이블에는 존재하지 않는 값을 조회할때 안티-조인을 실행하는데 left outer join 을 통해서도 표현 가능
- outer join 을 통해 안티-조인을 실행하면 "Not exists" 형식의 최적화를 통해 실행했다는 것을 표현하는 키워드
- SQL 문법에 NOT EXISTS 와는 다른 의미

#### **Range checked for each record (index map: N)**
- 두 테이블을 조인할때 조건문을 확인해서 매 레코드마다 인덱스 레인지 스캔을 체크해야할 때 표현하는 키워드
- (index map: N) 에서 N은 어떤 인덱스를 후보로 해당 레인지 스캔을 실행하지에 대한 비트가 표시된다.
  ```sql
  select *
    from employees e1, employees e2
   where e1.emp_no <= e2.emp_no;
  ```
  ![어마어마한 시간...](./img/pic1.png)

#### **Scanned N databases(MySQL 5.1부터)**
- INFORMATION_SCHEMA DB를 조회할 때 N개의 DB 정보를 읽었는지 표현하는 키워드

#### **Select tables optimized away**
- MIN(), MAX() 가 사용될때 인덱스를 오름차순/내림차순으로 한건만 읽는 형태의 최적화가 적용되거나 MyISAM 엔진에서 COUNT(*)를 사용할때 표현하는 키워드

#### **Skip_open_table, Open_frm_only, Open_trigger_only, Open_full_table (MySQL 5.1부터)**
- Scanned N databases과 동일하게 INFORMATION_SCHEMA DB의 메타 정보 조회를 할 때 발생한다.
- 메타 정보가 저장된 파일과 트리거가 저장된 파일 또는 데이터 파일 중에서 필요한 파일만 읽었는지 등을 나타낸다.

#### **unique row not found (MySQL 5.1부터)**
