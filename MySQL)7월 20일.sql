/* MySQL 에서도 프로그래밍이 가능하며 변수나 함수 등을 지정할 수 있음
JAVAM PYTHON CPP 등의 프로그래밍과는 달리 제한되는 점이 많지만 이를 활용하는 경우도 있음
변수 지정 및 출력 */

/* <MySQL 에서 변수 사용>
 변수를 지정할 때에는 SET @변수명 = 값; 의 문법 사용 */
SET @myVar1 = 5;
SET @myVar2 = 3;
SET @myVar3 = 4.25;
SET @myVar4 = '가수의 이름 -> ';
SET myVar5 = 50;	-- at sign을 작성해줘야 함

-- 출력은 SELECT @변수명;을 사용
SELECT @myVar1;
-- SELECT 뒤의 연산을 먼저 진행하고 SELECT문으로 값 반환
SELECT @myVar2 + @myVar3;
-- 	SELECT 구문처럼 콤마를 이용해 데이터를 여러개 반환 가능
SELECT @myVar4, name FROM userTbl;

-- 일반 구문 사용 시 LIMIT에는 숫자 대신 변수를 호출하여 사용할 수 없음
SELECT * FROM userTbl LIMIT @myVar1;	-- 변수의 값이 숫자로 치환되지 않음 - PREPARE 구문을 사용

/* PREPARE 구문
PREPARE 구문에 가변적으로 입력되는 문장요소의 자리에 ?를 입력하고, 그 자리를 EXECUTE 구문으로 채우는 방식 
PREPARE 구문이름 '실제 쿼리문'; 으로 선언
EXECUTE 구문이름 USING 전달 변수; 로 호출*/
SET @myVar5 = 3;
PREPARE myQuery											-- myQuery 라는 구문이름
	FROM 'SELECT name, height FROM userTbl LIMIT ?';	-- ?가 입력된 자리는 어떤 숫자가 입력될지 확정되지 않은 상태 - 불완전한 구문 / 사용자가 입력할 수 있게 작성된 구문
SELECT name, height FROM userTbl LIMIT 10;				-- 고정적으로 입력된 LIMIT 값

EXECUTE myQuery USING @myVar5;							-- USING 뒤에는 ?자리에 어떤 숫자를 입력할지 알려주는 변수를 입력 - FROM으로 입력된 PREPARE의 쿼리문을 myQuery 라는 구문이름으로 간단하게 호출 가능

/* <MySQL의 데이터 타입과 형 변환>
데이터 변환시에는 CAST(), CONVERT() 등의 함수를 이용해 처리
CAST(실행문 AS 바꿀 데이터타입);
CONVERT (실행문 , 바꿀 데이터타입); */
SELECT avg(amount) FROM buyTbl;		-- 실수로 반환되는 평균 구매 개수의 값을 형 변환
SELECT CAST(avg(amount) AS SIGNED INTEGER) AS 평균구매 FROM buyTbl;
SELECT CONVERT(avg(amount), SIGNED INTEGER) AS 평균구매 FROM buyTbl;

-- CAST를 이용하면 날짜 양식을 일정하게 만들 수 있음
SELECT CAST('2021$07$20' AS DATE);
SELECT CAST('2021/07/20' AS DATE);
SELECT CAST('2021%07%20' AS DATE);
SELECT CAST('2021@07@20' AS DATE);
SELECT CAST('2021#07#20' AS DATE);
SELECT CAST('2021(07(20' AS DATE);
SELECT CAST('2021+07+20' AS DATE);
SELECT CAST('2021!07!20' AS DATE);
SELECT CAST('2021^07^20' AS DATE);
SELECT CAST('2021*07*20' AS DATE);

-- Oracle은 SYSDATE, MySQL은 now()를 이용해 현재 날짜 및 시간을 확인 가능
SELECT now();

-- 묵시적 형 변환(자동 형 변환)
SELECT '100' + 200 ;	-- 문자를 숫자에 맞춰 형 변환 - 정수로 변환
SELECT '100' + '300';	-- 문자와 문자의 숫자도 숫자에 맞춰 형 변환 - 정수로 변환
-- 각각 숫자로 이루어진 문자열을 이어붙인 값을 반환하고 싶다면 CONCAT()을 이용
SELECT CONCAT('100', '200');
-- 문자열이 아닌 숫자로 된 값을 입력해도 이어붙인 문자열로 값을 반환 - CONCATENATE: 사슬처럼 이어붙이다
SELECT CONCAT(100, 200);

