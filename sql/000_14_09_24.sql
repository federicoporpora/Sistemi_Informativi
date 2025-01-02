-- ES 1 E 2
DROP TABLE REPARTI;
DROP TABLE DIPENDENTI;
DROP TABLE PROGETTI;
CREATE TABLE REPARTI(
	CodRep INT NOT NULL PRIMARY KEY,
	Nome VARCHAR(255) NOT NULL,
	Direttore VARCHAR(255) NOT NULL
);
CREATE TABLE DIPENDENTI(
	DID VARCHAR(255) NOT NULL PRIMARY KEY,
	Nome VARCHAR(255) NOT NULL,
	Stipendio DEC(8, 2) NOT NULL,
	CodRep INT NOT NULL REFERENCES REPARTI(CodRep)
);
ALTER TABLE REPARTI
ADD CONSTRAINT FK_REPARTI_DIRETTORE FOREIGN KEY (Direttore) REFERENCES DIPENDENTI(DID);
CREATE TABLE PROGETTI(
	CodProg INT NOT NULL PRIMARY KEY,
	Titolo VARCHAR(255) NOT NULL,
	Budget DEC(8, 2) NOT NULL,
	Responsabile VARCHAR(255) NOT NULL REFERENCES DIPENDENTI(DID)
);



INSERT INTO REPARTI (CodRep, Nome, Direttore) VALUES 
(1, 'Informatica', 'D001'),
(2, 'Amministrazione', 'D002'),
(3, 'Marketing', 'D003'),
(4, 'Ricerca e Sviluppo', 'D004');

INSERT INTO DIPENDENTI (DID, Nome, Stipendio, CodRep) VALUES 
-- Reparto Informatica
('D001', 'Mario Rossi', 6000.00, 1), -- Direttore
('D005', 'Sara Bianchi', 2000.00, 1), -- Non responsabile
('D006', 'Luca Verdi', 2500.00, 1), -- Responsabile
-- Reparto Amministrazione
('D002', 'Giulia Neri', 5500.00, 2), -- Direttore
('D007', 'Paolo Gialli', 2200.00, 2), -- Non responsabile
('D008', 'Laura Blu', 2800.00, 2), -- Responsabile
-- Reparto Marketing
('D003', 'Luca Viola', 2000.00, 3), -- Direttore
('D009', 'Chiara Rosa', 1900.00, 3), -- Non responsabile
('D010', 'Marco Giallo', 3100.00, 3), -- Responsabile
-- Reparto Ricerca e Sviluppo
('D004', 'Anna Grigi', 5800.00, 4), -- Direttore
('D011', 'Elena Verde', 2600.00, 4), -- Non responsabile
('D012', 'Fabio Marrone', 2700.00, 4); -- Responsabile

INSERT INTO PROGETTI (CodProg, Titolo, Budget, Responsabile) VALUES 
-- Progetti reparto Informatica (Budget totale: 650000)
(101, 'Sviluppo Web', 300000.00, 'D006'),
(102, 'Sicurezza Informatica', 350000.00, 'D006'),
-- Progetti reparto Amministrazione (Budget totale: 450000)
(103, 'Ottimizzazione Costi', 200000.00, 'D008'),
(104, 'Digitalizzazione Documenti', 250000.00, 'D008'),
-- Progetti reparto Marketing (Budget totale: 520000)
(105, 'Campagna Pubblicitaria A', 200000.00, 'D010'),
(106, 'Campagna Pubblicitaria B', 320000.00, 'D010'),
-- Progetti reparto Ricerca e Sviluppo (Budget totale: 480000)
(107, 'Prototipo Innovativo', 280000.00, 'D012'),
(108, 'Analisi di Mercato', 200000.00, 'D012');



-- 2.1
SELECT d.CODREP, SUM(p.BUDGET), COUNT(*)
FROM PROGETTI p, DIPENDENTI d, REPARTI r
WHERE p.RESPONSABILE = d.DID AND d.CODREP = r.CODREP
GROUP BY d.CODREP
HAVING SUM(p.BUDGET) > 500000.00

-- 2.2
WITH DipendentiNonResponsabili(DIPENDENTE) AS (SELECT d.DID
											   FROM DIPENDENTI d
											   EXCEPT ALL
											   SELECT p.RESPONSABILE
											   FROM PROGETTI p)
SELECT COUNT(*)
FROM (SELECT d.CODREP
	  FROM DipendentiNonResponsabili dnr, DIPENDENTI d
	  WHERE d.DID = dnr.DIPENDENTE
	  GROUP BY d.CODREP
	  HAVING AVG(d.STIPENDIO) > 2400) AS subquery

	  
	  
	  
-- ES 3
DROP TABLE MANAGER;
DROP TABLE PROGETTI;
CREATE TABLE MANAGER(
	CodRic VARCHAR(255) NOT NULL PRIMARY KEY,
	Stipendio DEC(8, 2) NOT NULL
);
CREATE TABLE PROGETTI(
	CodProg VARCHAR(255) NOT NULL PRIMARY KEY,
	Titolo VARCHAR(255) NOT NULL,
	Budget VARCHAR(255) NOT NULL,
	CodRic VARCHAR(255) NOT NULL REFERENCES MANAGER
);

INSERT INTO MANAGER VALUES
('M0001', 10000),
('M0002', 20000),
('M0003', 30000);

INSERT INTO PROGETTI VALUES ('P0001', 'Progetto1', 250000, 'M0001');

CREATE OR REPLACE TRIGGER AssegnamentoManager
BEFORE INSERT ON PROGETTI
REFERENCING NEW AS N
FOR EACH ROW 
WHEN (EXISTS (SELECT p.CodRic
			  FROM PROGETTI p
			  WHERE p.CodRic = N.CodRic)
	  OR (0.1 * N.Budget) < (SELECT m.Stipendio
	  						 FROM MANAGER m
	  						 WHERE N.CodRic = m.CodRic))
SIGNAL SQLSTATE '70001' ('Manager già responsabile o supera il budget del progetto');



-- ES 4 (non finito)
CREATE TABLE E1(
	K1 VARCHAR(255) NOT NULL PRIMARY KEY,
	A VARCHAR(255) NOT NULL,
	E2 VARCHAR(255),
	E2_B VARCHAR(255),
	K3_R1 VARCHAR(255) REFERENCES E3(K3),
	R1_D VARCHAR(255),
	CHECK ((E2 IS NULL AND E2_B IS NULL) OR (E2 IS NOT NULL AND E2_B IS NOT NULL))
);
CREATE TABLE E3(
	K3 VARCHAR(255) NOT NULL PRIMARY KEY,
	C VARCHAR(255) NOT NULL
);