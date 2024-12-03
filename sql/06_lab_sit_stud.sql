-- *********************************************
-- * Standard SQL generation                   
-- *--------------------------------------------
-- * DB-MAIN version: 11.0.2              
-- * Generator date: Sep 14 2021              
-- * Generation date: Wed Nov 13 15:13:23 2024 
-- * LUN file: C:\Users\s0001114450\Desktop\lab_06.lun 
-- * Schema: ES_3/SQL 
-- ********************************************* 


-- Tables Section

DROP TABLE AUTO_LAB6;
DROP TABLE RIVENDITORI_LAB6;
DROP TABLE MODELLI_LAB6;
DROP TABLE CONOSCIUTO_LAB6;
DROP TABLE VENDITE_LAB6;
DROP VIEW VENDITE_VIEW_LAB6;

create table AUTO_LAB6 (
     Targa char(7) not null,
     Anno integer not null,
     Km integer not null,
     Cilindrata integer not null,
     PrezzoRich dec(10, 2) not null,
     Marca varchar(10) not null,
     Modello varchar(20) not null,
     constraint ID_AUTO_ID primary key (Targa));

create table RIVENDITORI_LAB6 (
     Nome varchar(20) not null,
     Cognome varchar(20) not null,
     constraint ID_RIVENDITORI_ID primary key (Nome, Cognome));

create table MODELLI_LAB6 (
     Marca varchar(10) not null,
     Modello varchar(20) not null,
     constraint ID_MODELLI_ID primary key (Marca, Modello));

create table Conosciuto_LAB6 (
     Marca varchar(10) not null,
     Modello varchar(20) not null,
     Nome varchar(20) not null,
     Cognome varchar(20) not null,
     constraint ID_Conosciuto_ID primary key (Nome, Cognome, Marca, Modello));

create table VENDITE_LAB6 (
     Targa char(7) not null,
     PrezzoVend dec(10, 2) not null,
     Nome varchar(20) not null,
     Cognome varchar(20) not null,
     constraint FKVEN_AUT_ID primary key (Targa));


-- Constraints Section

alter table AUTO_LAB6 add constraint FKR_FK
     foreign key (Marca, Modello)
     references MODELLI_LAB6;

alter table Conosciuto_LAB6 add constraint FKCon_RIV
     foreign key (Nome, Cognome)
     references RIVENDITORI_LAB6;

alter table Conosciuto_LAB6 add constraint FKCon_MOD_FK
     foreign key (Marca, Modello)
     references MODELLI_LAB6;

alter table VENDITE_LAB6 add constraint FKVEN_RIV_FK
     foreign key (Nome, Cognome)
     references RIVENDITORI_LAB6;

alter table VENDITE_LAB6 add constraint FKVEN_AUT_FK
     foreign key (Targa)
     references AUTO_LAB6;


-- Inserts section

INSERT INTO MODELLI_LAB6 (Marca, Modello)
VALUES ('Toyota', 'Corolla'),
       ('Fiat', 'Punto'),
       ('Ford', 'Fiesta'),
       ('Fiat', 'Multipla'),
       ('BMW', 'Serie 3'),
       ('Audi', 'A4'),
       ('Mercedes', 'Classe C'),
       ('Volkswagen', 'Golf'),
       ('Renault', 'Clio'),
       ('Honda', 'Civic');
INSERT INTO RIVENDITORI_LAB6 (Nome, Cognome)
VALUES ('Mario', 'Rossi'),
       ('Luigi', 'Bianchi'),
       ('Anna', 'Verdi'),
       ('Federico', 'Porpora'),
       ('Tommaso', 'Portolani'),
       ('Matteo', 'Gattobigio'),
       ('Sara', 'Longhi'),
       ('Alessandro', 'Grassi'),
       ('Giulia', 'Neri');
INSERT INTO AUTO_LAB6 (Targa, Anno, Km, Cilindrata, PrezzoRich, Marca, Modello)
VALUES ('AB123CD', 2015, 50000, 1600, 12000.00, 'Toyota', 'Corolla'),
       ('EF456GH', 2018, 30000, 1200, 9000.00, 'Fiat', 'Punto'),
       ('IJ789KL', 2020, 20000, 1000, 15000.00, 'Ford', 'Fiesta'),
       ('LM123NO', 2021, 10000, 1400, 50000.00, 'Fiat', 'Multipla'),
       ('PQ456RS', 2019, 40000, 2000, 18000.00, 'BMW', 'Serie 3'),
       ('ZX123YW', 2020, 30000, 2000, 19000.00, 'BMW', 'Serie 3'),
       ('TU789VW', 2017, 45000, 1800, 22000.00, 'Audi', 'A4'),
       ('GH567JK', 2019, 35000, 1800, 23000.00, 'Audi', 'A4'),
       ('XY123ZA', 2016, 55000, 1600, 25000.00, 'Mercedes', 'Classe C'),
       ('BC234DE', 2018, 35000, 1200, 14000.00, 'Volkswagen', 'Golf'),
       ('FG456HI', 2022, 5000, 1300, 17000.00, 'Renault', 'Clio'),
       ('JK789LM', 2019, 25000, 1500, 16000.00, 'Honda', 'Civic'),
       ('MN123OP', 2021, 15000, 1600, 15500.00, 'Toyota', 'Corolla'),
       ('QR456ST', 2020, 12000, 1500, 14500.00, 'Fiat', 'Punto');
