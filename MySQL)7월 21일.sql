-- 특정 DB의 제약조건 전체 조회
SELECT * FROM information_schema.table_constraints WHERE constraint_schema='sqldb';

/* <제약조건>
컬럼에 붙는 조건으로 데이터의 무결성을 보장하기 위해 추가적으로 작성하는 제한을 의미
제약조건이 작성된 컬럼에는 제약조건을 만족하는 데이터만 삽입될 수 있기 때문에 의도된 데이터만 삽입되는 장점이 있음 
제약조건 확인
DESC DB명.테이블명; */
DESC employees.emloyees;

/* 제약조건 추가
PRIMARY KEY
ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건명 PRIMARY KEY(컬럼명); */
CREATE TABLE testTbl5(
	num INT,														-- 현재 작성된 제약조건이 없음
    name VARCHAR(5)
);
ALTER TABLE testTbl5 ADD CONSTRAINT pk_tbl5num PRIMARY KEY(num);	-- num이라는 컬럼에 PRIMARY KEY 를 제약조건으로 수정

/* 제약조건 삭제
PRIMARY KEY
ALTER TABLE 테이블명 DROP PRIMARY KEY; */
ALTER TABLE testTbl5 DROP PRIMARY KEY;
DESC sqldb.testTbl5;

/* 제약조건 추가
FOREIGN KEY
ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건명(별명) FOREIGN KEY(컬럼명) REFERENCES 연결테이블(pk컬럼); */
CREATE TABLE testTbl6(
	fnum iNT NOT NULL,
    num INT PRIMARY KEY,
    id VARCHAR(5)
);
ALTER TABLE testTbl6 ADD CONSTRAINT fk_fnum FOREIGN KEY(fnum) REFERENCES testTbl5(num);

DESC sqldb.testTbl6;

/* 제약조건 삭제
FOREIGN KEY
ALTER TABLE 테이블명 DROP FOREIGN KEY 제약조건명; */
ALTER TABLE testTbl6 DROP FOREIGN KEY fk_fnum;

/* 프로시저 getFive()는 활용도가 떨어짐 - 다른 직원을 조회하려면 프로시저를 삭제하고 다시 생성해야 함
프로시저에서 파라미터를 통해 입력된 값마다 다르게 처리하는 방식으로 활용도를 높임 
파라미터를 추가한 프로시저 정의
파라미터 지정
CREATE PROCEDURE 프로시저명(IN 파라미터명 데이터타입(크기))
IN 뒤 파라미터 내부에 입력되는 매개변수는 기존의 테이블에 존재하는 컬럼이 아닌 새로 생성하는 것  */
DELIMITER $$
CREATE PROCEDURE singerAge(IN userName VARCHAR(10))		# 파라미터에 입력되는 내용을 아래 조건문에 해당하는 내용으로
BEGIN
	DECLARE bYear INT;
    SELECT birthYear INTO bYear FROM usertbl
		WHERE name = username;
	IF(bYear >= 1980) THEN
		SELECT 'HE IS YOUNG.' AS RESULT;
	ELSE 
		SELECT 'HE IS OLD.' AS RESULT;
	END IF;
END $$
DELIMITER ;

-- 파라미터 내부에 내용을 입력되는 내용이 없으면 에러 발생
CALL singerAge();
CALL singerAge('바비킴');
CALL singerAge('이승기');
SELECT * FROM userTbl;

SELECT * FROM employees;

DELIMITER $$
CREATE PROCEDURE getFive2(IN emp_num INT)
BEGIN
	DECLARE h_date DATE;
    DECLARE t_date DATE;
    DECLARE hDays INT;
    
    SELECT hire_date INTO h_date FROM employees
		WHERE emp_no = emp_num;						# 파라미터로 들어올 값을 어디서 조회해야하는지 데이터를 삽입해줌
        
	SET t_date = CURRENT_DATE();
    SET hDays = DATEDIFF(t_date, h_date);			# 오늘날짜 - 입사날짜
    
    IF(hdays / 365) > 5 THEN
		SELECT CONCAT('입사한지 ', hDays, '가 경과했습니다.');
	ELSE
		SELECT CONCAT('5년 미만이며 ', hDays, '일째 근무중이입니다.');
	END IF;
END $$
DELIMITER ;

CALL getFive2(10005);
		

/* <트리거>
특정 테이블에 명령이 내려지면 자동으로 연동된 명령을 수행하도록 구문을 걸어줌
예) 회원 탈퇴시 탛퇴한 회원을 DB에서 바로 삭제하지 하지 않고 탈퇴보류 테이블에 INSERT를 하거나
	수정이 일어나면 수정 전 내역을 따로 다른 테이블에 저장하거나
	특정 테이블 대상으로 실행되는 구문 이전이나 이후에 추가로 실핼할 명령어를 지정 
문법은 프로시저와 유사(달러자리에 슬래시로 입력)
DELIMITER //
CREATE TRIGGER 트리거명
	실행시점(BEFORE / AFTER) 실행로직(어떤 구문이 들어오면 실행할지 작성)
	ON 트리거적용테이블
	FOR EACH ROW
BEGIN
	트리거 실행시 작동코드
END //
DELIMITER ;
*/
-- 트리거를 적용할 테이블 생성
CREATE TABLE gameList(
	id INT,
    gameName VARCHAR(10)
);

INSERT INTO gameList VALUES (1, '바람의 나라'),
							(2, '스타크래프트'),
                            (3, '롤');
SELECT * FROM gameList;

-- 트리거를 gameList에 적용
DELIMITER //
CREATE TRIGGER testTrg
	AFTER DELETE 
    ON gameList
    FOR EACH ROW
BEGIN
	SET @msg = '게임이 삭제되었습니다.';
END //
DELIMITER ;

SELECT @msg = '';
INSERT INTO gameList VALUES (4, '배틀그라운드');
SELECT @msg;												-- NULL

-- workbench safe mode 해제
SET SQL_SAFE_UPDATES = 0; 
UPDATE gameList SET gameName = '리그오브레전드' WHERE id = 3;

DELETE FROM gameList WHERE id = 4;
SELECT @msg;												-- 게임이 삭제되었습니다.

