-- 값의 첫 글자에 숫자가 포함된 경우, 첫 글자를 숫자로 변환
-- 논리식 - 0은 FALSE, 1은 TRUE
SELECT 1 > '2mega';				-- '2mega' 가 값 2로 변환되어 1보다 작다는 논리식에 false 이므로 0 반환
SELECT 3 > '2mega';				
-- 값이 문자로만 이루어진 경우, 0으로 변환
SELECT 66 > 'AMEGA';

/* <MySQL 내장함수> 
 CONCAT, CAST, CONVERT 등과 같이 내부에 선언되어 바로 호출해서 사용할 수 있는 함수 */

/* IF (수식, 참일 때 리턴값, 거짓일 때 리턴값)
삼항 연산자와 비슷하게 판단 - 조건문 ? 참 리턴값 : 거짓 리턴값 */
SELECT IF(100 > 200, 'TRUE', 'FALSE') AS 판단;
SELECT IF(300 > 200, 'TRUE', 'FALSE');

/* IFNULL(수식1, 수식2)
수식1이 NULL값이 아니면 수식1이 반환
수식1이 NULL값이면 수식2로 반환 */
SELECT IFNULL(NULL, 'NULL값을 반환합니다.'), IFNULL(100, 'NULL값을 반환합니다.');

/* NULLIF(수식1, 수식2)
수식1과 수식2가 같으면 NULL값을 반환하고
수식1과 수식2가 다르면 수식1 값이 반환 */
SELECT NULLIF(100, 100), NULLIF(200, 100), NULLIF(NULL, 100), NULLIF(100, NULL);

/* CASE ~ WHEN ~ ELSE ~ END (SWITCH ~ CASE 구문과 비슷)
들어온 자료와 일치하는 구간이 있으면 그 값을 반환
들어온 자료와 일치하는 구간이 없으면 ELSE 자료를 반환, ELSE가 없으면 NULL 값을 반환
단 SQL 은 {}로 영역을 표시하지 않기 때문에 구문이 끝나는 지점에 END를 작성해야함 */
SELECT CASE 2
	WHEN 1 THEN 'ONE'
    WHEN 5 THEN 'FIVE'
    WHEN 10 THEN 'TEN'
    ELSE 'IDK'
END AS 'RESULT';

/* 문자열 함수
문자열을 조작 가능하며 활용도가 높음
ASCII(문자), CHAR(숫자)를 입력하면 문자는 숫자로, 숫자는 문자로 변경됨
CHAR()는 워크벤치상에서 버그로 인해 모든 문자가 BLOB으로 표현됨 - 원래 값을 보려면 BLOB 우클릭 - OPEN VALUE IN VIEWER - TEST탭 클릭 */
SELECT ASCII('B'), CHAR(65);

/* 문자열의 길이를 확인하기 위해서
CHAR_LENGTH(문자열) 을 사용, 결과로 나오는 숫자가 문자열의 길이 */
SELECT CHAR_LENGTH('가나다라마바사.!');
SELECT CHAR_LENGTH('AJBFLGDJFPAOEMG');

/* CONCAT(문자열1, 문자열2, ...);
문자열을 개수 상관없이 입력 가능 */
SELECT CONCAT('AA', 'AB', 'AC', 'AD');

/* CONCAT_WS(구분자, 문자열1, 문자열2, ...);
문자열 사이를 구분자를 이용해 이어붙임 */
SELECT CONCAT_WS('-', '010', '1234', '5678');
SELECT CONCAT_WS('/', '2021', '07', '20');

/* FORMAT(숫자, 소수점자리)
소수점 아래 몇 자리까지 반올림하여 표현할지 정해줌 */
SELECT FORMAT(1234.56789101112, 3);
SELECT FORMAT(9876.54321012345, 3);

/* BIN(숫자), HEX(숫자), OCT(숫자)
	2진수	  16진수		8진수
   Binary Hexa-Decimal Octal-Numeral
정수로 10진수 숫자를 바꿔서 표현 */
SELECT BIN(31), HEX(31), OCT(31);

/* INSERT(기준 문자열, 위치, 길이, 삽입할 문자열);
기준 문자열의 위치 ~ 길이 사이를 지워주고, 그 위치에 문자열을 삽입 */
SELECT INSERT('ABCDEFGHI', 3, 4, '@@@@@@');	-- 3번째 자리(0이 아닌 1부터 자릿수 시작)부터 삽입할 문자열을 4글자를 삭제하고 넣어줌

