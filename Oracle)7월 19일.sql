/* 여러줄 주석 */
-- 한 줄 주석
-- hr 계정으로 테스트 중
/* MySQL과 달리 Oracle SQL에서는 데이터베이스 개념까지 겸할 수 있음
hr계정에서는 인사팀 관련 데이터가 삽입되어져 있음 */

-- MySQL 과 마찬가지로 Oracle 에서도 유사한 SELECT 구문 사용
SELECT employee_id, first_name, last_name FROM employees;

SELECT * FROM employees;

-- 급여가 5000이상인 직원의 id, last_name, first_name 출력
SELECT employee_id, last_name, first_name FROM employees WHERE salary >= 5000;

/* Oracle에서도 ORDER BY로 정렬을 걸 수 있음,
위 구문에 id를 오름차순으로 정렬 */
SELECT employee_id, last_name, first_name 
FROM employees 
WHERE salary >= 5000 
ORDER BY employee_id ASC;

-- 다중 조건, 급여 5000이상 + job_id가 'IT_PROG'인 케이스만 조회 - VARCHAR: 대소문자 구분
SELECT employee_id, first_name, last_name 
FROM employees 
WHERE salary >= 5000 AND job_id = 'IT_PROG'
ORDER BY employee_id DESC;

-- 급여가 5000이상이거나 혹은 job_id가 'IT_PROG'
SELECT employee_id, first_name, last_name
FROM employees
WHERE salary >= 5000 OR job_id = 'IT_PROG';

-- 조회할 row의 개수만 알고 싶은 경우: COUNT(*)
SELECT COUNT(*)
FROM employees
WHERE salary >= 5000 OR joB_id = 'IT_PROG';

/* 컬럼명은 기존 테이블 생성시 설정한 이름으로 조회되지만,
SELECT 결과문에서 바꿔 조회하고 싶자면 AS구문 사용
SELECT 컬럼명1 AS 바꿀 컬럼명1, 컬럼명2 AS 바꿀 컬럼명2, ...; - AS 생략 가능 */
SELECT employee_id AS 직원아이디 FROM employees;
SELECT employee_id 직원아이디 FROM employees;

/* INSERT INTO 구문은 테이블에 레코드를 추가하는 구문
MySQL과 동일한 문법을 사용 */
CREATE TABLE test1(
    col1 VARCHAR2(10),  -- 문자열 
    col2 NUMBER,        -- 정수 
    col3 DATE           -- 날짜(연월일, 상세시간 제외, 상세시간입력 시 TIMESTAMP)
);

/* INSERT INTO 를 이용해 test1에 데이터 적재 
시간은 서버시간으로 저장할 경우 SYSDATE를 입력 
MySQL에서는 SYSDATE 대신 now()를 이용 */
INSERT INTO test1 (col1, col2, col3) VALUES ('ABC', 10, SYSDATE);

-- INTO 절에서 컬럼 순서를 바꿔 입력한다면 VALUES 에서 바뀐 순서에 맞춰 입력 
INSERT INTO test1(col3, col1, col2) VALUES (SYSDATE, 'DEF', 20);

/* 다음과 같이 데이터 타입을 맞춰 작성하지 않으면 오류 발생 
SQL 오류: ORA-00932: 일관성 없는 데이터 유형: DATE이(가) 필요하지만 NUMBER임 */
INSERT INTO test1(col1, col2, col3) VALUES ('ABC', 10, 30);

-- 전체 컬럼에 데이터를 적재하는 경우, INSERT INTO 뒤에 컬럼명 생략 가능 
INSERT INTO test1 VALUES ('GHI', 10, SYSDATE);

/* INSERT INTO 뒤에 컬럼명을 생략하고 일부 데이터만 적재시 에러 발생 
SQL 오류: ORA-00947: 값의 수가 충분하지 않습니다 */
INSERT INTO test1 VALUES ('JKL', 30);

