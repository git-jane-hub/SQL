CREATE TABLE userTbl(
	userId CHAR(8) PRIMARY KEY,
    name VARCHAR(10) NOT NULL,
    birthYear INT NOT NULL,
    addr CHAR(2) NOT NULL,
    pnum CHAR(11),
    height INT,
    mDate DATE
);

CREATE TABLE buyTbl(
	num INT AUTO_INCREMENT PRIMARY KEY,
    userId CHAR(8) NOT NULL,
    prodName CHAR(6) NOT NULL,
    groupName CHAR(4),
    price INT NOT NULL,
    amount INT NOT NULL,
    FOREIGN KEY (userId) REFERENCES userTbl(userId)
);
DROP TABLE IF EXISTS buyTbl;
DROP TABLE IF EXISTS userTbl;

INSERT INTO userTbl VALUES ('LSG', '이승기', 1987, '서울', '01111111111', 182, '2008-8-8'),
							('KBS', '김범수', 1979, '경남', '01122222222', 173, '2012-4-4'),
							('KKH', '김경호', 1971, '전남', '01133333333', 177, '2007-7-7'),
							('JYP', '조용필', 1950, '경기', '01144444444', 166, '2009-4-4'),
							('SSK', '성시경', 1979, '서울', null, 186, '2013-12-12'),
							('LJB', '임재범', 1963, '서울', '01166666666', 182, '2009-9-9'),
							('YJS', '윤종신', 1969, '경남', null, 170, '2005-5-5'),
							('EJW', '은지원', 1972, '경북', '01188888888', 174, '2014-3-3'),
							('JKW', '조관우', 1965, '경기', '01199999999', 172, '2010-10-10'),
							('BBK', '바비킴', 1973, '서울', '01100000000', 176, '2013-5-5');

INSERT INTO buyTbl VALUES(null, 'KBS', '운동화', null, 30, 2),
						(null, 'KBS', '노트북', '전자', 1000, 1),
						(null, 'JYP', '모니터', '전자', 200, 1),
						(null, 'BBK', '모니터', '전자', 200, 5),
						(null, 'KBS', '청바지', '의류', 50, 3),
						(null, 'BBK', '메모리', '전자', 80, 10),
						(null, 'SSK', '책', '서적', 15, 5),
						(null, 'EJW', '책', '서적', 15, 2),
						(null, 'EJW', '청바지', '의류', 50, 1),
						(null, 'BBK', '운동화', NULL, 30, 2),
						(null, 'EJW', '책', '서적', 15, 1),
						(null, 'BBK', '운동화', NULL, 30, 2);

SELECT * FROM userTbl;
SELECT * FROM buyTbl;

SELECT num, prodName FROM buyTbl WHERE groupName = '전자';
SELECT * FROM userTbl WHERE (birthYear > 1970) and (height > 170) and (mDate > '2009-01-01');
-- WHERE 절 뒤에는 무조건 컬럼명이 나와야 함
SELECT * FROM userTbl WHERE birthYear BETWEEN 1970 AND 1980;
SELECT * FROM userTbl WHERE (addr = '경북') OR (addr = '경남') OR (addr = '경기');
-- IN은 or과 같은 의미
SELECT * FROM userTbl WHERE addr IN ('경북', '경남', '경기');
-- %와 _를 사용할 때는 LIKE를 작성해야함
SELECT * FROM userTbl WHERE addr LIKE '경%';
SELECT * FROM userTbl WHERE name LIKE '김__';

SELECT * FROM userTbl;
-- 어떤 컬럼의 데이터 값을 조회할 때는 해당 컬럼내의 데이터여야 함 - 키 = 이름 값(x), 키 = 키 값(ㅇ)
SELECT * FROM userTbl WHERE height >(SELECT height FROM userTbl WHERE name = '김경호');
SELECT height FROM userTbl WHERE name = '김경호';
-- 지역이 경남인 사람(조건)중에 가장 키가 큰 사람(조회)
SELECT * FROM userTbl WHERE height > (SELECT max(height) FROM userTbl WHERE addr = '경남');
SELECT * FROM userTbl WHERE height >= (SELECT height FROM userTbl WHERE addr = '경남');
SELECT height FROM userTbl WHERE addr = '경남'; -- 결과값이 173 과 170 
SELECT * FROM userTbl WHERE height >= ANY (SELECT height FROM userTbl WHERE addr = '경남'); -- 173 이거나 170, 결론은 170 이상
SELECT * FROM userTbl WHERE height >= ALL (SELECT height FROM userTbl WHERE addr = '경남'); -- 173 이면서 170, 결론은 173 이
-- 정렬은 ORDER BY
SELECT * FROM userTbl ORDER BY birthYear ASC;
SELECT * FROM userTbl ORDER BY birthYear ASC, userId DESC;
SELECT DISTINCT addr FROM userTbl;

USE sqlDB;
SELECT * FROM userTbl ORDER BY birthYear ASC LIMIT 3;
SELECT * FROM userTbl WHERE height > 170 ORDER BY height ASC LIMIT 3;
SELECT * FROM userTbl WHERE mDate > '2009-01-01' ORDER BY mDate ASC LIMIT 2, 3;
USE sqlDB;
-- 각 인물별로 구매한 개수의 총합 구하기(~별로: GROUP BY로 묶어주기)
SELECT userId, sum(amount) FROM buyTbl GROUP BY userId;
SELECT userId, avg(price) FROM buyTbl GROUP BY userId;
SELECT userId, sum(price * amount) FROM buyTbl GROUP BY userId;
SELECT groupName, sum(price * amount) FROM buyTbl GROUP BY groupName;
SELECT * FROM buyTbl;
SELECT groupName, MIN(price) FROM buyTbl;
SELECT name, height FROM userTbl WHERE height = (SELECT MAX(height) FROM userTbl);
SELECT name, height FROM userTbl WHERE height = (SELECT MIN(height) FROM userTbl);
SELECT DISTINCT groupName FROM buyTbl;
SELECT AVG(height) FROM userTbl;
SELECT userId, sum(price * amount) FROM buyTbl GROUP BY userId HAVING SUM(price * amount) > 1000;
SELECT name, height, addr FROM userTbl;
