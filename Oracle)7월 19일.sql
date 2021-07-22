/* ������ �ּ� */
-- �� �� �ּ�
-- hr �������� �׽�Ʈ ��
/* MySQL�� �޸� Oracle SQL������ �����ͺ��̽� ������� ���� �� ����
hr���������� �λ��� ���� �����Ͱ� ���ԵǾ��� ���� */

-- MySQL �� ���������� Oracle ������ ������ SELECT ���� ���
SELECT employee_id, first_name, last_name FROM employees;

SELECT * FROM employees;

-- �޿��� 5000�̻��� ������ id, last_name, first_name ���
SELECT employee_id, last_name, first_name FROM employees WHERE salary >= 5000;

/* Oracle������ ORDER BY�� ������ �� �� ����,
�� ������ id�� ������������ ���� */
SELECT employee_id, last_name, first_name 
FROM employees 
WHERE salary >= 5000 
ORDER BY employee_id ASC;

-- ���� ����, �޿� 5000�̻� + job_id�� 'IT_PROG'�� ���̽��� ��ȸ - VARCHAR: ��ҹ��� ����
SELECT employee_id, first_name, last_name 
FROM employees 
WHERE salary >= 5000 AND job_id = 'IT_PROG'
ORDER BY employee_id DESC;

-- �޿��� 5000�̻��̰ų� Ȥ�� job_id�� 'IT_PROG'
SELECT employee_id, first_name, last_name
FROM employees
WHERE salary >= 5000 OR job_id = 'IT_PROG';

-- ��ȸ�� row�� ������ �˰� ���� ���: COUNT(*)
SELECT COUNT(*)
FROM employees
WHERE salary >= 5000 OR joB_id = 'IT_PROG';

/* �÷����� ���� ���̺� ������ ������ �̸����� ��ȸ������,
SELECT ��������� �ٲ� ��ȸ�ϰ� ���ڸ� AS���� ���
SELECT �÷���1 AS �ٲ� �÷���1, �÷���2 AS �ٲ� �÷���2, ...; - AS ���� ���� */
SELECT employee_id AS �������̵� FROM employees;
SELECT employee_id �������̵� FROM employees;

/* INSERT INTO ������ ���̺� ���ڵ带 �߰��ϴ� ����
MySQL�� ������ ������ ��� */
CREATE TABLE test1(
    col1 VARCHAR2(10),  -- ���ڿ� 
    col2 NUMBER,        -- ���� 
    col3 DATE           -- ��¥(������, �󼼽ð� ����, �󼼽ð��Է� �� TIMESTAMP)
);

/* INSERT INTO �� �̿��� test1�� ������ ���� 
�ð��� �����ð����� ������ ��� SYSDATE�� �Է� 
MySQL������ SYSDATE ��� now()�� �̿� */
INSERT INTO test1 (col1, col2, col3) VALUES ('ABC', 10, SYSDATE);

-- INTO ������ �÷� ������ �ٲ� �Է��Ѵٸ� VALUES ���� �ٲ� ������ ���� �Է� 
INSERT INTO test1(col3, col1, col2) VALUES (SYSDATE, 'DEF', 20);

/* ������ ���� ������ Ÿ���� ���� �ۼ����� ������ ���� �߻� 
SQL ����: ORA-00932: �ϰ��� ���� ������ ����: DATE��(��) �ʿ������� NUMBER�� */
INSERT INTO test1(col1, col2, col3) VALUES ('ABC', 10, 30);

-- ��ü �÷��� �����͸� �����ϴ� ���, INSERT INTO �ڿ� �÷��� ���� ���� 
INSERT INTO test1 VALUES ('GHI', 10, SYSDATE);

/* INSERT INTO �ڿ� �÷����� �����ϰ� �Ϻ� �����͸� ����� ���� �߻� 
SQL ����: ORA-00947: ���� ���� ������� �ʽ��ϴ� */
INSERT INTO test1 VALUES ('JKL', 30);

SELECT * FROM test1;
/* �÷� ������ ���� 
INSERT ~ SELECT �� 
�������� ���·� INSERT INTO ������ VALUES �ڸ���
'������ �ڷ����� ��ġ'�ϴ� SELECT ������ �ۼ��ϸ�
SELECT ���� ������� �״�� ���� INSERT�� */
CREATE TABLE test2(
    emp_id NUMBER
);

--�Ʒ� SELECT ������ NUMBER �����͸� ��ȯ�� 
SELECT employee_id FROM employees;
SELECT COUNT(employee_id) FROM employees;   -- 107�� 

-- �Ʒ� ������ test2 ���̺� ���ο�, �� ��ɹ��� ����� ���� ���� ��ü �����͸� ���� 
INSERT INTO test2 (SELECT employee_id FROM employees);

-- �� ������ ������ �Ʒ�ó�� �����Ͱ� ����� 
/*
INSERT INTO test2 VALUES (100),
                         (101), ...
                         (206)
);
*/

SELECT * FROM test2;

/* INSERT ~ SELCT ������ �̿��� 
employees ���̺��� employee-id, first_name, last_name, job_id
4���� �÷��� ��ü ������ �����͸� �޴� test3 ���̺��� ���� */
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

-- �Ϸ��ϰ� ���� commit�� ����� cmd â������ ��ȸ ���� 
commit;

/* UPDATE ��
UPDATE ~ SET �� �̿��ؼ� �ۼ��ϸ�, MySQL�� ������ ���� ��� 
UPDATE SET�� WHERE ������ �Բ� �ۼ� */
SELECT * FROM test1;

-- ���̺� col2�� ���� ���� 50���� ����
UPDATE test1 SET col2 = 50;

