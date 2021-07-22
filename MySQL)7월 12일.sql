/* 실행은 ctrl + enter
데이터베이스 생성 명령
데이터베이스 생성 시 한글을 사용할 수 있도록 - DEFAULT CHARACTER SET UTF8; */
CREATE DATABASE ict03 DEFAULT CHARACTER SET UTF8;

/* 좌측 하단 Schrmas 클릭해서 새로고침하고 ict03 우클릭
- Set As Default Schemas 클릭/ 더블클릭하면 현재 명령을 받을 데이터베이스로 지정되고 볼드처리 */
/* DB 사용자 계쩡 생성 USER - id, IDENTIFIED BY - password */
CREATE USER 'ict03' IDENTIFIED BY 'ict03';

/* 사용자에게 권한 부여 GRANT 주고 싶은 기능1, 기능2, ...
만약 모든 권한을 부여한다면 ALL PRIVILEGE(관리자의 모든 권한) TO 권한을 부여할 계정 */
GRANT ALL PRIVILEGES ON ict03.* TO 'ict';

/* 테이블 생성 명령
PRIMARY KEY: 컬럼의 주요키를 뜻하며, 중복 데이터 방지 - 하나의 컬럼은 반드시 PRIMARY KEY 속성을 가져야 함
NOT NULL: 데이터에 NULL 값이 들어오는 것을 방지
UNIQUE: 중복 데이터가 들어오는 것을 방지 */

CREATE TABLE users(
	uid varchar(20) PRIMARY KEY,
    upw varchar(20) NOT NULL,
    uname varchar(30) NOT NULL,
    email varchar(80)
);

/* SELECT 뒤의 조회 순서를 다르게 해서 입력하면
순서를 변경하여 출력하는 것도 가능 */
SELECT email, upw, uid FROM users;
SELECT * FROM users;

/* 데이터 적재 
INSERT INTO 테이블명 (컬럼1, 컬럼2, ...) VALUES (컬럼1, 컬럼2, ...)
만약 모든 컬럼이 전부 입력 대상인 경우 테이블명과 VALUES 사이는 생략 가능 */
INSERT INTO users VALUES ('abc1234', '1234', '가나다', NULL);

SELECT * FROM users;

/* Workbench 상에서 데이터를 입력할 때에는
마지막에 반드시 COMMIT; 이라고 한번 더 확인 작업을 해야 데이터가 최종적으 저장됨 */
COMMIT;