DROP TABLE E1;
DROP TABLE E2;
DROP TABLE VALC;

CREATE TABLE E1(
	K1 VARCHAR(255) NOT NULL PRIMARY KEY,
	A INT NOT NULL);
	
CREATE TABLE E2(
	K2 VARCHAR(255) NOT NULL PRIMARY KEY,
	B INT NOT NULL,
	E1R1 VARCHAR(255) REFERENCES E1(K1));
	
CREATE TABLE VALC(
	K1 VARCHAR(255) NOT NULL REFERENCES E1,
	K2 VARCHAR(255) NOT NULL REFERENCES E2,
	C INT);

CREATE OR REPLACE TRIGGER UniqueE1E2
BEFORE INSERT ON E2
REFERENCING NEW AS N
FOR EACH ROW
WHEN (EXISTS(SELECT *
			 FROM E2
			 WHERE N.E1R1 = E2.E1R1))
SIGNAL SQLSTATE '70000' ('E'' già presente una relationship tra questi due valori');

INSERT INTO E1 (K1, A) VALUES 
('Puppa', 12),
('Ciao', 10),
('Fede', 1),
('Andri', 2);

INSERT INTO E2 (K2, B, E1R1) VALUES 
('alfa', 1, 'Fede'),
('gamma', 3, 'Andri'),
('delta', 4, 'Puppa'),
('epsilon', 5, NULL);

INSERT INTO VALC (K1, K2, C) VALUES 
('Fede', 'alfa', 2),
('Fede', 'alfa', 3),
('Andri', 'gamma', 10);

INSERT INTO E2 (K2, B, E1R1) VALUES ('beta', 2, 'Fede'); --ERRORE