-- drop tables first just in case
DROP TABLE PLAYSIN;
DROP TABLE BESTGOLFERS;
DROP TABLE PGAGOLFER;
DROP TABLE TOURNAMENT;

-- Create tables for pga golfers, european golfers, and tournaments

CREATE TABLE PGAGOLFER (LNAME VARCHAR(25) NOT NULL, FNAME VARCHAR(20) NOT NULL,
			HANDICAP INTEGER,
			PRIMARY KEY (LNAME, FNAME));
CREATE TABLE BESTGOLFERS (FIRSTNAME VARCHAR(25) NOT NULL, LASTNAME VARCHAR(20) NOT NULL,
			  PRIZE_MONEY INTEGER, PRIMARY KEY (LASTNAME, FIRSTNAME));
CREATE TABLE TOURNAMENT (NAME VARCHAR(20) NOT NULL, LOCATION VARCHAR(50),
			 PURSE INTEGER, PRIMARY KEY (NAME, LOCATION));

-- JOIN table
CREATE TABLE PLAYSIN (LNAME VARCHAR(25) NOT NULL, FNAME VARCHAR(20) NOT NULL,
			 NAME VARCHAR(20) NOT NULL, LOCATION VARCHAR(50) NOT NULL,
			 PLACE INTEGER NOT NULL, MONEY INTEGER NOT NULL,
			 PRIMARY KEY (LNAME, FNAME, NAME, LOCATION),
			 FOREIGN KEY (LNAME, FNAME) REFERENCES PGAGOLFER(LNAME, FNAME),
			 FOREIGN KEY (NAME, LOCATION) REFERENCES TOURNAMENT(NAME, LOCATION));

-- Populate the tables (except BestGolfers)
INSERT INTO PGAGOLFER VALUES ('Woods', 'Tiger', -9);
INSERT INTO PGAGOLFER VALUES ('Mickelson', 'Phil', -3);
INSERT INTO PGAGOLFER VALUES ('Price', 'Nick');
INSERT INTO PGAGOLFER VALUES ('Singh', 'Vijay', -5);
INSERT INTO PGAGOLFER VALUES ('Nicklaus', 'Jack', -7);
INSERT INTO PGAGOLFER VALUES ('Mayfair', 'Billy', 1);
INSERT INTO PGAGOLFER VALUES ('Johanssen', 'Per', 3);

-- Populate using a different variation of the attributes
INSERT INTO PGAGOLFER(FNAME, LNAME) VALUES ('Ben', 'Crenshaw');
INSERT INTO PGAGOLFER(FNAME, LNAME, HANDICAP) VALUES ('Sergio', 'Garcia', -2);
INSERT INTO PGAGOLFER(FNAME, LNAME) VALUES ('David', 'Duval');

-- Populate the tournament and playsin tables
INSERT INTO TOURNAMENT VALUES ('Masters', 'Augusta GA', 500000);
INSERT INTO TOURNAMENT VALUES ('US Open', 'Pebble Beach', 625000);

INSERT INTO PLAYSIN VALUES ('Woods', 'Tiger', 'Masters', 'Augusta GA', 1, 300000);
INSERT INTO PLAYSIN VALUES ('Mickelson', 'Phil', 'Masters', 'Augusta GA', 2, 100000);
INSERT INTO PLAYSIN VALUES ('Price', 'Nick', 'Masters', 'Augusta GA', 3, 60000);
INSERT INTO PLAYSIN VALUES ('Singh', 'Vijay', 'Masters', 'Augusta GA', 4, 40000);
INSERT INTO PLAYSIN VALUES ('Price', 'Nick', 'US Open', 'Pebble Beach', 3, 100000);
INSERT INTO PLAYSIN VALUES ('Nicklaus', 'Jack', 'US Open', 'Pebble Beach', 4, 50000);
INSERT INTO PLAYSIN VALUES ('Woods', 'Tiger', 'US Open', 'Pebble Beach', 1, 300000);
INSERT INTO PLAYSIN VALUES ('Mickelson', 'Phil', 'US Open', 'Pebble Beach', 2, 150000);
INSERT INTO PLAYSIN VALUES ('Mayfair', 'Billy', 'US Open', 'Pebble Beach', 5, 25000);

-- insert into BestGolfers the set of PGAGolfers that earned more than 200000
INSERT INTO BESTGOLFERS(LASTNAME, FIRSTNAME, PRIZE_MONEY)
	SELECT PGAGOLFER.LNAME, PGAGOLFER.FNAME, SUM(MONEY) FROM PGAGOLFER, PLAYSIN WHERE 
	PGAGOLFER.LNAME=PLAYSIN.LNAME AND PGAGOLFER.FNAME=PLAYSIN.FNAME 
	GROUP BY PGAGOLFER.LNAME, PGAGOLFER.FNAME HAVING SUM(MONEY) > 200000;

-- update the prize money for each golfer
-- UPDATE PLAYSIN SET MONEY=MONEY*1.1 WHERE PLACE=1;

commit;
