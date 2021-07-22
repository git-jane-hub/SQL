/* SELECT  구문은 DB 내부의 자료를 조회하는 구문
SELECT 컬럼명1, 컬럼2, ... FROM 테이블 이름 WHERE 조건; 형식으로 사용 */

/* SELECT 구문을 활용하기에 앞서 사용할 데이터베이스(스키마)를 지정해야함 이를 위해 USE 구문 사용
아래 구문은 좌측 SCHEMAS에서  employees를 우클릭하고 set as default schema를 클릭하는 것과 같은 효과 */
-- employees 데이터베이스가 지금부터 모든 명령을 받음 ('use'라는 명령어를 통해 테이블명 앞에 데이터베이스명을 생략한다는 의미) (한 줄 주석은 "-- 주석 내용" 으로 작성)
USE employees;
USE ict03;
-- employees 데이터베이스 내부의 employees table 조회
-- SQL 구문은 명령구문은 무조건 대문자, 테이블명이나 호칭 등은 소문자로 작성하는 것이 관례, 가독성에 좋음
SELECT * FROM employees;

-- 원래 테이블 조회시에는 데이터베이스명.테이블명으로 표기해야함
SELECT * FROM employees.employees;

-- 컬럼을 전체가 아닌 임의로 가져올 때는 컬럼명을 ,(콤마)로 구분
-- 이 경우 모든 컬럼이 아닌 일부 컬럼만 조회가 가능하며 한 개의 컬럼만 조회하는 등 개수 조절도 가능
SELECT gender, first_name, last_name FROM employees;

-- CMD 환경에서는 좌측 스키마 처럼 DB목록을 보여주는 창이 없으므로 아래 명령어를 이용해 DB목록 확인 가능
SHOW databases;

-- 현재 DB정보를 조회하려면
SHOW TABLE STATUS;

-- 특정 테이블의 컬럼 정보를 조회하려면 아래 명령어를 사용, DESCRIBE 테이블명; 혹은 DESC 테이블명;
DESCRIBE employees;
DESC employees;

-- 보통 DB를 생성하는데, 간혹 DB를 초기화하기 위해 기존에 같은 이름을 가진 DB가 존재한다면 삭제하고 다시 만들어야된다는 명령을 내림, 아래처럼 조건문을 이용해 처리
DROP DATABASE IF EXISTS sqlDB; -- sqlDB가 존재시(IF EXISTS) 삭제
CREATE DATABASE sqlDB DEFAULT CHARACTER SET utf8;

-- 테이블 생성, 생성시 적힌 제약조건과 컬럼명을 활용
CREATE TABLE userTbl (
	userID char(8) PRIMARY KEY, 
    name varchar(10) NOT NULL,
    birthYear int NOT NULL, 
    addr char(2) NOT NULL, 
    pnum char(11), 
    height int, 
    mDate date
);
/* PRIMARY KEY: 각 테이블을 대표할 수 있는 대표 데이터를 저장하는 컬럼에 작성
모든 테이블은 무조건 '하나'의 PRIMARY KEY를 가짐 - 자동으로 중복을 방지(UNIQUE)하며 NULL 값을 받을 수 없음 */
/* FOREIGN KEY: 다른 테이블의 PRIMARY KEY를 받아옴, 특적 테이블의 값만 해당 컬럼에 들어올 수 있도록 하는 제약 조건
두 테이블에서의 기본키와 외래키 컬럼의 자료형과 크기는 같아야함
참조 컬럼에 있는 자료만 타겟 컬럼으로 들어올 수 있음 - userTbl.userId에 자료가 있어야만 buyTbl.userId에 입력될 수 있음 */
-- AUTO_INCREMENT: 데이터 삽입 시 NULL값을 입력하면 컴퓨터가 자동으로 1씩 추가되도록 작성함

CREATE TABLE buyTbl (
	num int AUTO_INCREMENT PRIMARY KEY, 
    userId char(8) NOT NULL,
    prodName char(6) NOT NULL, 
    groupName char(4), 
    price int NOT NULL, 
    amount int NOT NULL, 
    FOREIGN KEY (userId) REFERENCES userTbl(userId)
);

DROP TABLE IF EXISTS buyTbl;
-- cmd창에서 테이블을 삭제하고 생성할 때는 db를 use sqldb로 맞춰줘야 함
DROP TABLE IF EXISTS userTbl;

