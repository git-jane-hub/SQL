/* SQL 구문의 분류
DDL: Data Definition Language, 데이터 정의 언어
	데이터베이스, 테이블, 뷰, 인덱스 등을 생성 / 삭제
    CREATE, DROP, ALTER
    (DML과 달리 commit;이 없이도 바로 서버에 반영됨)
DML: Data Manipulation Language, 데이터 조작 언어
	내부 데이터를 변경하기 위해 사용
	SELECT, INSERT, UPDATE, DELETE
DCL: Data Control Language, 데이터 제어 언어
	특정 계정에 권한을 부여하거나 박탈할 때 사용
    GRANT, REVOKE, DENY */

/* INSERT 구문은 특정 테이블에 자료를 삽입
INSERT INTO 테이블명(컬럼1, 컬럼2, ...) VALUES (값1, 값2, ...)
만약 모든 테이블에 자료를 삽입하고 싶을 때는
INSER INTO 테이블명 VALUES(값1, 값2, ...)과 같이 테이블 뒤에 컬럼명을 생략 가능 */
USE sqlDB;
CREATE TABLE testTbl1 (
	id int,
	userName char(3),
	age INT
);

-- 테이블명 뒤에 컬럼정보를 적지 않으면 CREATE TABLE 시 설정한 컬럼 정보가 순서대로 입력됨
INSERT INTO testTbl1 VALUES (1, '홍길동', 25);    

-- id와 이름에만 데이터를 삽입할 때는 컬럼명을 생략 불가능
INSERT INTO testTbl1(id, userName) VALUES (2, '김길동');

-- 컬럼명 지정을 하지 않고 age에 null값을 넣으려고 한다면
INSERT INTO testTbl1 VALUES (3, '이길동', NULL); 

-- 컬럼의 순서를 변경하여 삽입하는 경우는 모든 컬럼에 값을 입력하는 상황이여도 컬럼명 생략 불가능
INSERT INTO testtbl1(userName, age, id) VALUES ('하길동', 10, 4);
SELECT * FROM testTbl1;

/* testTbl1은 id값을 수동으로 입력하는데, 이 경우 사용자가 id값을 계산하여 입력해야 함
AUTO_INCREMENT 속성을 컬럼에 작성하면 데이터를 입력하지 않아도 컴퓨터가 순차적으로 컬럼에 중복되지 않고 증가하는 숫자를 자동 입력함 */
CREATE TABLE testTbl2 (
	id INT AUTO_INCREMENT PRIMARY KEY,
    userName CHAR(3),
    age INT
);

-- id 컬럼에는 AUTO_INCREMENT를 작성했으므로 NULL값으로 처리해도 자동으로 1부터 1씩 증가하며 삽입됨
INSERT INTO testTbl2 VALUES (NULL, '알파카', 4);
INSERT INTO testTbl2 VALUES (NULL, '에뮤', 2);
INSERT INTO testTbl2 VALUES (NULL, '토끼', 1);

-- AUTO_INCREMENT의 기준값을 1이 아닌 임의의 숫자부터 시작하고 싶다면 ALTER TABLE을 이용하여 값 수정이 가능
-- testTbl2의 AUTO_INCREMENT의 현재 값을 1000으로 변경
ALTER TABLE testTbl2 AUTO_INCREMENT = 1000;
INSERT INTO testTbl2 VALUES (NULL, '반달곰', 10);
INSERT INTO testTbl2 VALUES (NULL, '산양', 3);
INSERT INTO testTbl2 VALUES (NULL, '호랑이', 4);
INSERT INTO testTbl2 VALUES (NULL, '사자', 4);

-- 커맨드 라인에서 testTbl2 테이블에 데이터를 3개 더 입력 후 조회
SELECT * FROM testTbl2;

CREATE TABLE testTbl3(
	id INT AUTO_INCREMENT PRIMARY KEY,
	userName CHAR(3),
    age INT
);
ALTER TABLE testTbl3 AUTO_INCREMENT = 1000;

/* AUTO_INCREMENT의 증가되는 수치를 바꾸고자 할 때는 서버 변수인 @@AUTO_INCREMENT를 변경
해당 변수는 서버에 있는 변수이기 때문에, 전체 프로그램에 영향을 줌 */
SET @@AUTO_INCREMENT_INCREMENT = 3;

