-- 변수 지정
SET @var1 = 1;
SET @var2 = 'aaa';
SET @var3 = 3.15;
SET @var4 = 'NAME: ';
SET @var5 = 100000;
SET @var6 = 100.9;

-- 변수 연산
SELECT @var1 + @var3;
SELECT @var1 * @var3;

-- 변수와 컬럼 함께 조회
SELECT @var4, uName FROM testTbl1;

SELECT * FROM testTbl2;
-- PREPARE 구문과 함께 사용, PREPARE 쿼리명 FROM '쿼리문 ?'; EXECUTE 쿼리명 USING 변수; 
PREPARE testQuery FROM 'SELECT uId, SUM(uPrice) FROM testTbl2 GROUP BY uid HAVING SUM(uPrice) > ?';
EXECUTE testQuery USING @var5;

-- 형변환
SELECT CAST(@var1 + @var3 AS SIGNED INTEGER);
SELECT CAST(@var1 + @var6 AS SIGNED INTEGER);	-- CAST는 반올림

SELECT '100' + '200';
SELECT CONCAT('100', '200');

-- 프로시저
USE employees; 
SELECT * FROM employees;
DELIMITER $$
CREATE PROCEDURE howOld()
BEGIN
	DECLARE e_no INT;
	DECLARE f_name VARCHAR(20);
	DECLARE b_date DATE;
    DECLARE t_date DATE;
    DECLARE age INT;
    
    SET e_no = 10001;
    SELECT first_name, birth_date INTO f_name, b_date FROM employees WHERE emp_no = e_no;
    SET t_date = CURDATE();
    SET age = (DATEDIFF(t_date, b_date)) / 365;
	
    IF (age > 55) THEN
		SELECT CONCAT('YOU ARE ', age, '. YOU HAVE TO GO HOME.');
	ELSE
		SELECT CONCAT('YOU ARE ', age, '. YOU HAVE TO WORK HARD.');
	END IF;
END $$
DELIMITER ;
CALL howold();

DELIMITER $$
CREATE PROCEDURE howOld2(IN e_no INT)	# 파라미터 내부 작성시에는 (IN 파라미터명 데이터타입)
BEGIN
    DECLARE b_date DATE;
    DECLARE t_date DATE;
    DECLARE f_name VARCHAR(20);
    DECLARE age INT;
    
    # SELECT 가져올 자료 INTO 삽입할 컬럼명 FROM 가져올 테이블 WHERE 조건;
	SELECT birth_date, first_name INTO b_date, f_name FROM employees WHERE employees.emp_no = e_no;
    SET t_date = CURDATE();
    SET age = (DATEDIFF(t_date, b_date)) / 365;
    
    IF( age > 60) THEN
		SELECT CONCAT('YOU ARE ', age, '. YOU HAVE TO GO HOME.');
	ELSE
		SELECT CONCAT('YOU ARE ', age, '. YOU HAVE TO WORK HARD.');
	END IF;
END $$
DELIMITER ;
CALL howOld2(10013);

-- 트리거
CREATE TABLE userAdmin(
	uid VARCHAR(20),
    upw VARCHAR(20)
);
INSERT INTO userAdmin VALUES ('AAA', '111'),
							 ('BBB', '222'),
                             ('CCC', '333');

CREATE TABLE userAdminOut(
	uid VARCHAR(20),
    upw VARCHAR(20),
	deleteDate DATE
);

DELIMITER //
CREATE TRIGGER userOut
	AFTER DELETE
    ON userAdmin
    FOR EACH ROW
BEGIN
	SET @deleteMSG = '회원이 탈퇴회원 관리 테이블로 이동합니다.';
    INSERT INTO userAdminOut VALUES (OLD.uid, OLD.upw, NOW());
END //
DELIMITER ;

DROP TRIGGER userOut;
SHOW TRIGGERS;
SELECT @;	-- NULL
DELETE FROM userAdmin WHERE uid = 'AAA';
INSERT INTO userAdmin VALUES ('DDD', '444');
INSERT INTO userAdmin VALUES ('AAA', '111');
SELECT @msg;
SELECT * FROM userAdmin;
SELECT * FROM userAdminOut;