/* LEFT(문자열, 길이), RIGHT(문자열, 길이)
해당 문자열의 왼쪽, 오른쪽에서 문자열 길이만큼 남기고 전부 삭제 */
SELECT LEFT('ABCDEFGHI', 3), RIGHT('ABCDEFGHI', 4);

/* UCASE(영문자열), LCASE(영문자열)
소문자를 대문자로, 대문자를 소문자로 변환 */
SELECT UCASE('abcdEFGH'), LCASE('abcdEFG');
-- UPPER(문자열), LOWER(문자열) 도 같은 의미
SELECT UPPER('abcdEFGH'), LOWER('abcdEFG');

/* LPAD(문자열, 길이, 채울 문자열), RPAD(문자열, 길이, 채울 문자열)
해당 문자열이 길이보다 적을 때, 길이만큼 문자열을 늘리기 위해 채울 문자열으로 공백을 메움 */
SELECT LPAD('THIS', 5, '##'), RPAD('THAT', 5, '##');

/* LTRIM(문자열), RTRIM(문자열)
문자열의 왼쪽, 오른쪽 부분의 공백을 모두 삭제
단, 문자열 중간에 위치한 공백은 삭제되지 않음 */
SELECT LTRIM('                    THIS IS'), RTRIM('THAT IS                         ');
SELECT '                    THIS IS', 'THAT IS                         ';

/* TRIM(문자열), TRIM(방향 '삭제할 문자' FROM '대상 문자열')
TRIM은 LTRIM + RTRIM 형식으로 양쪽의 모든 공백을 삭제 
공백이 아닌 특정문자를 삭제하도록 구문을 지정할 수도 있음*/
SELECT TRIM('            THIS                     ');
-- 방향은 BOTH, LEADING(왼쪽_선두), TRAILING(오른쪽_남은자취) 중 하나를 작성
SELECT TRIM(BOTH 'K' FROM 'KKKKKKKKKKEEKKKKKKKKK');
SELECT TRIM(LEADING 'K' FROM 'KKKKKKKKKKEEKKKKKKKKK');
SELECT TRIM(TRAILING 'K' FROM 'KKKKKKKKKKEEKKKKKKKKK');

/* REPEAT(문자열, 횟수)
문자열을 횟수만큼 반복하여 반환 */
SELECT REPEAT('K', 10);

/* REPLACE(문자열, 원래문자열, 바꿀 문자열)
찾아서 바꾸기 */
SELECT REPLACE('THIS IS JAVA.', 'JAVA', 'MySQL');



/* REVERSE(문자열)
문자열을 인덱스의 역순으로 재배치 */
SELECT REVERSE('LQSyM');

/* SPACE(길이)
길이만큼의 공백을 사이에 넣어줌 */
SELECT CONCAT('THIS IS', SPACE(15), 'MySQL');			-- 문자열 사이에 띄어쓰기를 입력해주는 것과 같지만 공백이 몇 개 있는지 알 수 있기 때문에 코드 가독성에 좋음
SELECT CONCAT('THIS IS', '               ', 'MySQL');

/* 
SUBSTRING(문자열, 시작위치, 문자열 길이)
SUBSTRING(문자열 FROM 시작위치 FOR 문자열 길이)
시작위치부터 길이만큼의 문자를 반환
길이를 생략하고 파라미터를 2개만 입력하면 시작지점부터 문자열의 끝까지 반환됨 */

SELECT SUBSTRING('자바스프링마이에스큐엘', 6, 10);
SELECT SUBSTRING('자바스프링마이에스큐엘' FROM 6 FOR 10);

/* <SQL 프로그래밍과 프로시저>
함수: 매개변수와 반환값이 존재
프로시저: 매개변수는 존재하지만 반환값이 없고 특정 로직만 처리하고 종료
SQL에서도 프로그래밍이 가능 - DELIMETER는 JAVA의 MAIN METHOD와 같은 역할을 함
DELIMITER $$ -- 시작지점
CREATE PROCEDURE 선언할 프로시저명()
BEGIN -- 본 실행코드는 BEGIN 아래에 작성
	실행코드...
END $$
DELIMITER ;
선언한 프로시저는
CALL 프로시저명(); 으로 호출 
*/
-- IF ~ ELSE 구문을 프로시저로 작성