INSERT INTO testTbl3 VALUES (NULL, '고양이', 4);
INSERT INTO testTbl3 VALUES (NULL, '개', 4);
INSERT INTO testTbl3 VALUES (NULL, '원숭이', 4);

SELECT * FROM testTbl3;

-- @@AUTO_INCREMENT_INCREMENT 는 SQL 전체에 영향을 주기 때문에 주의해서 사용 - 1씩 증가되던 testTbl2 역시 3씩 증가됨
INSERT INTO testTbl2 VALUES (NULL, '고라니', 2);
INSERT INTO testTbl2 VALUES (NULL, '늑대', 2);
INSERT INTO testTbl2 VALUES (NULL, '기린', 2);

-- 하나의 INSERT INTO 구문으로 여러 열을 추가하고 싶다면, VALUES 뒤의 데이터를 연달아 작성
INSERT INTO testTbl2 VALUES (NULL, '말', 4),
							(NULL, '오리', 1),
							(NULL, '닭', 2);

SELECT * FROM testTbl2;

SET @@AUTO_INCREMENT_INCREMENT = 1;

/* UPDATE 구문은 기존에 입력되어 있는 값을 변경할 때 사용
WHERE 조건절을 사용하지 않는다면, 컬럼 하나의 값을 모두 변경
따라서 일반적으로는 조건절과 조합해서 사용
UPDATE 테이블명 SET 컬럼1 = 변경할 값1, 컬럼2 = 변경할 값2, ...; */

-- testTbl2의 userName을 전부 '소'로 변경하는 구문
UPDATE testTbl2 SET userName = '소';	-- 전체 컬럼을 전부 변경하는 해당 명령문은 실행되지 않음(워크벤치의 safe mode 기능이 막아줌_error code 1175 - 커맨드 라인에서는 실행됨)

-- 워크벤치의 safe mode 해제
SET SQL_SAFE_UPDATES = 0;

-- 워크벤치 상에서 userName을 전부 '말'로 변경
UPDATE testTbl2 SET userName = '말';

-- 워크벤치 safe mode 설정
SET SQL_SAFE_UPDATES = 1;

-- 특정 나이대의 userName을 동물로 교체 - WHERE절을 사용해 age를 필터링(워크벤치 safe mode 기능 적용됨)
UPDATE testTbl2 SET userName = '호랑이' WHERE age = 4;

-- 특정 컬럼의 값을 일괄적으로 계산식에 라 결과값을 얻어내 적용할 수 있음, 나이를 2배(워크벤치 safe mode 기능 적용됨)
UPDATE testTbl2 SET age = age * 2;

/* DELETE FROM 구문은 데이터를 삭제
SELECT는 특정 컬럼만 조회하거나 전체 컬럼을 조회하는 경우의 수가 있기 때문에
SELECT 와 FROM 사이에 구체적인 컬럼명 혹은 *을 작성하여 전체 컬럼을 조회했지만
DELETE는 특정 컬럼만 삭제하는 경우가 없고 전체 열을 삭제하거나 아니기 때문에
DELETE 와 FROM 사이에 작성하는 내용이 없음 
DELETE는 일반적으로 WHERE절과 함께 사용하며 WHERE절을 작성하지 않으면 테이블 전체 데이터가 삭제되므로 주의 */

-- DELETE를 사용해서 id = 1을 삭제
DELETE FROM testTbl2 WHERE id = 1;

-- LIMIT를 사용하면 검색 결과물 중 상위 n개만 삭제 가능
DELETE FROM testtbl2 LIMIT 2;

-- WHERE 절 없이 테이블 내 데이터 전체 삭제(워크벤치 safe mode 기능 적용됨)
DELETE FROM testTbl2;

-- 데이터를 삭제해도 앞의 id는 이어서 작성됨
INSERT INTO testTbl2 VALUES (NULL, '말', 1);

/* 대규모 데이터를 삭제하고자 하면,
DELETE FROM은 삭제하는데에 시간이 오래 걸리는데 트랜잭션 로그라는 것을 한 열마다 일일히 작성하기 때문
따라서 속도를 올리고 싶다면 TRUNCATE를 작성 - 데이터가 소규모인 경우에는 TRUNCATE가 더 오래걸림 */
TRUNCATE TABLE testTbl2;