-- col1�� ���� DEF�� ���, col2�� 500���� ���� 
UPDATE test1 SET col2 = 500 WHERE col1 = 'DEF';



/* Oracle�� MERGE������ MySQL�� ON DUPLICATE KEY �� ����
�����Ͱ� �����ϴ� ���, UPDATE��, �������� �ʴ� ���, INSERT�� ����
MERGE INTO�� ����ϸ� MySQL���� ���������� ��ɻ����δ� ū ���̰� ���� */
DROP TABLE test4;
CREATE TABLE test4(
    employee_id NUMBER PRIMARY KEY,
    bonus_amt NUMBER DEFAULT 0  -- �ƹ� ���� �Էµ��� ������ 0 �Է� 
);

SELECT * FROM employees;

INSERT INTO test4 (employee_id) 
    SELECT e.employee_id FROM employees e 
    WHERE e.employee_id < 106;

SELECT * FROM test4;

-- �����ϴ� employee_id ������ �ִ� ��� - ����
-- �������� �ʴ� employee_id ������ �ִ� ��� - �߰�
INSERT INTO test4(employee_id) VALUES (107);

/* MERGE INTO ������ �̿��� ó�� - ����� 
-- t1�� �Է��� ���̺�, �ϳ��� ���̺� ���ؼ� �۾��ÿ��� USING DUAL */
MERGE INTO test4 t1 USING DUAL
ON (t1.employee_id = 105)  -- ON: ���ǽ� (t�� e�� id ���� �����ϴ��� ����)
WHEN MATCHED THEN                   -- ��Ī�� �Ǵ� ���(���� ����)
UPDATE SET t1.bonus_amt = 1000
WHERE t1.employee_id = 110
WHEN NOT MATCHED THEN               -- ��Ī�� ���� �ʴ� ���(���� ����)
INSERT (t1.employee_id, t1.bonus_amt)
VALUES (105, 1000);

INSERT INTO test4 VALUES (105, 1000);

SELECT * FROM test4;

/* DELETE ������ Ư�� ���ڵ带 ����
WHERE ���� �Էµ��� �ʴ´ٸ� ��ü �����Ͱ� �����Ǳ� ������ ���� */
-- test4 ���̺��� bonus_amt �� 700�� �ʰ��ϴ� �����͸� ���� 

DELETE FROM test4 WHERE bonus_amt > 700;
SELECT * FROM test4;

/* Oracle SQL���� �ε����� ��ȸ�ϱⰡ MySQL���� ����
�ε����� ��ȸ�� ���� ���ڵ庰�� �Ű��� ������ ��
Oracle SQL������
SELECT ���� rownum�� ���� row �ε��� ��ȣ��,
SELECT ���� rowid�� ���� row �ε��� �ּҰ��� ���� ��ȸ ����
rownum, rowid ó�� ����ڰ� ���� �Է����� �ʰ� ��ȸ�Ǵ� �÷��� �ǻ��÷��̶�� �� */
SELECT rownum, rowid, employee_id, first_name, last_name FROM employees;

/* GROUP BY
SELECT �����Լ�(�÷���), ... GROUP BY (�����÷�) HAVING ������;
�������� HAVING �� �̿�  */
SELECT * FROM employees;

-- employees ���� job_id(���� ����), department_id(�μ� ����) �� ���� �ڷᰡ ����
-- GROUP BY�� �̿��� �μ��� ������ ������ ����
-- �� ������ ��� ���� ���ϱ� 
SELECT job_id, avg(salary) FROM employees GROUP BY job_id;

-- ������ ��� ������ ���ϴµ�, ��� ������ 10000�̻�
SELECT job_id, avg(salary) FROM employees GROUP BY job_id
    HAVING avg(salary) >= 10000;


-- �� �μ��� ��� ������ ���ϴµ�, ��� ������ 6000�̻� 9000�̸�
SELECT department_id, avg(salary) FROM employees GROUP BY department_id
    HAVING avg(salary) BETWEEN 6000 AND 9000;
SELECT department_id, ROUND(avg(salary)) FROM employees GROUP BY department_id
    HAVING avg(salary) >= 6000 AND avg(salary) < 9000;
    
/* JOIN�� �� �� �̻��� ���̺��� �ϳ��� ����
JOIN �� �̿��Ϸ��� �����÷��� �ʿ��ϰ�, �Ϲ������� FOREIGN KEY�� ����� �÷� �� JOIN ����
FOREIGN KEY�� �ƴϴ��� ���� ���� ���� 
SELECT ���̺�1.�÷�1 ���̺�1.�÷�2, ���̺�2.�÷�1 ���̺�2.�÷�2, ...
FROM ���̺�1 (����) JOIN ���̺�2 ON ���̺�1.�����÷� = ���̺�2.�����÷�; 
JOIN�� ����: INNER, LEFT OUTER, RIGHT OUTER, FULL OUTER */
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

-- INNER JOIN: �� ���̺��� �����ո� ��ȯ�� 
SELECT * FROM join_a a INNER JOIN join_b b ON (a.emp_id = b.emp_id);

-- LEFT OUTER JOIN: ���� ���̺� ��� �����Ϳ� �� ���̺� ������ ������ 
SELECT * FROM join_a a LEFT OUTER JOIN join_b b ON (a.emp_id = b.emp_id);

-- RIGHT OUTER JOIN: ������ ���̺� ��� �����Ϳ� �� ���̺� ������ ������ 
SELECT * FROM join_a a RIGHT OUTER JOIN join_b b ON (a.emp_id = b.emp_id);

-- FULL OUTER JOIN: �� ���̺� ��� ������ 
SELECT * FROM join_a a FULL OUTER JOIN join_b b ON (a.emp_id = b.emp_id);