INSERT INTO userTbl VALUES('LSG', '이승기', 1987, '서울', '01111111111', 182, '2008-8-8');
INSERT INTO userTbl VALUES('KBS', '김범수', 1979, '경남', '01122222222', 173, '2012-4-4');
INSERT INTO userTbl VALUES('KKH', '김경호', 1971, '전남', '01133333333', 177, '2007-7-7');
INSERT INTO userTbl VALUES('JYP', '조용필', 1950, '경기', '01144444444', 166, '2009-4-4');
INSERT INTO userTbl VALUES('SSK', '성시경', 1979, '서울', null, 186, '2013-12-12');
INSERT INTO userTbl VALUES('LJB', '임재범', 1963, '서울', '01166666666', 182, '2009-9-9');
INSERT INTO userTbl VALUES('YJS', '윤종신', 1969, '경남', null, 170, '2005-5-5');
INSERT INTO userTbl VALUES('EJW', '은지원', 1972, '경북', '01188888888', 174, '2014-3-3');
INSERT INTO userTbl VALUES('JKW', '조관우', 1965, '경기', '01199999999', 172, '2010-10-10');
INSERT INTO userTbl VALUES('BBK', '바비킴', 1973, '서울', '01100000000', 176, '2013-5-5');

INSERT INTO buyTbl VALUES(null, 'KBS', '운동화', null, 30, 2);
INSERT INTO buyTbl VALUES(null, 'KBS', '노트북', '전자', 1000, 1);
INSERT INTO buyTbl VALUES(null, 'JYP', '모니터', '전자', 200, 1);
INSERT INTO buyTbl VALUES(null, 'BBK', '모니터', '전자', 200, 5);
INSERT INTO buyTbl VALUES(null, 'KBS', '청바지', '의류', 50, 3);
INSERT INTO buyTbl VALUES(null, 'BBK', '메모리', '전자', 80, 10);
INSERT INTO buyTbl VALUES(null, 'SSK', '책', '서적', 15, 5);
INSERT INTO buyTbl VALUES(null, 'EJW', '책', '서적', 15, 2);
INSERT INTO buyTbl VALUES(null, 'EJW', '청바지', '의류', 50, 1);
INSERT INTO buyTbl VALUES(null, 'BBK', '운동화', NULL, 30, 2);
INSERT INTO buyTbl VALUES(null, 'EJW', '책', '서적', 15, 1);
INSERT INTO buyTbl VALUES(null, 'BBK', '운동화', NULL, 30, 2);
-- 없는 아이디로 데이터 입력
INSERT INTO buyTbl VALUES(null, 'CJI', '운동화', '의류', 30, 2);

SELECT * FROM userTbl;
SELECT * FROM buyTbl;

/* 위의 SELECT 구문들은 조건 없이 데이터를 조회함
employees 테이블의 많은 row를 조회하면 시간이 오래걸림 - 조건에 맞는 필터링을 하려면 WHERE 구문 사용
SELECT 컬럼명1, 컬럼명2, ... FROM 테이블명 WHERE 컬럼명 + 조건식; */
SELECT * FROM userTbl WHERE name = '김경호';

/* 관계 연산자를 활용하여 대소 비교를 하거나 'and(그리고)', 'or(혹은)'을 이용해 조건을 여러개 연결할 수 있음
1970년 이후 출생하고 키가 182 이상인 사람이 아이디와 이름을 조회하는 구문을 작성 */
SELECT userID, name FROM usertbl where (birthYear > 1970) and (height >= 182);

-- 키가 180 이상 183 이하인 사람만 필터링
SELECT * FROM usertbl WHERE (height >= 180) and (height <= 183);

-- 위와 같이 범위를 정하는 구문은 BETWEEN ~ AND (이상 혹은 이하)로 간단하게 구현
SELECT * FROM userTbl WHERE height BETWEEN 180 AND 183;

/* 위와 같이 숫자는 연속된 범위를 갖기 때문에 범위 연산자로 처리 가능
addr 같은 자료는 크기로 연산적 처리가 불가능
지역이 경남, 전남, 경북인 사람을 조회 - 조건식에 조회하고자 하는 데이터를 입력할 때는 컬럼명 연산자 데이터, 컬럼명 연산자 데이터, ... 로 입력 */
SELECT * FROM userTbl WHERE (addr = '경남') or (addr = '전남') or (addr = '경북');