-- TRUNCATE 와 DELETE FROM 속도차이 비교(30만개)
CREATE TABLE testTbl4(
	id INT,
    Fname varchar(50),
    Lname varchar(50)
);

INSERT INTO testTbl4(
	SELECT emp_no, first_name, last_name
		FROM employees.employees);

SELECT * FROM testTbl4;

-- DELETE FROM 시간 측정(워크벤치 safe mode 기능 적용됨) - 20초
DELETE FROM testTbl4;

-- TRUNCATE 시간 측정(워크벤치 safe mode 기능 적용 안됨) - 0.5초
TRUNCATE TABLE testTbl4;

SELECT * FROM testTbl2;

/* 조건부로 데이터 입력
 100개의 데이터를 입력하려고 할 때, 
 첫 번째 자료만 기존 데이터의 ID와 중복되는 값이 있고 이후 99건은 PK가 중복되지 않는다고 해도 SQL 시스템 상 전테 데이터가 입력되지 않는 문제가 발생됨
 따라서 이 때 중복되는 1건을 중복된다면 무시하고 이후 나머지 99개의 데이터는 중단 없이 정상적으로 입력하도록 할 수 있음 */
CREATE TABLE memberTbl (
	userId CHAR(3) PRIMARY KEY,
	name char(3) NOT NULL,
    addr char(2) NOT NULL
);

/* 데이터를 한 번 추가하고 다시 추가(데이터를 블록지정하고 번개모양 클릭)를 하면 에러가 발생하는데,
에러메세지에는 첫 번째 줄만 에러로 판단함 - 첫 번째 줄을 에러로 인식하면 다음 줄을 아예 실행하지 않음
즉, MySQL은 구문 실행 시 모두 실행하거나 모두 실행하지 않음 */
INSERT INTO memberTbl VALUES ('bbk', '바비킴', '서울');
INSERT INTO memberTbl VALUES ('ejw', '은지원', '경북');
INSERT INTO memberTbl VALUES ('jkw', '조관우', '경기');

-- 추가 데이터를 입력하되 한 건은 중복, 두 건은 중복이 없도록 작성
-- 이를 해결하기 위해 INSERT 와 INTO 사이에 IGNORE 추가(워크벤치 safe mode 기능 적용됨)
INSERT IGNORE INTO memberTbl VALUES ('bbk', '바비킴', '서울');
INSERT IGNORE INTO memberTbl VALUES ('ljy', '이지은', '경기'); 
INSERT IGNORE INTO memberTbl VALUES ('jbj', '장범준', '천안');

SELECT * FROM memberTbl;

-- 데이터를 작성할 때, 이미 존재하는 데이터라면 데이터를 갱신하여 입력하고 싶은 경우 - PRIMARY KEY가 중복되게 입력
INSERT INTO memberTbl VALUES ('ljy', '이지금', '제주');
-- ON DUPLICATE KEY UPDATE 구문을 사용해서 같은 PRIMARY KEY의 데이터를 갱신 - PRIMARY KEY가 중복된다면, INSERT INTO 구문 대신 ON DUPLICATE KEY UPDATE 뒤의 내용으로 적용
INSERT INTO memberTbl VALUES ('ljy', '이지금', '제주')
	ON DUPLICATE KEY UPDATE name = '이지금', addr = '제주';

-- ON DUPLICATE KEY UPDATE를 이용해서 중복되지 않는 PRIMARY KEY도 입력 - 중복되는 PRIMARY KEY가 없기 때문에 ON DUPLICATE KEY UPDATE 대신 INSERT INTO 구문이 적용
INSERT INTO memberTbl VALUES ('lhl', '이효리', '제주')
	ON DUPLICATE KEY UPDATE name = '이효리', addr = '제주';
INSERT INTO memberTbl VALUES ('b', '비', '서울')
	ON DUPLICATE KEY UPDATE name = '씨', addr = '경기';

/* [사용자 관리하기]
현재 root 계정은 모든 권한 (수정, 삭제, 조회, 변경, 계정생성_root만 가능 등)을 가지고 있음
모든 사람이 이 계정을 사용할 필요가 없으며, 데이터베이스의 데이터 보안을 위해 권한 별로 데이터베이스 계정을 나눠서 관리
root가 아닌 사용자를 만들고, 그 사용자에 대해 권한부여를 하는 방법과 권한의 개념에 대해 알아보기 */

