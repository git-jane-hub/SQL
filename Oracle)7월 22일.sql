/* Oracle SQL������ MySQL�� ���� ���α׷����� ����
��, ���� �����̳� ȣ�� ���� ����, �ܼ�â ��� ������ ���� ����
Oracle ���� �����ϴ� ���α׷����� PL/SQL �̶�� �� */
/*
PL/SQL ����
DECLARE
    ������ ������Ÿ��;
    ......
BEGIN
    ���๮
END;
*/
/* �̸��� �ִ� ���: �Լ�, ���ν���, ��Ű��
�̸��� ���� ���: �͸� ��� Anonymous block
DECLARE ~ END ������ ����̶�� �ϴµ�
�͸� ����� ��Ī�� ������ �ʰ� ����ϴ� PL/SQL ���α׷��� ������ �ǹ� */
/*
DECLARE
    vi_num NUMBER;
BEGIN
    vi_num := 100;
    DBMS_OUTPUT.PUT_LINE(vi_num);   -- print ������ DBMS ��¿��� Ȯ��
END;
*/

/* SQL Developer ���� �ܼ�â ���� ���
���� - DBMS ���
DBMS ��� â���� ���� ��� ��� + Ŭ���ϰ� ���� �������� ���� */
-- ���������� �Ϲ� ���α׷���ó�� ������ ��� ����

/*
DECLARE
    a INTEGER := (2 ** 2) * (3 ** 2);           -- 2�� ������ 3�� ������ ������ (4 * 9)
BEGIN
    -- ||�� ���ڿ��� �̾�ٿ��� (�ڹ��� +, MySQL�� �޸��� ����)
    -- 'a = ' || a�� ���� ����, ���ڿ����� �̾���� ���� ����Ÿ���� TO_CHAR()�� ���� ���ڿ��� ����
    DBMS_OUTPUT.PUT_LINE('a = ' || TO_CHAR(a));
END;
*/

-- MySQL �� ���� PL/SQL���� Ư�� ������ SELECT �������� ����� ���� ����
/*
DECLARE 
    vs_emp__first_name VARCHAR2(80);
    vs_emp__last_name VARCHAR2(80);
BEGIN
    SELECT first_name, last_name INTO vs_emp_first_name, vs_emp_last_name
        FROM employees
        WHERE employee_id = 100;
    DBMS_output.put_line('�޾ƿ� ����� ' || vs_first_emp_name || vs_emp__last_name );
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
    DBMS_output.put_line('�μ���ȣ: ' || de_id || ', �̸�: ' || f_name || ', �޿�: ' || salary);
END;
*/
/* ���̺� �ִ� �÷��� ����� ������ ������Ÿ���� Ȯ���ؾ��ϴ� ���ŷο��� ����
����ο��� ������ ������Ÿ���� ������ �� ����ڰ� ������ Ȯ������ �ʰ�
�ڵ����� �ش� �÷��� ������Ÿ���� �޾ƿ����� ó�� ���� 
������ ���̺��.�÷���%TYPE; */
/*
SELECT * FROM DEPARTMENTS;
DECLARE
    d_name departments.department_name%TYPE;
    l_id departments.location_id%TYPE;
BEGIN
    SELECT department_name, location_id INTO d_name, l_id FROM departments WHERE department_id = 20;
    DBMS_OUTPUT.PUT_LINE('�μ��̸�: ' || d_name || ', �μ���ġ: ' || l_id);
END;
*/
/* PL/SQL�� ���ǹ�
IF ���ǹ� THEN�� ���, ���� ������ END IF; �ۼ�
�̿��� ������ MySQL�� ����, ELSEIF�� ELSIF�� �ۼ� 
IF ~ THEN ~ ELSIF ~ THEN ~ END IF; */
/* ����
vn_num1, vn_num2�� NUMBERŸ������ ���� ���� ������ ����
������ �� num1�� ũ�� num1�� Ů�ϴ�.
num2�� ũ�� num2�� Ů�ϴ� ��� ����ϴ� ���ǹ� �ۼ� */
/*
DECLARE
    vn_num1 NUMBER;
    vn_num2 NUMBER;
BEGIN
    vn_num1 := 100;
    vn_num2 := 5;
    IF(vn_num1 > vn_num2) THEN
    DBMS_OUTPUT.PUT_LINE('���� ' || vn_num2 || '���� ' || vn_num1 || '��/�� Ů�ϴ�.');
    ELSIF(vn_num1 < vn_num2) THEN
    DBMS_OUTPUT.PUT_LINE('���� ' || vn_num1 || '���� ' || vn_num2 || '��/�� Ů�ϴ�.');
    END IF;
END;
*/
/*
-- ������ ����� ���ÿ� �ʱ�ȭ���൵ ��
DECLARE
    vn_num1 NUMBER := 100;
    vn_num2 NUMBER := 5;
BEGIN
    IF(vn_num1 > vn_num2) THEN
        DBMS_OUTPUT.PUT_LINE('���� ' || vn_num2 || '���� ' || vn_num1 || '��/�� Ů�ϴ�.');
    ELSIF(vn_num1 < vn_num2) THEN
        DBMS_OUTPUT.PUT_LINE('���� ' || vn_num1 || '���� ' || vn_num2 || '��/�� Ů�ϴ�.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('���� �����մϴ�.');
    END IF;
END;
*/
/* ���ν��� ����
MySQL�� ������ ���̰� ����
CREATE OR REPLACE PROCEDURE ���ν�����(�Ķ����1 ������Ÿ��, ...)
IS 
    �ʿ�� ���� �� ��� ����
BEGIN
    ���� ����
END ���ν�����; */
-- JOBS ���̺� �����͸� �־��ִ� ���ν��� ����
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
-- ���ν��� ȣ���� EXEC ���ν����� / EXECUTE ���ν�����
EXEC my_new_job('INTERN', 'INTERN STAFF', 500, 1000);
*/
SELECT employee_id, first_name, hire_date, job_id, salary FROM employees;