/* 조회하려는 정보의 조건이 늘어날 수록 작성이 번거로워짐
IN (데이터1, 데이터2, ...); - 특정 컬럼에 괄호에 담긴 데이터가 포함되는 경우를 정부 출력 */
SELECT * FROM userTbl WHERE addr IN ('경남', '전남', '경북');

/* LIKE 연산자는 일종의 표현 양식을 만듦
LIKE 연산자를 이용해 '%'(% 뒤의 글자 수 상관없음, 0글자부터 무한대까지) 혹은 '_'(_ 뒤에 나오는 글자는 한 글자만) 라는 와일드 카드 구문을 사용해 매치되는 문자 혹은 문자열을 조회 가능 */
SELECT * FROM userTbl WHERE name LIKE '김%';
-- 언더바를 사용해서 김씨를 조회하려면 글자 개수만큼 언더바를 입력해줘야 함
SELECT * FROM usertbl WHERE name LIKE '김__';
SELECT * FROM userTbl WHERE addr LIKE '경_';

/* 서브 쿼리(하위 쿼리)란 1차적 결과를 얻고, 그 결과에서 다시 조회 구문을 중첩하여 조회하는 것 */
-- 김경호보다 키가 큰 사람을 조회
-- 1. 김경호의 키를 WHERE절을 이용해 확인 
SELECT height FROM userTbl WHERE name = '김경호';
-- 2. 확인한 김경호의 키를 쿼리문에 넣어 조회
SELECT name, height FROM userTbl WHERE height > 177;

/* 서브 쿼리를 이용해 김경호보다 키가 큰 사람을 조회
FROM절 다음에 ()를 이용하여 SELECT 구문을 활용 */
SELECT name, height FROM userTbl WHERE height > (SELECT height FROM userTbl WHERE name = '김경호'); -- 괄호 안의 값이 김경호의 키 값인 177가 같음 - 괄호 안의 내용이 먼저 처리됨
SELECT * FROM userTbl;

-- 지역이 경남이 사람등 중 키가 제일 큰 사람보다 키가 더 큰 타 지역 사람을 조회
SELECT * FROM userTbl WHERE height > (SELECT max(height) FROM userTbl WHERE (addr = '경남'));

-- ANY, ALL, SOME 구문은 서브 쿼리와 조합해서 사용(괄호 안의 조회되는 값이 2개 이상일 때 사용)
-- 지역이 경남인 사람보다 키가 큰 사람을 조회하흔 쿼리문
SELECT * FROM userTbl WHERE height >= (SELECT height FROM userTbl WHERE addr = '경남'); -- 괄호안 내용의 값이 여러 개가 조회되기 때문에 컴퓨터가 어느 값을 기준으로 잡아야 할지 알지 못함
-- ANY 구문을 사용하면 (170보다 크거나 같은 조건) OR (173보다 크거나 같은 조건) 으로 조회됨(개별 값 각각에 대해 OR이 적용됨) 즉, 170보다 크거나 같은 조건으로 졀론이 남
SELECT * FROM userTbl WHERE height >= ANY (SELECT height FROM userTbl WHERE addr = '경남'); 

-- 각 개별 값에 OR이 아닌 AND를 적용하려면 ALL을 이용 - 170보다 크거나 같은 조건) AND (173보다 크거나 같은 조건)
SELECT * FROM userTbl WHERE height >= ALL (SELECT height FROM userTbl WHERE addr = '경남');

-- ANY를 사용함에 있어 '='로 조건 비교를 하는 경우, 실제로는 IN 키워드와 같은 효과가 있음
SELECT name, height FROM userTbl WHERE height = ANY (SELECT height FROM userTbl WHERE addr = '경남');

/* ORDER BY는 결과물의 개수나 종류에는 영향을 미치지 않지만 결과물을 순서대로(오름차순, 내림차순) 정렬하는 기능을 가짐
SELECT 컬럼명 FROM 테이블 명 ORDER BY 기준컬럼 정렬기준(ASC: 오름차순 DESC: 내림차순, 입력이 없을 경우 기본은 ASC);름 */
-- 가입한 순서(mDate)를 오름차순으로 조회
SELECT * FROM userTbl ORDER BY mDate ASC;