/* work bench에서 계정 생성 및 권한 부여하기
 1. 좌측의 Navigator에서 Administration 탭을 클릭 
 2. Users and Privileges를 클릭 
 3. 좌측 하단에 Add Account를 클릭하고 Login Name, Password를 입력
 4. 우측 하단에 Apply를 클릭하면 계정 생성 완료 
 5. Account Limit 은 시간당 기능 사용 가능 횟수를 설정
 6. Administrative Roles 는 어떤 구문 실행까지 허용할지 설정 */

/* 위 내용을 커맨드 라인에서 생성하고자 한다면,
CREATE USER manager@'%' IDENTIFIED BY 'mysql';
GRANT ALL on *.* TO manager@'%' WITH GRANT OPTION;
을 입력해서 처리 가능 */

/* 커맨드 라인에서 사용자 계정 조회
1. show databases; 로 조회하면 나오는 mysql이 유저의 정보를 담고있음
2. USE mysql;로 데이터 베이스를 변경하고
3. SELECT user, host FROM user;로 조회하면 users에 대한 정보 조회 가능
워크벤치에서 사용자 계정 조회 - Users and Privileges */
SHOW DATABASES;
USE mysql;
SELECT user, host FROM user;

-- 사용중인 DB의 테이블 조회
SHOW TABLES;

/* 계정 만들기
CREATE USER 아이디@'%' IDENTIFIED BY '비밀번호'; */

/* 계정에 권한 부여
GRANT 권한1, 권한2, ... ON 데이터베이스명.테이블명 TO 아이디@'%'; - 모든 권한을 작성하려면 *이 아닌 ALL
sqlDB 데이터베이스의 testTbl3 테이블을 SELECT, DELETE 할 수 있도록 권한을 부여한다면,
GRANT SELECT, DELETE ON sqlDB.testTbl3 TO staff@'%';
WITH GRANT OPTION: 다른 계정에 대한 계정 설정 권한 */

/* 계정에 권한 박탈
REVOKE 대신 GRANT 작성 - REVOKE는 GRANT 와 TO 처럼 FROM 과 연동하여 사용
REVOKE 권한1, 권한2, ... ON 데이터베이스명.테이블명 FROM 계정명; */

describe testbl4;

/* [조인(JOIN)]
2개 이상의 테이블을 결합 - 여러 테이블에 나누어 삽입된 연관된 데이터를 결합해주는 기능
같은 내용의 컬럼이 존재해야만 사용할 수 있음
SELECT 테이블1.컬럼1, 테이블1.컬럼2, 테이블2.컬럼1, 테이블2.컬럼2, ...
    FROM 테이블1 JOIN 구문 테이블2
    ON 테이블1.공통 컬럼 = 테이블2.공통 컬럼;
WHERE 은 ON으로 합쳐진 결과 컬럼에 대한 필터링
userTbl 과 buyTbl 에서 공통된 컬럼은 userId
userId를 이용해서 두개의 연관된 테이블을 결합 */
SELECT * FROM buytbl b JOIN usertbl u ON b.userId = u.userId;
SELECT * FROM buytbl JOIN usertbl ON buytbl.userId = usertbl.userId;

SELECT * FROM buytbl INNER JOIN usertbl ON buytbl.userId = usertbl.userId;
-- 구매자 정보를 조회하려고 할 때, 필요한 정보는 buytbl의 구매 물품 정보 전체, usertbl은 택배를 받기 위한 이름, 주소, 폰번호가 필요
-- JOIN구문을 사용해서 필요한 컬럼 출력
SELECT buytbl.*, usertbl.name, usertbl.addr, usertbl.pnum FROM buytbl INNER JOIN usertbl ON buytbl.userId = usertbl.userId;

-- FROM 테이블명 별명을 적을 경우, 테이블명을 풀네임으로 작성하지 않고 별명으로 대체 가능
SELECT b.*, u.name, addr, pnum FROM buytbl b INNER JOIN usertbl u ON b.userId = u.userId;

-- WHERE절은 결과가 실행되면 추가 필터링만 담당 - 앞의 JOIN문이 실행되고나면, 실행된 내용에서 조건을 적용함
-- 구매물건이 2개 이상인 경우만 조회하는 구문
SELECT b.*, u.name, addr, pnum FROM buytbl b INNER JOIN usertbl u ON b.userId = u.userId WHERE b.amount > 1 ORDER BY b.userId;

