create table CARBURANTI_LAB7 (
     Nome char(10) not null,
     constraint ID_CARBURANTI_ID primary key (Nome));

create table RIFORNIMENTI_LAB7 (
     ID char(10) not null,
     Timestamp char(10) not null,
     Litri char(10) not null,
     Nome char(10) not null,
     Numero int not null,
     constraint ID_RIFORNIMENTI_ID primary key (ID));

create table PC_LAB7 (
     Nome char(10) not null,
     Numero int not null,
     Prezzo DEC(5, 2) not null,
     LitriErogati dec(6, 1) not null,
     constraint ID_PC_ID primary key (Nome, Numero));

create table POMPE_LAB7 (
     Numero int not null,
     constraint ID_POMPE_ID primary key (Numero));

/* check con subquery
alter table CARBURANTI_LAB7 add constraint ID_CARBURANTI_CHK
     check(exists(select * from PC_LAB7
                  where PC_LAB7.Nome = Nome)); 
*/

alter table RIFORNIMENTI_LAB7 add constraint FKR_FK
     foreign key (Nome, Numero)
     references PC_LAB7;

alter table PC_LAB7 add constraint FKPC_POM_FK
     foreign key (Numero)
     references POMPE_LAB7;

alter table PC_LAB7 add constraint FKPC_CAR
     foreign key (Nome)
     references CARBURANTI_LAB7;