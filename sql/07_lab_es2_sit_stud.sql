create table CAMERE_LAB7 (
     Numero int not null,
     PostiLetto int not null,
     constraint ID_CAMERE_ID primary key (Numero));

create table PRENOTAZIONI_LAB7 (
     Numero int not null,
     DataInizio date not null,
     DataFine date not null,
     NumPersone int not null,
     constraint ID_PRENOTAZIONI_ID primary key (Numero, DataInizio));


alter table PRENOTAZIONI_LAB7 add constraint FKPRE_CAM
     foreign key (Numero)
     references CAMERE_LAB7;



CREATE OR REPLACE TRIGGER CheckIfRoomFree
BEFORE INSERT ON PRENOTAZIONI_LAB7
REFERENCING NEW AS N
FOR EACH ROW
WHEN (EXISTS (SELECT *
			  FROM PRENOTAZIONI_LAB7 p
			  WHERE p.Numero = N.Numero AND (N.DataInizio <= p.DataFine) OR (N.DataFine >= p.DataInizio)))
SIGNAL SQLSTATE '70000' ('Si sovrappongono delle prenotazioni, non e'' possibile aggiungerla');