SELECT * FROM test1;
/* 컬럼 데이터 복사 
INSERT ~ SELECT 문 
서브쿼리 형태로 INSERT INTO 구문의 VALUES 자리에
'데이터 자료형이 일치'하는 SELECT 구문을 작성하면
SELECT 문의 결과물이 그대로 전부 INSERT됨 */
CREATE TABLE test2(
    emp_id NUMBER
);

--아래 SELECT 구문은 NUMBER 데이터만 반환됨 
SELECT employee_id FROM employees;
SELECT COUNT(employee_id) FROM employees;   -- 107행 

-- 아래 구문은 test2 테이블 내부에, 위 명령문의 결과로 나온 숫자 전체 데이터를 적재 
INSERT INTO test2 (SELECT employee_id FROM employees);

-- 위 구문은 실제로 아래처럼 데이터가 적재됨 
/*
INSERT INTO test2 VALUES (100),
                         (101), ...
                         (206)
);
*/

SELECT * FROM test2;

/* INSERT ~ SELCT 구문을 이용해 
employees 테이블의 employee-id, first_name, last_name, job_id
4개의 컬럼을 전체 복사한 데이터를 받는 test3 테이블을 생성 */
SELECT * FROM employees;
CREATE TABLE test3(
    emp_id NUMBER,
    first_name VARCHAR2(20),
    last_name VARCHAR2(25),
    job_id VARCHAR2(10)
);

SELECT first_name f_name, last_name l_name, job_id j_id FROM test3;

INSERT INTO test3 
(SELECT employee_id, first_name, last_name, job_id FROM employees);

SELECT * FROM test3;

-- 완료하고 나서 commit을 해줘야 cmd 창에서도 조회 가능 
commit;

/* UPDATE 문
UPDATE ~ SET 을 이용해서 작성하며, MySQL과 유사한 문법 사용 
UPDATE SET은 WHERE 구문과 함께 작성 */
SELECT * FROM test1;

-- 테이블 col2의 값을 전부 50으로 변경
UPDATE test1 SET col2 = 50;

-- col1의 값이 DEF인 경우, col2를 500으로 변경 
UPDATE test1 SET col2 = 500 WHERE col1 = 'DEF';



/* Oracle의 MERGE구문은 MySQL의 ON DUPLICATE KEY 와 같음
데이터가 존재하는 경우, UPDATE를, 존재하지 않는 경우, INSERT를 실행
MERGE INTO를 사용하며 MySQL보다 복잡하지만 기능상으로는 큰 차이가 없음 */
DROP TABLE test4;
CREATE TABLE test4(
    employee_id NUMBER PRIMARY KEY,
    bonus_amt NUMBER DEFAULT 0  -- 아무 값도 입력되지 않으면 0 입력 
);

SELECT * FROM employees;

INSERT INTO test4 (employee_id) 
    SELECT e.employee_id FROM employees e 
    WHERE e.employee_id < 106;

SELECT * FROM test4;

-- 존재하는 employee_id 값으로 넣는 경우 - 갱신
-- 존재하지 않는 employee_id 값으로 넣는 경우 - 추가
INSERT INTO test4(employee_id) VALUES (107);

/* MERGE INTO 구문을 이용해 처리 - 어려움 
-- t1은 입력할 테이블, 하나의 테이블에 대해서 작업시에는 USING DUAL */
MERGE INTO test4 t1 USING DUAL
ON (t1.employee_id = 105)  -- ON: 조건식 (t와 e의 id 값이 존재하는지 여부)
WHEN MATCHED THEN                   -- 매칭이 되는 경우(값이 존재)
UPDATE SET t1.bonus_amt = 1000
WHERE t1.employee_id = 110
WHEN NOT MATCHED THEN               -- 매칭이 되지 않는 경우(값이 부재)
INSERT (t1.employee_id, t1.bonus_amt)
VALUES (105, 1000);

INSERT INTO test4 VALUES (105, 1000);

SELECT * FROM test4;

