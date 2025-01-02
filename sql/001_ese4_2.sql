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
	
INSERT INTO E1 (K1, A) VALUES 
('ciao', 10),
('hello', 20),
('hola', 30); -- Caso con valore NULL per il campo non chiave

INSERT INTO E2 (K2, B, E1R1) VALUES 
('key1', 100, 'ciao'),       -- Associato a E1 con K1 = 'ciao'
('key2', 200, 'hello'),      -- Associato a E1 con K1 = 'hello'
('key3', 300, NULL);        -- Entrambi i valori B ed E1R1 sono NULL

INSERT INTO VALC (K1, K2, C) VALUES 
('ciao', 'key1', 1),         -- Associazione tra E1(K1 = 'ciao') e E2(K2 = 'key1') con valore C = 1
('ciao', 'key1', NULL),      -- C è NULL, ma l'associazione è valida
('hello', 'key2', 5),        -- Associazione tra E1(K1 = 'hello') e E2(K2 = 'key2') con valore C = 5
('hola', 'key3', 10);          -- K2 è NULL, associazione parzialmente mancante

