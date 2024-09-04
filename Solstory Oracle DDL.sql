------------ 임시 HISTORY TABLE : 은행 거래 계좌 내역을 조작할 수 없으니 관련 데이터 테이블을 만듦-----------------------------------
DROP TABLE transactions CASCADE CONSTRAINTS;
DROP SEQUENCE transaction_seq;

CREATE TABLE transactions (
	transaction_no	NUMBER(10) NOT NULL, 
	account_no	VARCHAR2(35) NOT NULL,
	transaction_date DATE NOT NULL,
	transaction_unique_no NUMBER(10) NOT NULL,
	transaction_type NUMBER(1) NOT NULL, -- 1: 입금, 2: 출금
	transaction_balance NUMBER(15) NOT NULL,
	transaction_summary VARCHAR2(225) NOT NULL, -- 지출처
	CONSTRAINT PK_TRANSACTIONS PRIMARY KEY (transaction_no)
);

CREATE SEQUENCE transaction_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;


---------------------------------------------------
DROP TABLE challenge_rewards CASCADE CONSTRAINTS;
DROP TABLE user_challenges CASCADE CONSTRAINTS;
DROP TABLE challenges CASCADE CONSTRAINTS;
DROP TABLE daily_financial_summary CASCADE CONSTRAINTS;
DROP TABLE interests CASCADE CONSTRAINTS;
DROP TABLE hobbies CASCADE CONSTRAINTS;
DROP TABLE user_accounts CASCADE CONSTRAINTS;
DROP TABLE users CASCADE CONSTRAINTS;

DROP SEQUENCE user_seq;
DROP SEQUENCE hobby_seq;
DROP SEQUENCE interest_seq;
DROP SEQUENCE summary_seq;
DROP SEQUENCE challenge_seq;
DROP SEQUENCE reward_seq;
DROP SEQUENCE user_challenge_seq;

CREATE TABLE users (
	user_no	NUMBER(10) NOT NULL,
	user_id	VARCHAR2(50) NOT NULL,
	password VARCHAR2(64) NOT NULL,
	user_name VARCHAR2(100)	NOT NULL,
	email VARCHAR2(254) NOT NULL,
	gender	VARCHAR2(10) NOT NULL,
	birth DATE NOT NULL,
	join_date DATE DEFAULT SYSDATE NOT NULL,
	user_key VARCHAR2(125) NULL, 
	mbti VARCHAR2(15) NULL,
	CONSTRAINT PK_USERS PRIMARY KEY (user_no)
);

CREATE TABLE hobbies (
	hobby_no NUMBER(10) NOT NULL,
	user_no NUMBER(10) NOT NULL,
	hobby_cate VARCHAR2(50) NOT NULL,
 	CONSTRAINT PK_hobbies PRIMARY KEY (hobby_no)
);

CREATE TABLE interests (
	interest_no NUMBER(10) NOT NULL,
	user_no NUMBER(10) NOT NULL,
	interest_cate VARCHAR2(50) NOT NULL,
 	CONSTRAINT PK_interests PRIMARY KEY (interest_no)
);

CREATE TABLE user_accounts (
	account_no VARCHAR2(34)	 NOT NULL,
	user_no	NUMBER(10) NOT NULL,
	account_type NUMBER(1) NOT NULL,
	account_name VARCHAR2(100) NOT NULL,
	target_amount NUMBER(10) NULL,
	reg_date DATE DEFAULT SYSDATE NOT NULL,
	end_date DATE NULL, 
	is_active	NUMBER(1) DEFAULT 1 NOT NULL,
	CONSTRAINT PK_USER_ACCOUNTS PRIMARY KEY (account_no)
);

CREATE TABLE daily_financial_summary (
	summary_no NUMBER(10) NOT NULL,
	user_no	NUMBER(10) NOT NULL,
	financial_date DATE NOT NULL,
	financial_type NUMBER(1) NOT NULL,
	category VARCHAR2(50) NULL,
	total_amount NUMBER(15) DEFAULT 0 NOT NULL,
	CONSTRAINT PK_DAILY_FINANCIAL_SUMMARY PRIMARY KEY (summary_no)
);

CREATE TABLE challenges (
	challenge_no NUMBER(10) NOT NULL,
	challenge_type NUMBER(1) NOT NULL,
	category VARCHAR2(50) NOT NULL,
	days NUMBER(2) NOT NULL,
	challenge_name VARCHAR2(255) NOT NULL,
	reward_keys NUMBER(5) NOT NULL,
	target_amount NUMBER(5) NOT NULL,
	CONSTRAINT PK_CHALLENGES PRIMARY KEY (challenge_no)
);

CREATE TABLE user_challenges (
	assignment_no NUMBER(10)	 NOT NULL,
	user_no	NUMBER(10) NOT NULL,
	challenge_no NUMBER(10) NOT NULL,
	assigned_date DATE DEFAULT SYSDATE NOT NULL,
	complete_date DATE NOT NULL,
	CONSTRAINT PK_USER_CHALLENGES PRIMARY KEY (assignment_no)
);

CREATE TABLE challenge_rewards (
	reward_no NUMBER(10) NOT NULL,
	user_no	NUMBER(10) NOT NULL,
	keys NUMBER(5) DEFAULT 0 NOT NULL,
	CONSTRAINT PK_CHALLENGE_REWARDS PRIMARY KEY (reward_no)
);