/* DELETE 구문은 특정 레코드를 삭제
WHERE 절이 입력되지 않는다면 전체 데이터가 삭제되기 때문에 주의 */
-- test4 테이블에서 bonus_amt 가 700을 초과하는 데이터만 삭제 

DELETE FROM test4 WHERE bonus_amt > 700;
SELECT * FROM test4;

/* Oracle SQL에서 인덱스를 조회하기가 MySQL보다 쉬움
인덱스란 조회를 위해 레코드별로 매겨진 임의의 값
Oracle SQL에서는
SELECT 문에 rownum을 적어 row 인덱스 번호를,
SELECT 문에 rowid를 적어 row 인덱스 주소값을 같이 조회 가능
rownum, rowid 처럼 사용자가 직접 입력하지 않고 조회되는 컬럼을 의사컬럼이라고 함 */
SELECT rownum, rowid, employee_id, first_name, last_name FROM employees;

/* GROUP BY
SELECT 집계함수(컬럼명), ... GROUP BY (기준컬럼) HAVING 조건절;
조건절은 HAVING 을 이용  */
SELECT * FROM employees;

-- employees 에는 job_id(직무 구분), department_id(부서 구분) 등 여러 자료가 있음
-- GROUP BY를 이용해 부서별 직무별 데이터 집계
-- 각 직무별 평균 연봉 구하기 
SELECT job_id, avg(salary) FROM employees GROUP BY job_id;

-- 직무별 평균 연봉을 구하는데, 평균 연봉이 10000이상
SELECT job_id, avg(salary) FROM employees GROUP BY job_id
    HAVING avg(salary) >= 10000;


-- 각 부서별 평균 연봉을 구하는데, 평균 연봉이 6000이상 9000미만
SELECT department_id, avg(salary) FROM employees GROUP BY department_id
    HAVING avg(salary) BETWEEN 6000 AND 9000;
SELECT department_id, ROUND(avg(salary)) FROM employees GROUP BY department_id
    HAVING avg(salary) >= 6000 AND avg(salary) < 9000;
    
/* JOIN은 두 개 이상의 테이블을 하나로 결합
JOIN 을 이용하려면 기준컬럼이 필요하고, 일반적으로 FOREIGN KEY로 연결된 컬럼 간 JOIN 수행
FOREIGN KEY가 아니더라도 조인 수행 가능 
SELECT 테이블1.컬럼1 테이블1.컬럼2, 테이블2.컬럼1 테이블2.컬럼2, ...
FROM 테이블1 (별명) JOIN 테이블2 ON 테이블1.조건컬럼 = 테이블2.조건컬럼; 
JOIN의 종류: INNER, LEFT OUTER, RIGHT OUTER, FULL OUTER */
CREATE TABLE join_a (
    emp_id NUMBER
);
CREATE TABLE join_b (
    emp_id NUMBER
);
INSERT INTO join_a VALUES(10);
INSERT INTO join_a VALUES(20);
INSERT INTO join_a VALUES(40);
INSERT INTO join_b VALUES(10);
INSERT INTO join_b VALUES(20);
INSERT INTO join_b VALUES(30);

SELECT * FROM join_a;
SELECT * FROM join_b;

-- INNER JOIN: 두 테이블의 교집합만 반환됨 
SELECT * FROM join_a a INNER JOIN join_b b ON (a.emp_id = b.emp_id);

-- LEFT OUTER JOIN: 왼쪽 테이블 모든 데이터와 양 테이블 교집합 데이터 
SELECT * FROM join_a a LEFT OUTER JOIN join_b b ON (a.emp_id = b.emp_id);

-- RIGHT OUTER JOIN: 오른쪽 테이블 모든 데이터와 양 테이블 교집합 데이터 
SELECT * FROM join_a a RIGHT OUTER JOIN join_b b ON (a.emp_id = b.emp_id);

-- FULL OUTER JOIN: 양 테이블 모든 데이터 
SELECT * FROM join_a a FULL OUTER JOIN join_b b ON (a.emp_id = b.emp_id);