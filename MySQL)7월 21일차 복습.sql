SELECT * FROM information_schema.table_constraints WHERE constraint_schema = 'sqldb';
DESCRIBE employees.employees;
CREATE TABLE testTbl5(
	num INT,
    name VARCHAR(5)
);
ALTER TABLE testTbl5 ADD CONSTRAINT PRIMARY KEY (num); 
-- ALTER TABLE testTbl5 DROP PRIMARY KEY;
-- PRIMARY KEY를 삭제하기 전에는 연결된 테이블의 FOREIGN KEY를 먼저 삭제해줘야 함 
ALTER TABLE testTbl5 DROP PRIMARY KEY;
CREATE TABLE testTbl6(
	fnum INT NOT NULL,
    num INT PRIMARY KEY,
    id VARCHAR(5)
);
-- 외래키로 지정해둔 컬럼에 해당 제약조건을 삭제하기 위해서 별명을 붙여줘야 함 
ALTER TABLE testTbl6 ADD CONSTRAINT fk_fnum FOREIGN KEY (fnum) REFERENCES testTbl5(num);
ALTER TABLE testTbl6 DROP FOREIGN KEY fk_fnum;
DESCRIBE sqldb.testTbl5; 
DESCRIBE sqldb.testTbl6;

INSERT INTO testTbl5 VALUES (1, 'AAA'),
							(2, 'BBB'),
                            (3, 'AAA'),
                            (4, 'SSS');
UPDATE testTbl5 SET name = 'CCC' WHERE num = 3;
DELETE FROM testTbl5 WHERE num = 4;
SELECT * FROM testTbl5;

SELECT * FROM userTbl;
DELIMITER $$
CREATE PROCEDURE youngOrOld(IN whosname VARCHAR(3))
BEGIN
	DECLARE bYear INT;
    -- SELECT 가져올 컬럼명 INTO 삽입되는 컬럼명 FROM 가져올 테이블 WHERE 조건;
    SELECT birthYear INTO bYear FROM userTbl WHERE whosname = name;
	
    IF (bYear > 1980) THEN 
		SELECT CONCAT(bYear, '년생 ', whosname, '은 나이가 그렇게 많지 않다.');
	-- ELSE 뒤에는 THEN 을 입력하지 않음 
	ELSE
		SELECT CONCAT(bYear, '년생 ', whosname, '은 나이가 많다.');
	END IF;
END $$
DELIMITER ;

CALL youngOrOld('이승기');
CALL youngOrOld('조용필');