/* 정렬 시 값이 같은 부분을 처리하기 위해 ORDER BY절을 두 개 이상 동시에 나열하는 것도 가능
아래 코드는 키로 내림차순을 하되, 값이 같으면 가나다라 순으로 나열 */
SELECT * FROM userTbl ORDER BY height DESC, birthYear ASC; -- ORDER BY 뒤 기준에서 앞의 조건으로 나오는 값이 같으면 뒤의 조건으로 값을 정렬

-- DISTINCT는 결과물로 나온 컬럼의 중복 값을 전부 제거하고 고유 값을 하나씩 남김 - 해당 컬럼의 항목 데이터 종류를 알 수 있음(개별적인 개수를 알 수는 없음)
SELECT addr FROM userTbl;
SELECT DISTINCT addr FROM usertbl;

-- 출력 요소의 개수를 제한하려면 LIMIT 구문을 사용
USE employees;
SELECT * FROM employees; -- 해당 테이블의 데이터 개수가 30만여개 이기 때문에 조회하는데에 시간이 오래걸림(워크벤치에서는 1000개가 조회됨)
-- 테이블명 LIMIT 슛자; 가 오는 경우는 입력한 숫자 개수만큼 결과창에 출력됨
SELECT * FROM employees LIMIT 10;

-- 테이블명 LIMIT 숫자1, 숫자2; 은 숫자1번째 데이터부터(데이터는 0번째부터 시작됨) 시작해서 숫자2 개수만큼 출력 
SELECT * FROM employees LIMIT 10, 10;

SELECT * FROM employees WHERE birth_date = hire_date;

/* GROUP BY 는 같은 데이터를 하나의 그룹으로 묶어줌
조건절은 WHERE절이 아닌 HAVING절로 처리) */
USE sqlDB;
-- 데이터 중 각 인물별로 구매한 개수 총합 구하기
SELECT userID, amount FROM buytbl ORDER BY userId;

-- SELECT 컬럼명, 집계함수(컬럼명2)... FROM 테이블명 GROUP BY 묶을 컬럼명;
SELECT userId, sum(amount) FROM buyTbl GROUP BY userId;

-- 각 유저별 구매물품의 평균가를 구해보기
SELECT userId, avg(price) AS 평균구매액, sum(price) AS 총구매액, count(userId) AS 구매횟수 FROM buytbl GROUP BY userId;
SELECT userId, avg(price) FROM buytbl GROUP BY userId;

-- 각 유저별 총 구매액(가격 * 개수를 모두 더한 값) 구하기
SELECT userId, sum(price * amount) FROM buytbl GROUP BY userId;
-- 과정
SELECT userId, price, amount, price * amount FROM buyTbl;

-- 각 물품 그룹별 총 판매 금액 집계
SELECT * FROM buytbl;
-- 컬럼명은 AS '변경명칭'으로 변경할 수 있음
SELECT groupName, sum(price * amount) AS '충매출' FROM buyTbl GROUP BY groupName;

/* 자주 사용하는 집계 함수 정리
AVG(): 평균
MIN(): 최소값
MAX(): 최대값
COUNT(): 로우 개수
COUNT(DISTINCT): 종류 개수
STDEV(): 표준편차
VAR_SAMP(): 분산 */

SELECT * FROM userTbl;
-- userTbl에서 키가 가장 큰 회원 조회
SELECT name, max(height) FROM userTbl; -- 같은 로우에 있는 값이 안나옴 
SELECT name, height FROM userTbl WHERE height = (SELECT max(height) FROM userTbl);
-- userTbl에서 키가 가장 작은 회원 조회
SELECT name, min(height) FROM userTbl;
SELECT name, height FROM userTbl WHERE height = (SELECT min(height) FROM userTbl);
-- userTbl에서 가수 전채의 키 평균 조회
SELECT name, avg(height) FROM userTbl;
SELECT avg(height) FROM userTbl;

/* GROUP BY 절에서는 조건절로 WHERE 절을 사용하지 않고 HAVING절 사용
사용법은 WHERE 절과 완전히 동일 */
SELECT userId, sum(price * amount) AS '총구매액' FROM buyTbl GROUP BY userId;
-- 위 결과값에서 1000이 넘는 사용자만 조회
SELECT userId, sum(price * amount) AS '총구매액' FROM buyTbl GROUP BY userId HAVING sum(price * amount) > 1000;