INSERT INTO Conosciuto_LAB6 (Marca, Modello, Nome, Cognome)
VALUES ('Toyota', 'Corolla', 'Mario', 'Rossi'),
       ('Fiat', 'Punto', 'Luigi', 'Bianchi'),
       ('Ford', 'Fiesta', 'Anna', 'Verdi'),
       ('Fiat', 'Multipla', 'Federico', 'Porpora'),
       ('BMW', 'Serie 3', 'Tommaso', 'Portolani'),
       ('Audi', 'A4', 'Matteo', 'Gattobigio'),
       ('Mercedes', 'Classe C', 'Sara', 'Longhi'),
       ('Volkswagen', 'Golf', 'Alessandro', 'Grassi'),
       ('Renault', 'Clio', 'Giulia', 'Neri'),
       ('Honda', 'Civic', 'Mario', 'Rossi');
INSERT INTO VENDITE_LAB6 (Targa, PrezzoVend, Nome, Cognome)
VALUES ('AB123CD', 11500.00, 'Mario', 'Rossi'),
       ('EF456GH', 8500.00, 'Luigi', 'Bianchi'),
       ('IJ789KL', 14500.00, 'Anna', 'Verdi'),
       ('LM123NO', 48000.00, 'Federico', 'Porpora'),
       ('PQ456RS', 17500.00, 'Tommaso', 'Portolani'),
       ('ZX123YW', 18500.00, 'Tommaso', 'Portolani'),
       ('TU789VW', 21000.00, 'Matteo', 'Gattobigio'),
       ('GH567JK', 22500.00, 'Matteo', 'Gattobigio'),
       ('XY123ZA', 24000.00, 'Sara', 'Longhi'),
       ('BC234DE', 13500.00, 'Alessandro', 'Grassi'),
       ('FG456HI', 16500.00, 'Giulia', 'Neri'),
       ('JK789LM', 15500.00, 'Mario', 'Rossi');


-- ES 3

-- VISTA
DROP VIEW VENDITE_VIEW_LAB6;

CREATE VIEW Vendite_View_Lab6(NomeVenditore, CognomeVenditore, Marca, Modello, Vendite)
AS SELECT v.NOME, v.COGNOME, a.MARCA, a.MODELLO, COUNT(a.MODELLO) AS NUM
   FROM VENDITE_LAB6 v
   JOIN AUTO_LAB6 a ON a.TARGA = v.TARGA
   GROUP BY v.NOME, v.COGNOME, a.MODELLO, a.MARCA


-- PRIMO TRIGGER
CREATE OR REPLACE TRIGGER SellingAtHigherPrice
BEFORE INSERT ON VENDITE_LAB6
REFERENCING NEW AS N
FOR EACH ROW 
WHEN (N.PrezzoVend > (SELECT a.PrezzoRich
					  FROM AUTO_LAB6 a
					  WHERE a.TARGA = N.TARGA))
SIGNAL SQLSTATE '70000' ('L''auto che stiamo vendendo è ad un prezzo maggiore di quello richiesto')

--TEST
INSERT INTO VENDITE_LAB6 VALUES ('MN123OP', 30000.00, 'Federico', 'Porpora'); -- deve dare errore


-- SECONDO TRIGGER
CREATE OR REPLACE TRIGGER CalculateRequestPrice
BEFORE INSERT ON AUTO_LAB6
REFERENCING NEW AS N
FOR EACH ROW
WHEN (N.PrezzoRich IS NULL)
IF (EXISTS (SELECT *
			FROM AUTO_LAB6 a
			WHERE (N.Marca, N.Modello) = (a.Marca, a.Modello)))
THEN SET N.PrezzoRich = (SELECT AVG(a.PrezzoRich)
						 FROM AUTO_LAB6 a
						 WHERE (N.Marca, N.Modello) = (a.Marca, a.Modello));
ELSE SIGNAL SQLSTATE '70001' ('L''auto inserita non ha un prezzo richiesto e non ha delle auto da confrontare');
END IF

INSERT INTO MODELLI_LAB6 VALUES ('Mitsubishi', 'Pajero');
INSERT INTO CONOSCIUTO_LAB6 VALUES ('Mitsubishi', 'Pajero', 'Federico', 'Porpora');
INSERT INTO AUTO_LAB6 VALUES ('ST901UV', 2015, 50000, 1600, NULL, 'Toyota', 'Corolla'); -- no errore e prezzo 13.750
INSERT INTO AUTO_LAB6 VALUES ('NO345PQ', 2015, 50000, 1600, NULL, 'Mitsubishi', 'Pajero'); -- errore