DELIMITER $$ 				
CREATE PROCEDURE ifProc()	
BEGIN
	DECLARE var1 INT;
	SET var1 = 100;
    
	IF var1 = 100 THEN
		 SELECT 'THIS IS 100';
	ELSE
		SELECT 'THIS IS NOT 100';
	END IF;	
END $$
DELIMITER ;	

CALL ifProc();

-- 테이블 호출 구문을 프로시저로 생성
DELIMITER $$
CREATE PROCEDURE getEmp()
	BEGIN
		SELECT * FROM employees LIMIT 10;
	END $$
DELIMITER ;

CALL getEmp();

/* userTbl에서 name, addr, height 조회하는 구문을 프로시저로 선언하고 호출
프로시저명은 getUser() */
USE sqldb;

SELECT * FROM userTbl;
# 프로시저 선언 시작지점
DELIMITER $$
CREATE PROCEDURE getUser()							# 프로시저 생성
	BEGIN											# 실행 구문 시작지점
		SELECT name, addr, height FROM userTbl;	
	END $$											# 실행 구문 종료지점
DELIMITER ;
# 프로시저 선언 종료지점
CALL getUser();

-- 프로시저를 생성하거나 삭제할 때에는 해당 DB를 사용해야 함
DROP PROCEDURE getUser;
DROP PROCEDURE getEmp;
DROP PROCEDURE ifProc;

/* 프로시저 활용
employee 테이블 10001번 직원의 입사일이 5년이 경과하였는지 여부를 확인
hire_date 컬럼의 DATE 자료를 이용해 판단 */
SELECT hire_date FROM employees WHERE emp_no = 10001;

DELIMITER $$
CREATE PROCEDURE getFive()
	BEGIN
		DECLARE hireDate DATE;						# 입사일_변수 선언
        DECLARE todayDate DATE;						# 오늘날짜_변수 선언
        DECLARE days INT;							# 오늘날짜부터 입사일까지의 경과 일수_변수 선언
        
        SELECT hire_date INTO hireDate				# 쿼리문의 결과로 나온 값을 hireDate 변수에 대입
			FROM employees WHERE emp_no = 10001;
            
		SET todayDate = CURRENT_DATE();				# 오늘날짜 함수
        SET days = DATEDIFF(todayDate, hireDate);	# 경과 일수 구하는 함수(시간차이, date difference)
        
        IF (days/365) >= 5 THEN 					# 입사 후 5년 경과한다면
			SELECT CONCAT('입사한지', days, '일이 경과했습니다.');
		ELSE
			SELECT CONCAT('5년 미만이며, ', days, '일째 근무중입니다.');
		END IF;
	END $$
DELIMITER ;

CALL getFive();

/* IF THEN 구문 이후에 ELSE 가 아닌 ELSEIF ~ THEN 을 작성하면 두 개 이상의 조건을 입력할 수 있음
getScore 프로시저 생성
변수 point(INT)는 점수를 입력받는데, 77점을 입력하고
변수 ranking(CHAR)는
	90점 이상이면 'A'를 저장
    80점 이상이면 'B'를 저장
    70점 이상이면 'C'를 저장
    60점 이상이면 'D'를 저장
    그 이하 점수는 'F'를 저장
IF 구문 종료 후 SELECT 구문과 CONCAT()을 활용해서
취득점수: 77, 학점: C라는 구문을 콘솔에 출력 */
DELIMITER $$
CREATE PROCEDURE getScore()
	BEGIN
		DECLARE point INT;            
        DECLARE ranking CHAR(1);
        
			SET point = 77;
			IF (point >= 90) THEN 
				SET ranking = 'A';
			ELSEIF (point >= 80) THEN 		# ELSEIF 띄어쓰기 없이 붙여서 작성
				SET ranking = 'B';
			ELSEIF (point >= 70) THEN 
				SET ranking = 'C';
			ELSEIF (point >= 60) THEN 
				SET ranking = 'D';
			ELSEIF (point < 60) THEN
				SET ranking = 'F';
			END IF;        
            
		SELECT CONCAT('취득점수:', point, ', 학점: ', ranking);
        
	END $$
DELIMITER ;

CALL getScore();

