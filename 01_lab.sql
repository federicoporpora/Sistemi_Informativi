DROP TABLE A1114450.UTENTI

DROP TABLE A1114450.LIBRI

DROP TABLE A1114450.PRESTITI

CREATE TABLE UTENTI(
	Tessera integer NOT NULL PRIMARY KEY,
	Nome varchar(50) NOT NULL,
	Cognome varchar(50) NOT NULL,
	Telefono varchar(13) NOT NULL
)

CREATE TABLE LIBRI(
	Codice integer NOT NULL PRIMARY KEY,
	Titolo varchar(50) NOT NULL,
	Autori varchar(50) NOT NULL DEFAULT 'Anonimo',
	Note varchar(300)
)

CREATE TABLE PRESTITI(
	CodiceLibro integer NOT NULL REFERENCES LIBRI(Codice) ON DELETE CASCADE,
	Tessera integer NOT NULL REFERENCES UTENTI(Tessera) ON DELETE CASCADE,
	Data_Out date NOT NULL,
	Data_In date,
	PRIMARY KEY(CodiceLibro, Tessera, Data_Out),
	CHECK (Data_In >= Data_Out)
)

-- es i1 / i2
-- Inserimento di Utenti
INSERT INTO UTENTI (tessera, nome, cognome, telefono) VALUES
	(1, 'Mario', 'Rossi', '1234567890'),
	(2, 'Luisa', 'Verdi', '0987654321'),
	(3, 'Giovanni', 'Bianchi', '2345678901'),
	(4, 'Anna', 'Neri', '3456789012')

-- Inserimento di Libri
INSERT INTO LIBRI (codice, titolo, autori, note) VALUES
	(101, 'Il Signore degli Anelli', 'J.R.R. Tolkien', 'Libro orrendo'),
	(102, '1984', 'George Orwell', 'Romanzo distopico'),
	(103, 'Il Nome della Rosa', 'Umberto Eco', 'Un grande classico'),
	(104, 'Fahrenheit 451', 'Ray Bradbury', 'Una critica alla censura'),
	(105, 'Viaggio al Centro della Terra', DEFAULT, 'Non lo consiglio')

-- Inserimento di Prestiti
INSERT INTO PRESTITI (codicelibro, tessera, data_out, data_in) VALUES
	(101, 1, '2023-10-01', '2023-10-11'), -- Prestito completato ottobre 2023
	(102, 2, '2023-09-25', '2024-09-30'), -- Prestito completato anno dopo
	(103, 3, '2024-10-05', NULL), -- Prestito attivo
	(104, 4, '2024-10-03', '2024-10-05'), -- Prestito completato
	(103, 1, '2023-11-01', '2023-11-11'), -- Prestito completato novembre 2023
	(105, 2, '2024-10-07', NULL) -- Prestito di libro senza autori

-- u1
UPDATE UTENTI SET Telefono = '52525252' WHERE Cognome = 'Rossi'

-- u2
UPDATE LIBRI SET Note = 'Libro orrendo' WHERE Codice = 101

-- u3
UPDATE Prestiti SET DATA_OUT = '2023-10-10' WHERE CODICELIBRO = 101 AND tessera = 1

-- d1
DELETE FROM UTENTI WHERE Cognome = 'Rossi'

-- d2
DELETE FROM LIBRI WHERE codice = 101

-- q1
SELECT Titolo
FROM LIBRI
WHERE Autori = 'Umberto Eco' AND Titolo LIKE '%Nome%'

-- q2
SELECT Cognome
FROM UTENTI
WHERE Cognome = 'Rossi'

-- q3
SELECT *
FROM PRESTITI
WHERE YEAR(DATA_OUT) = 2023

-- q4
SELECT *
FROM PRESTITI
WHERE YEAR(DATA_OUT) < YEAR(DATA_IN)

-- q5
SELECT codicelibro
FROM PRESTITI, UTENTI
WHERE PRESTITI.TESSERA = UTENTI.TESSERA AND nome = 'Mario' AND cognome = 'Rossi' AND Telefono = '1234567890'

-- q6
SELECT codicelibro
FROM PRESTITI, UTENTI
WHERE PRESTITI.TESSERA = UTENTI.TESSERA AND nome = 'Mario' AND cognome = 'Rossi' AND Telefono = '1234567890' AND DATA_OUT >= '2023-11-01' AND DATA_OUT < '2023-12-01'

-- q7
SELECT *
FROM PRESTITI p, UTENTI u
WHERE p.TESSERA = u.TESSERA AND u.nome = 'Mario' AND u.cognome = 'Rossi' AND u.Telefono = '1234567890' AND p.DATA_OUT >= '2023-11-01' AND p.DATA_OUT < '2023-12-01'

-- q8
SELECT p.TESSERA, u.NOME, u.COGNOME
FROM PRESTITI p, UTENTI u
WHERE p.TESSERA = u.TESSERA AND DATA_OUT >= '2023-01-01' AND DATA_OUT < '2024-01-01'
EXCEPT ALL
SELECT DISTINCT u.TESSERA, u.NOME, u.COGNOME
FROM UTENTI u, PRESTITI p
WHERE u.TESSERA = p.TESSERA

-- q9
SELECT p.tessera, u.nome, u.cognome
FROM PRESTITI p, UTENTI u
WHERE p.TESSERA = u.TESSERA
EXCEPT
SELECT p2.TESSERA, u2.NOME, u2.COGNOME
FROM PRESTITI p2, UTENTI u2
WHERE p2.TESSERA = u2.TESSERA AND DATA_OUT >= '2023-01-01' AND DATA_OUT < '2024-01-01'

-- q10
SELECT p.TESSERA, u.NOME, u.COGNOME
FROM PRESTITI p, UTENTI u, LIBRI l
WHERE p.TESSERA = u.TESSERA AND p.CODICELIBRO = l.CODICE
EXCEPT ALL
SELECT p2.tessera, u2.nome, u2.cognome
FROM PRESTITI p2, UTENTI u2, LIBRI l2
WHERE p2.tessera = u2.tessera AND p2.codicelibro = l2.CODICE AND NOT l2.AUTORI = 'Anonimo'