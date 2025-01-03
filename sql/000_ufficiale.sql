-- ES 2 (SCEGLIERE SCHEMA B16884)
-- 2.1
WITH TABELLA(IDV, NOME, COGNOME, EURO) AS (SELECT v.IDV, v.NOME, v.COGNOME, MAX(m.EURO)
										   FROM VIGILI v, MULTE m
										   WHERE v.IDV = m.IDV AND M."DATA" - v.PRESASERVIZIO <= 30
										   GROUP BY v.IDV, v.NOME, v.COGNOME)
SELECT t.IDV, t.NOME, t.COGNOME, m.IDM, m.EURO
FROM TABELLA t, MULTE m, VIGILI v
WHERE t.EURO = m.EURO AND M."DATA" - v.PRESASERVIZIO <= 30 AND v.IDV = t.IDV AND v.IDV = m.IDV

-- 2.2
WITH TABELLA(TARGA, DIFFDATA) AS (SELECT m.TARGA, m.DATA - m2.DATA
								  FROM MULTE m, MULTE m2
								  WHERE m.TARGA = m2.TARGA AND m.IDM <> m2.IDM AND m.IDV <> m2.IDV AND m."DATA" - m2."DATA" > 0)
SELECT TARGA
FROM TABELLA
WHERE DIFFDATA = (SELECT MIN(DIFFDATA) FROM TABELLA)

-- ES 3
create table ACQUISTI (
     IdAcquisto char(1) not null,
     Importo char(1) not null,
     Username numeric(1) not null,
     constraint ID_ACQUISTI_ID primary key (IdAcquisto));

create table CLIENTI (
     Username numeric(1) not null,
     Nome char(1) not null,
     SpesaTot char(1) not null,
     StatoCliente char(1) not null,
     constraint ID_CLIENTI_ID primary key (Username));

alter table ACQUISTI add constraint FKCA_FK
     foreign key (Username)
     references CLIENTI;

create unique index ID_ACQUISTI_IND
     on ACQUISTI (IdAcquisto);

create index FKCA_IND
     on ACQUISTI (Username);

create unique index ID_CLIENTI_IND
     on CLIENTI (Username);

CREATE OR REPLACE TRIGGER UpdateExpence
AFTER INSERT IN ACQUISTI
REFERENCING NEW AS N
FOR EACH ROW
UPDATE CLIENTI
SET SpesaTot = SpesaTot + N.IMPORTO
