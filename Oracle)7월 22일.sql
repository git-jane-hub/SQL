/* Oracle SQL에서도 MySQL과 같이 프로그래밍이 가능
단, 변수 선언이나 호출 등의 문법, 콘솔창 출력 문법이 같지 않음
Oracle 에서 진행하는 프로그래밍은 PL/SQL 이라고 함 */
/*
PL/SQL 문법
DECLARE
    변수명 데이터타입;
    ......
BEGIN
    실행문
END;
*/
/* 이름이 있는 블록: 함수, 프로시저, 패키지
이름이 없는 블록: 익명 블록 Anonymous block
DECLARE ~ END 구간을 블록이라고 하는데
익명 블록은 명칭을 붙이지 않고 사용하는 PL/SQL 프로그래밍 구간을 의미 */
/*
DECLARE
    vi_num NUMBER;
BEGIN
    vi_num := 100;
    DBMS_OUTPUT.PUT_LINE(vi_num);   -- print 구문은 DBMS 출력에서 확인
END;
*/

/* SQL Developer 에서 콘솔창 여는 방법
보기 - DBMS 출력
DBMS 출력 창에서 좌측 상단 녹색 + 클릭하고 접속 계정으로 연결 */
-- 내부적으로 일반 프로그래밍처럼 연산자 사용 가능

/*
DECLARE
    a INTEGER := (2 ** 2) * (3 ** 2);           -- 2의 제곱과 3의 제곱을 곱해줌 (4 * 9)
BEGIN
    -- ||은 문자열을 이어붙여줌 (자바의 +, MySQL의 콤마와 같음)
    -- 'a = ' || a도 실행 가능, 문자열끼리 이어붙일 때는 정수타입을 TO_CHAR()를 통해 문자열로 변경
    DBMS_OUTPUT.PUT_LINE('a = ' || TO_CHAR(a));
END;
*/

-- MySQL 과 같이 PL/SQL에서 특정 변수에 SELECT 쿼리무의 결과값 저장 가능
/*
DECLARE 
    vs_emp__first_name VARCHAR2(80);
    vs_emp__last_name VARCHAR2(80);
BEGIN
    SELECT first_name, last_name INTO vs_emp_first_name, vs_emp_last_name
        FROM employees
        WHERE employee_id = 100;
    DBMS_output.put_line('받아온 사원명 ' || vs_first_emp_name || vs_emp__last_name );
END;
*/
SELECT * FROM employees;
/*
DECLARE
    de_id NUMBER;
    f_name VARCHAR2(20);
    salary NUMBER;
BEGIN
    SELECT department_id, first_name, salary INTO de_id, f_name, salary 
        FROM employees WHERE employee_id = 185;
    DBMS_output.put_line('부서번호: ' || de_id || ', 이름: ' || f_name || ', 급여: ' || salary);
END;
*/
/* 테이블에 있는 컬럼을 사용할 때마다 데이터타입을 확인해야하는 번거로움이 있음
선언부에서 변수의 데이터타입을 설정할 때 사용자가 내용을 확인하지 않고
자동으로 해당 컬럼의 데이터타입을 받아오도록 처리 가능 
변수명 테이블명.컬럼명%TYPE; */
/*
SELECT * FROM DEPARTMENTS;
DECLARE
    d_name departments.department_name%TYPE;
    l_id departments.location_id%TYPE;
BEGIN
    SELECT department_name, location_id INTO d_name, l_id FROM departments WHERE department_id = 20;
    DBMS_OUTPUT.PUT_LINE('부서이름: ' || d_name || ', 부서위치: ' || l_id);
END;
*/
/* PL/SQL의 조건문
IF 조건문 THEN을 사용, 종료 지점에 END IF; 작성
이외의 문법은 MySQL과 동일, ELSEIF를 ELSIF로 작성 
IF ~ THEN ~ ELSIF ~ THEN ~ END IF; */
/* 문제
vn_num1, vn_num2에 NUMBER타입으로 각각 정수 데이터 삽입
정수들 중 num1이 크면 num1이 큽니다.
num2가 크면 num2가 큽니다 라고 출력하는 조건문 작성 */
/*
DECLARE
    vn_num1 NUMBER;
    vn_num2 NUMBER;
BEGIN
    vn_num1 := 100;
    vn_num2 := 5;
    IF(vn_num1 > vn_num2) THEN
    DBMS_OUTPUT.PUT_LINE('숫자 ' || vn_num2 || '보다 ' || vn_num1 || '이/가 큽니다.');
    ELSIF(vn_num1 < vn_num2) THEN
    DBMS_OUTPUT.PUT_LINE('숫자 ' || vn_num1 || '보다 ' || vn_num2 || '이/가 큽니다.');
    END IF;
END;
*/
/*
-- 변수를 선언과 동시에 초기화해줘도 됨
DECLARE
    vn_num1 NUMBER := 100;
    vn_num2 NUMBER := 5;
BEGIN
    IF(vn_num1 > vn_num2) THEN
        DBMS_OUTPUT.PUT_LINE('숫자 ' || vn_num2 || '보다 ' || vn_num1 || '이/가 큽니다.');
    ELSIF(vn_num1 < vn_num2) THEN
        DBMS_OUTPUT.PUT_LINE('숫자 ' || vn_num1 || '보다 ' || vn_num2 || '이/가 큽니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('값이 동일합니다.');
    END IF;
END;
*/
/* 프로시저 생성
MySQL과 문법의 차이가 있음
CREATE OR REPLACE PROCEDURE 프로시저명(파라미터1 데이터타입, ...)
IS 
    필요시 변수 및 상수 선언
BEGIN
    실행 구문
END 프로시저명; */
-- JOBS 테이블에 데이터를 넣어주는 프로시저 생성
/*
CREATE OR REPLACE PROCEDURE my_new_job 
(
    n_job_id IN JOBS.JOB_ID%TYPE,
    n_job_title IN JOBS.JOB_TITLE%TYPE,
    n_min_salary IN JOBS.MIN_SALARY%TYPE,
    n_max_salary IN JOBS.MAX_SALARY%TYPE
)
IS
BEGIN
    INSERT INTO JOBS(JOB_ID, JOB_TITLE, MIN_SALARY, MAX_SALARY)
        VALUES (n_job_id, n_job_title, n_min_salary, n_max_salary);
    COMMIT;
END my_new_job;
-- 프로시저 호출은 EXEC 프로시저명 / EXECUTE 프로시저명
EXEC my_new_job('INTERN', 'INTERN STAFF', 500, 1000);
*/
SELECT employee_id, first_name, hire_date, job_id, salary FROM employees;