COMMENT ON COLUMN users.user_no IS '사용자 일련번호';
COMMENT ON COLUMN users.user_id IS '사용자 ID';
COMMENT ON COLUMN users.password IS '사용자 비밀번호';
COMMENT ON COLUMN users.user_name IS '사용자 이름';
COMMENT ON COLUMN users.email IS '사용자 이메일';
COMMENT ON COLUMN users.gender IS '사용자 성별(MALE/FEMALE)';
COMMENT ON COLUMN users.birth IS '사용자 생년월일';
COMMENT ON COLUMN users.join_date IS '사용자 가입일자';
COMMENT ON COLUMN users.mbti IS '사용자 MBTI';

COMMENT ON COLUMN hobbies.hobby_no IS '사용자 취미 일련번호';
COMMENT ON COLUMN hobbies.user_no IS '사용자 일련번호';
COMMENT ON COLUMN hobbies.hobby_cate IS '사용자 취미';

COMMENT ON COLUMN interests.interest_no IS '사용자 관심사 일련번호';
COMMENT ON COLUMN interests.user_no IS '사용자 일련번호';
COMMENT ON COLUMN interests.interest_cate IS '사용자 관심사';

COMMENT ON COLUMN user_accounts.account_no IS '저축 계좌번호';
COMMENT ON COLUMN user_accounts.user_no IS '사용자 일련번호';
COMMENT ON COLUMN user_accounts.account_type IS '계좌 유형(1: 저축 예적금 계좌, 2: 주거래 입출금 계좌)';
COMMENT ON COLUMN user_accounts.account_name IS '사용자 지정 목표(계좌 연동시 계좌 이름 설정)';
COMMENT ON COLUMN user_accounts.target_amount IS '저축 목표 금액(적금 최종 금액)';
COMMENT ON COLUMN user_accounts.reg_date IS '시작일자 (계좌 연동 날짜)';
COMMENT ON COLUMN user_accounts.end_date IS '종료일자';
COMMENT ON COLUMN user_accounts.is_active IS '계좌 상태(0: 비활성화, 1:활성화)';

COMMENT ON COLUMN daily_financial_summary.summary_no IS 'summary 일련번호';
COMMENT ON COLUMN daily_financial_summary.user_no IS '사용자 일련번호';
COMMENT ON COLUMN daily_financial_summary.financial_date IS '저축/소비 해당 날짜';
COMMENT ON COLUMN daily_financial_summary.financial_type IS '산출 유형(1: 저축 , 2:소비)';
COMMENT ON COLUMN daily_financial_summary.category IS '지출 카테고리';
COMMENT ON COLUMN daily_financial_summary.total_amount IS '총액(저축/지출 카테고리별)';

COMMENT ON COLUMN challenges.challenge_no IS '챌린지 일련번호';
COMMENT ON COLUMN challenges.challenge_type IS '챌린지 유형(1:저축 , 2:지출)';
COMMENT ON COLUMN challenges.category IS '챌린지 카테고리(지출 카테고리 등)';
COMMENT ON COLUMN challenges.days IS '챌린지 미션 수행 기간(한달:30, 일주일:7, 하루:1)';
COMMENT ON COLUMN challenges.challenge_name IS '챌린지 이름';
COMMENT ON COLUMN challenges.reward_keys IS '챌린지 과제 완료 시 획득할 열쇠 개수';

COMMENT ON COLUMN user_challenges.assignment_no IS '제시된 도전과제 일련번호';
COMMENT ON COLUMN user_challenges.user_no IS '사용자 일련번호';
COMMENT ON COLUMN user_challenges.challenge_no IS '도전과제 일련번호';
COMMENT ON COLUMN user_challenges.assigned_date IS '도전과제가 사용자에게 할당된 날짜';
COMMENT ON COLUMN user_challenges.complete_date IS '도전과제 완료일자';

COMMENT ON COLUMN challenge_rewards.reward_no IS '사용자 리워드 일련번호';
COMMENT ON COLUMN challenge_rewards.user_no IS '사용자 일련번호';
COMMENT ON COLUMN challenge_rewards.keys IS '사용자가 보유한 열쇠 수';


ALTER TABLE hobbies ADD CONSTRAINT FK_hobbies_users FOREIGN KEY (user_no) REFERENCES users (user_no);
ALTER TABLE interests ADD CONSTRAINT FK_interests_users FOREIGN KEY (user_no) REFERENCES users (user_no);
ALTER TABLE user_accounts ADD CONSTRAINT FK_user_accounts_users FOREIGN KEY (user_no) REFERENCES users (user_no);
ALTER TABLE daily_financial_summary ADD CONSTRAINT FK_summary_users FOREIGN KEY (user_no) REFERENCES users (user_no);
ALTER TABLE user_challenges ADD CONSTRAINT FK_user_challenges_users FOREIGN KEY (user_no) REFERENCES users (user_no);
ALTER TABLE user_challenges ADD CONSTRAINT FK_user_challenges_challenges FOREIGN KEY (challenge_no) REFERENCES challenges (challenge_no);
ALTER TABLE challenge_rewards ADD CONSTRAINT FK_challenge_rewards_users FOREIGN KEY (user_no) REFERENCES users (user_no);



CREATE SEQUENCE user_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE hobby_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE interest_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE summary_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE challenge_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE reward_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE SEQUENCE user_challenge_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;
