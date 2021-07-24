/* DDL 데이터 정의어 -  commit; 없이 서버 반영 */
-- CREATE
	-- 데이터 베이스 생성
    CREATE DATABASE testDB DEFAULT CHARACTER SET UTF8;
		-- 생성한 데이터 베이스 사용
        USE testDB;
        -- 데이터 베이스 목록 조회
        SHOW DATABASES;
	-- 사용자 계정 생성(사용자 계정명과 비밀번호에 작은 따옴표
    CREATE USER 'testUser' IDENTIFIED BY 'testUser';
    -- 테이블 생성
    CREATE TABLE testTbl1 (
		uId VARCHAR(10) PRIMARY KEY,
        uPw VARCHAR(20) NOT NULL,
        uName VARCHAR(20) NOT NULL,
		uAddr VARCHAR(30),
        birthY INT
	);
    
	CREATE TABLE testTbl2 (
		uNum INT AUTO_INCREMENT PRIMARY KEY,
		uId VARCHAR(10),	-- testTbl1의 PRINARY KEY 와 testTbl2 의 FOREIGN KEY 데이터타입과 크기 동일
		uPrice INT,
        uAmount INT,
        uCount INT,
        FOREIGN KEY (uId) REFERENCES testTbl1(uId)	-- 컬럼명에 괄호
    );
-- ALTER
	-- AUTO_INCREMENT의 시작점 변경
    ALTER TABLE testTbl2 AUTO_INCREMENT = 100;
    SELECT * FROM testTbl1;
    -- 테이블 컬럼 추가
    ALTER TABLE testTbl1 ADD uheight INT DEFAULT 0;
    -- 테이블 컬럼 삭제
    ALTER TABLE testTbl1 DROP uheight;
	-- 테이블 컬럼 변경(CHANGE 뒤 기존 컬럼명 변경 컬럼명)
	ALTER TABLE testTbl1 CHANGE uheight uheight INT DEFAULT 180;
    -- 테이블 컬럼 제약조건 추가
	ALTER TABLE testTbl1 MODIFY uheight INT NOT NULL;	-- 제약조건 확인: DESC testTbl1;
    -- 테이블 컬럼 제약조건 추가
    CREATE TABLE testTbl3(
		uNum INT,
        uId VARCHAR(10)
    );
    DESC testTbl3;
    ALTER TABLE testTbl3 ADD CONSTRAINT pk_uId PRIMARY KEY (uNum);
    ALTER TABLE testTbl3 ADD CONSTRAINT fk_uId FOREIGN KEY (uId) REFERENCES testTbl1(uId);
    ALTER TABLE testTbl3 DROP PRIMARY KEY;
    ALTER TABLE testTbl3 DROP FOREIGN KEY fk_uId;
    
-- DROP
	-- 테이블 삭제
    DROP TABLE IF EXISTS testTbl1;
    DROP TABLE IF EXISTS testTbl2;
-- TRUNCATE
	-- 테이블 삭제
    TRUNCATE TABLE testTbl1;
    TRUNCATE TABLE testTbl2;
    
/* DML 데이터 조작어 */
-- SELECT
	-- 테이블 조회(WHERE, GROUP BY ~ HAVING)
    SELECT * FROM testTbl1;
    SELECT * FROM testTbl2;
    -- 테이블 조건 조회
    SELECT * FROM testTbl2 WHERE price > 100000;
    SELECT uName FROM testTbl1 WHERE birthY > 2000;
    SELECT * FROM testTbl1 WHERE birthY BETWEEN 1995 AND 2000;
    SELECT * FROM testTbl1 WHERE uAddr IN ('JEJU', 'SEOUL');
    SELECT * FROM testTbl1 WHERE uAddr LIKE 'SE%';
    SELECT uId, SUM(uCount) FROM testTbl2 GROUP BY uId HAVING SUM(uCount) > 1;
    SELECT * FROM testTbl2 WHERE birthY >= ALL (SELECT birthY FROM testTbl1 WHERE birthY >= 1995) GROUP BY uId HAVING SUM(uPrice);
    -- 테이블 조건 조회(JOIN)
    SELECT * FROM testTbl1 t1 LEFT OUTER JOIN testTbl2 t2 ON t1.uId = t2.uId 
	UNION
    SELECT * FROM testTbl1 t1 RIGHT OUTER JOIN testTbl2 t2 ON t1.uId = t2.uId;
    SELECT * FROM testTbl1 t1 LEFT OUTER JOIN testTbl2 t2 ON t1.uId = t2.uId WHERE birthY >= 1995;
    -- JOIN 후 조건을 적용하여 조회할 때에는 조회하는 컬럼을 정확하게 명시 
    SELECT t2.uid, SUM(uPrice) FROM testTbl1 t1 LEFT OUTER JOIN testTbl2 t2 ON t1.uId = t2.uId GROUP BY t2.uId HAVING SUM(uPrice) > 100000;
    -- 중복된 값을 제거하고 조회할 때에는 조회하는 컬럼을 정확하게 명시
    SELECT DISTINCT uid FROM testTbl2;
    -- 제한적인 조회
    SELECT * FROM testTbl1 LIMIT 3;
-- INSERT
	-- 데이터 삽입
    INSERT INTO testTbl1 VALUES ('AAA', '123', 'JAMES', 'JEJU', 1995),
							   ('BBB', '456', 'KEVIN', 'SEOUL', 1993),
                               ('CCC', '789', 'ABBY', 'GG', 1990),
                               ('DDD', '1011', 'TOM', 'IC', 2000),
                               ('EEE', '1213', 'BROWN', 'SEOUL', 2003);
	-- 데이터 갱신(기본키 중복시)
	INSERT INTO testTbl1 VALUES ('EEE', '1213', 'BROWN', 'SEOUL', 2003)
		ON DUPLICATE KEY UPDATE uAddr = 'JEJU';
	INSERT INTO testTbl2 VALUES (NULL, 'AAA', 200000, 20, 1),
								(NULL, 'BBB', 300000, 80, 1),
                                (NULL, 'AAA', 30000, 1, 1),
                                (NULL, 'CCC', 90000, 15, 1),
                                (NULL, 'EEE', 50000, 5, 1),
                                (NULL, 'EEE', 40000, 2, 1);
-- UPDATE
	-- 기존 데이터 변경
    UPDATE testTbl1 SET uAddr = 'GG' WHERE uName = 'TOM';	-- SET SQL_SAFE_UPDATES = 0;
    
-- DELETE
	-- 기존 데이터 삭제
    DELETE FROM testTbl2 WHERE uPrice = 40000;
/* DCL 데이터 제어어 */
-- GRANT
	-- 사용자 계정 권한 부여(GRANT 부여할 권한 ON 데이터베이스명.테이블명 TO 계정명
    GRANT ALL PRIVILEGES ON testDB.testTbl1 to testUser;
-- REVOKE
	-- 사용자 계정 권한 박탈
    REVOKE ALL PRIVILEGES ON testDB.testTbl1 FROM testUser;
    
-- COMMIT
	-- 데이터 작업 결과 반영
    COMMIT;