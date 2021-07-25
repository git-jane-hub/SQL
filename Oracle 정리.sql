-- Oracle 출력은 control + return
SELECT * FROM employees;

SELECT employee_id, first_name, last_name FROM employees;

SELECT employee_id, first_name, last_name FROM employees WHERE salary >= 5000;
SELECT employee_id, first_name, last_name, salary FROM employees 
WHERE salary >= 5000 ORDER BY salary DESC;

SELECT employee_id, first_name, last_name FROM employees 
WHERE salary >= 5000 and job_id = 'IT_PROG';    -- ROW 개수 2개  

SELECT COUNT(*) FROM employees
WHERE salary >= 5000 and job_id = 'IT_PROG';    -- 반환값: 2

SELECT employee_id 사원번호, last_name 성, first_name 이름 FROM employees;

CREATE TABLE test1(
    name VARCHAR2(10),
    age INT,
    birth DATE
);
DROP TABLE test1;
-- DATE '일-월-연' 혹은 '일/월/연' 순 - 홑따옴표 작성 필요, 월은 숫자 아닌 영어로 작성  
INSERT INTO test1 VALUES ('AAA', 28, '26/AUG/21');
INSERT INTO test1 VALUES ('BBB', 24, '28-Apr-98');
INSERT INTO test1 VALUES ('CCC', 29, '04-Feb-93');
UPDATE test1 SET birth = '05-JUL-93' WHERE name = 'CCC';
SELECT * FROM test1;
SELECT COUNT(name) FROM test1; 

CREATE TABLE test2(
    e_id NUMBER,
    f_name VARCHAR2(20),
    l_name VARCHAR2(20),
    h_date DATE
);

SELECT employee_id, first_name, last_name, hire_date 
INTO e_id, f_name, l_name, h_date FROM employees; 
-- 다른 테이블에서 컬럼을 복사할 때는 INSERT INTO ~ (SELECT ~ FROM) - VALUES 작성하지 않음
INSERT INTO test2 
(SELECT employee_id, first_name, last_name, hire_date FROM employees);

SELECT * FROM employees;
DROP TABLE mergeIntoTest;
CREATE TABLE mergeIntoTest(
    num NUMBER,
    f_name VARCHAR2(20),
    l_name VARCHAR2(20),
    dep_id VARCHAR2(20),
    salary NUMBER
);
INSERT INTO mergeIntoTest (SELECT employee_id, first_name, last_name, job_id, salary FROM employees WHERE employee_id <= 115);
SELECT * FROM mergeIntoTest;

-- MERGE INTO
MERGE INTO mergeIntoTest mit USING DUAL
ON (mit.f_name = 'David' AND mit.l_name = 'Austin')
WHEN MATCHED THEN
UPDATE SET mit.salary = 6000
WHERE (mit.f_name = 'David' AND mit.l_name = 'Austin')
WHEN NOT MATCHED THEN
INSERT (mit.num, mit.f_name, mit.l_name, mit.dep_id, mit.salary)
VALUES (115, 'David', 'Austin', 'IT_PROG', 6000);

-- 컬럼의 값을 입력할 때에는 괄호내부에 작성 
MERGE INTO mergeIntoTest mit USING DUAL
ON (f_name = 'Luis')
WHEN MATCHED THEN
UPDATE SET l_name = 'Pop'
WHEN NOT MATCHED THEN
INSERT (num, f_name, l_name, dep_id, salary)
VALUES (113, 'Luis', 'Pop', 'FI_ACCOUNT', 6900);
 
 -- INDEX
SELECT rownum, rowid, num, f_name, l_name, dep_id, salary
FROM mergeIntoTest;

CREATE TABLE test3(
    num NUMBER
);
CREATE TABLE test4(
    num NUMBER
);
INSERT INTO test3 VALUES (1);
INSERT INTO test3 VALUES (2);
INSERT INTO test3 VALUES (3);
INSERT INTO test4 VALUES (1);
INSERT INTO test4 VALUES (2);
INSERT INTO test4 VALUES (4);
-- JOIN 구문 작성하고 on 뒤에 작성 필요 
SELECT * FROM test3 t3 INNER JOIN test4 t4 ON t3.num = t4.num;
SELECT * FROM test3 t3 LEFT OUTER JOIN test4 t4 ON t3.num = t4.num;
SELECT * FROM test3 t3 RIGHT OUTER JOIN test4 t4 ON t3.num = t4.num;
SELECT * FROM test3 t3 FULL OUTER JOIN test4 t4 ON t3.num = t4.num;

-- PL/SQL
/*
DECLARE
    a INTEGER := ((10 ** 2) ** 2);
BEGIN
    DBMS_OUTPUT.PUT_LINE('a = ' || a);
END;
*/
SELECT * FROM employees;
/*
DECLARE
    f_name VARCHAR(20);
    l_name VARCHAR(20);
    dep_id VARCHAR(20);
BEGIN
    SELECT first_name, last_name, job_id 
        INTO f_name, l_name, dep_id
        FROM employees WHERE employee_id = 100;
    DBMS_OUTPUT.PUT_LINE('성: ' || l_name || 
                        ' 이름: ' ||  f_name || 
                        ' 부서: ' || dep_id);
END;
*/

DECLARE
    f_name_100 VARCHAR2(20);
    salary_100 NUMBER;
    f_name_101 VARCHAR2(20);
    salary_101 NUMBER;
BEGIN
    SELECT first_name, salary INTO f_name_100, salary_100
        FROM employees WHERE employee_id = 100;
        
    SELECT first_name, salary INTO f_name_101, salary_101
        FROM employees WHERE employee_id = 101;
    IF (salary_100 > salary_101) THEN
        DBMS_OUTPUT.PUT_LINE('사원번호 100 win');
    ELSIF (salary_100 < salary_101) THEN
        DBMS_OUTPUT.PUT_LINE('사원번호 101 win');
    ELSE
        DBMS_OUTPUT.PUT_LINE('same');
    END IF;
END;

