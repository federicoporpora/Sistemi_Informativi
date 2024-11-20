create table STATISTICHE_LAB7 (
     CodFattura char(10) not null,
     DurataLavori INT not null,
     VariazionePercentuale dec(10, 2) not null,
     constraint FKFS_ID primary key (CodFattura));

create table FATTURE_LAB7 (
     CodFattura char(10) not null,
     Numero int not null,
     NomeCliente char(10) not null,
     Data date not null,
     Importo dec(10, 2) not null,
     constraint ID_FATTURE_ID primary key (CodFattura),
     constraint FKPF_ID unique (Numero));

create table PREVENTIVI_LAB7 (
     Numero int not null,
     NomeCliente char(10) not null,
     DescrizioneLavori varchar(100) not null,
     ImportoPrevisto dec(10, 2) not null,
     DataPreventivo date not null,
     DataInizioLavori date not null,
     constraint ID_PREVENTIVI_ID primary key (Numero));


alter table STATISTICHE_LAB7 add constraint FKFS_FK
     foreign key (CodFattura)
     references FATTURE_LAB7;

/* check con subquery
alter table FATTURE_LAB7 add constraint ID_FATTURE_CHK
     check(exists(select * from STATISTICHE_LAB7
                  where STATISTICHE_LAB7.CodFattura = CodFattura)); 
*/

alter table FATTURE_LAB7 add constraint FKPF_FK
     foreign key (Numero)
     references PREVENTIVI_LAB7;



CREATE OR REPLACE TRIGGER AddPercentageOnStatistiche
AFTER INSERT ON FATTURE_LAB7
REFERENCING NEW AS N
FOR EACH ROW 
INSERT INTO STATISTICHE_LAB7 VALUES (N.CodFattura, (SELECT N.DATA - p.DataInizioLavori
													FROM PREVENTIVI_LAB7 p
													WHERE N.Numero = p.Numero), (SELECT ((N.Importo - p.ImportoPrevisto) / p.ImportoPrevisto) * 100
																				 FROM PREVENTIVI_LAB7 p
																				 WHERE N.Numero = p.Numero))