/* getScore2() 프로시저 - CASE 문을 이용해 작성
기본적인 변수나 점수대는 모두 getScore() 프로시저와 일치
CASE 
	WHEN 조건식 THEN
		실행문;
END CASE;
형태로 작성할 때, 범위 조건이 IF 구문처럼 적용됨
getScore()을 CASE 구문을 활용해 출력 */
DELIMITER $$
CREATE PROCEDURE getScore2()
	BEGIN
		DECLARE point INT;
        DECLARE ranking CHAR(1);
        
        SET point = 77;
        CASE
			WHEN (point >= 90) THEN SET ranking = 'A';
            WHEN (point >= 80) THEN SET ranking = 'B';
            WHEN (point >= 70) THEN SET ranking = 'C';
            WHEN (point >= 60) THEN SET ranking = 'D';
            ELSE SET ranking = 'F';
		END CASE;
        
	SELECT CONCAT('취득점수: ', point, ', 학점: ', ranking) AS 결과;
	END $$
DELIMITER ;

CALL getScore2();

/* SQL에서 WHILE 구문 작성
WHILE (조건식) DO
	실행문...
END WHILE;
조건식이 특정 조건을 만족시키지 못하면 WHILE 구문을 탈출하도록 함 */
DELIMITER $$
CREATE PROCEDURE whileProc()
BEGIN
	DECLARE i INT;			# i 변수 값으로 반복횟수를 조절
    SET i = 1;				# i가 1부터 시작해서
    
    WHILE (i <= 30) DO		# 30까지 반복하는 동안
		SET i = i + 1;		# 1씩 증가
	END WHILE;
    
    SELECT i;
END $$
DELIMITER ;

CALL whileProc();

/* 3 + 6 + 9 + 12 ... 와 같은 방식으로
3부터 99까지 더했을 때, 총합을 SELECT 구문으로 프로시저 작성 후 호출 */
DELIMITER $$
CREATE PROCEDURE sum3nProc()
	BEGIN
		DECLARE i INT;
        DECLARE sum INT;
        
        SET i = 0;
        SET sum = 0;
        
        WHILE (i < 34) DO
            SET sum = sum + (i * 3);	
            SET i = i + 1;				# i를 1씩 증가시키는 연산이 필요
            
		END WHILE;

		SELECT sum;
	END $$
DELIMITER ;

CALL sum3nProc();

/* <테이블 심화>
테이블을 생성
2가지 방법
1. CREATE TABEL 구문
2. DATABASE의 Tables 탭 우클릭 - Create Table... 클릭해 생성 */

/* 테이블 데이터 수정: ALTER TABLE 구문
컬럼 추가: ALTER TABLE 테이블명 ADD 컬럼명 자료형(크기) DEFAULT 값;
기존 테이블의 가장 마지막 컬럼 다음 위치에 자료가 추가됨 */
ALTER TABLE sqldb.wbTbl ADD job VARCHAR(15) DEFAULT 'NO JOB';

/* 테이블 데이터 삭제: ALTER TABLE 구문
컬럼 삭제: ALTER TABLE 테이블명 DROP COLUMN 컬럼명;
테이블 생성시 컬럼 삭제가 불가하도록 제약 조건을 설정하고 생성하는 경우가 있어 삭제가 불가능하기도 함 */
ALTER TABLE sqldb.wbtbl DROP COLUMN money;

/* 컬럼 변경: ALTER TABLE 테이블명 CHANGE COLUMN 컬럼명 변경할 컬럼명 변경할 데이터타입(크기) 변경할 기타 조건;
컬럼명을 변경하지 않고 내부 속성만 변경한다면 컬럼명과 변경할 컬럼명을 동일하게 작성 */
ALTER TABLE sqldb.wbtbl CHANGE COLUMN job ujob VARCHAR(20) DEFAULT '1';

/* 제약조건 추가
ALTER TABLE 테이블명 MODIFY 컬럼명 데이터타입 제약조건 */
ALTER TABLE sqldb.wbtbl MODIFY ujob VARCHAR(20) NOT NULL;
ALTER TABLE sqldb.wbtbl MODIFY ujob VARCHAR(20) UNIQUE;

-- 아래 다시
/* 제약조건 추가2
ALTER TABLE 테이블명 ADD CONSTRAINT 컬럼명 제약조건 */
ALTER TABLE sqldb.wbtbl ADD CONSTRAINT ujob UNIQUE;

/* 제약조건 삭제
ALTER TABLE 테이블명 DROP 제약조건명; */
ALTER TABLE sqldb.wbtbl DROP CONSTRAINT NOT NULL;

-- 제약조건 확인
SELECT * FROM information_schema.table_constraints;