-- 위 구문에 ORDER BY를 추가해서 높은 가격의 물건부터 정렬(컬럼명을 작성할 때는 테이블명.을 작성하는 것이 좋음)
SELECT b.*, u.name, u.addr, u.pnum FROM buytbl b INNER JOIN usertbl u ON b.userId = u.userId WHERE b.amount > 1 ORDER BY b.price DESC;

-- 잘 이해안됨
/* INNER JOIN구문을 사용하면 결합한 두 테이블의 모든 데이터가 조회되는 것이 아닌 누락된 데이터가 발생 - 양 테이블의 교집합만 조회됨
FULL JOIN은 누락된 데이터 없이 양 테이블의 모든 자료 조회가 가능하며
한 테이블의 접점이 없는 데이터는 다른 한쪽의 데이터를 NULL 값으로 가짐
- MySQL에서 지원하지 않는 기능, UNION을 이용해 LEFT, RIGHT JOIN 결과물을 합쳐서 구현
UNION은 위의 결과물과 아래 결과물을 결합함
 */
SELECT * FROM usertbl u RIGHT OUTER JOIN buytbl b ON b.userId = u.userId
UNION
SELECT * FROM usertbl u LEFT OUTER JOIN buytbl b ON b.userId = u.userId;

/* FROM 'LEFT' JOIN 구문 'RIGHT'
RIGHT OUTER JOIN: RIGHT 테이블에 있는 모든 데이터가 조회되고, 따라서 LEFT 테이블에서는 RIGHT 테이블의 교집합(접점이 있는) 데이터만 출력됨
LEFT OUTER JOIN: LEFT 테이블에 있는 모든 데이터가 조회되고, 따라서 RIGHT 테이블에서는 LEFT 테이블의 교집합(접점이 있는) 데이터만 출력됨
LEFT JOIN, RIGHT JOIN은 공통 데이터가 아닌 데이터도 위치에 따라 출력되므로
공통 데이터(INNER) 가 아닌 데이터(OUTER)까지 출력되는 점을 반영해 OUTER JOIN이라고 칭함
LEFT OUTER JOIN은 JOIN구문을 기준으로 왼쪽 테이블의 자료는 모두 출력하고 오른쪽 테이블의 데이터는 왼쪽 테이블과 매칭되는 데이터만 출력
RIGHT OUTER JOIN은 그 반대 */
SELECT * FROM userTbl u LEFT OUTER JOIN buyTbl b ON b.userId = u.userId;

-- FULL OUTER JOIN 예시
CREATE TABLE student(
	name char(3) PRIMARY KEY,
    addr char(2) NOT NULL
);
CREATE TABLE membership(
	name char(3) PRIMARY KEY,
    point int NOT NULL
);	
INSERT INTO student VALUES ('채종훈', '경기');
INSERT INTO student VALUES ('양현종', '서울');
INSERT INTO student VALUES ('박효준', '제주');

INSERT INTO membership VALUES ('채종훈', 100);
INSERT INTO membership VALUES ('양현종', 200);
INSERT INTO membership VALUES ('오타니', 50);

SELECT * FROM student;
SELECT * FROM membership;

/* student에 존재하는 데이터는 모두 조회됨
student에 존재하는 데이터이지만 membership에 없는 데이터는 null값으로 조회
membership의 데이터는 student와 교집합인 데이터는 조회가 가능하지만 차집합은 조회 불가능 */
SELECT * FROM student s LEFT OUTER JOIN membership m ON s.name = m.name;
SELECT * FROM membership m LEFT OUTER JOIN student s ON s.name = m.name;

-- 모든 데이터를 조회하려면 UNION을 이용해서 구현
SELECT * FROM student s LEFT OUTER JOIN membership m ON s.name = m.name
UNION
SELECT * FROM membership m LEFT OUTER JOIN student s ON s.name = m.name;

-- LEFT OUTER JOIN 과 RIGHT OUTER JOIN을 둘 다 사용하면서도 위와 같은 데이터가 조회되는 구문
SELECT * FROM student s LEFT OUTER JOIN membership m ON s.name = m.name
UNION
SELECT * FROM student s RIGHT OUTER JOIN membership m ON s.name = m.name;
