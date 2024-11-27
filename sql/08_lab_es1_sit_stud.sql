/*
DROP TABLE E1_ES1_LAB8; 
DROP TABLE E2_ES1_LAB8;
*/
create table E1_ES1_LAB8 (
     K1 VARCHAR(255) not null,
     A VARCHAR(255) not null,
     K2 VARCHAR(255) not null,
     C VARCHAR(255) not null,
     constraint ID_E1_ES1_LAB8_1_ID primary key (K1));

create table E2_ES1_LAB8 (
     K2 VARCHAR(255) not null,
     B_B1 VARCHAR(255),
     B_B2 VARCHAR(255),
     K1 VARCHAR(255),
     Y_ VARCHAR(255) not null,
     constraint ID_E2_ES1_LAB8_1_ID primary key (K2));
    

alter table E1_ES1_LAB8 add constraint REF_E1_ES1_LAB8_1_E2_ES1_LAB8_1_FK
     foreign key (K2)
     references E2_ES1_LAB8;

alter table E2_ES1_LAB8 add constraint REF_E2_ES1_LAB8_1_E1_ES1_LAB8_1_FK
     foreign key (K1)
     references E1_ES1_LAB8;

alter table E2_ES1_LAB8 add constraint REF_E2_ES1_LAB8_1_E2_ES1_LAB8_1_FK
     foreign key (Y_)
     references E2_ES1_LAB8;

alter table E2_ES1_LAB8 add constraint COEX_E2_ES1_LAB8_1
     check((B_B1 is not null and B_B2 is not null)
           or (B_B1 is null and B_B2 is null));


CREATE OR REPLACE TRIGGER CoexistanceB_B1B_B2
BEFORE INSERT ON E2_ES1_LAB8
REFERENCING NEW AS N
FOR EACH ROW
WHEN (EXISTS (SELECT *
			 FROM E2_ES1_LAB8 e
			 WHERE (e.B_B1, e.B_B2) = (N.B_B1, N.B_B2)))
SIGNAL SQLSTATE '70001' ('Errore nell''inserimento della coesistenza di B_B1 e B_B2');


CREATE OR REPLACE TRIGGER NO_R3Y_AND_R2
BEFORE INSERT ON E2_ES1_LAB8
REFERENCING NEW AS N
FOR EACH ROW 
WHEN (EXISTS (SELECT *
			  FROM E2_ES1_LAB8 e
			  WHERE N.Y_ = e.K2
			  AND e.K1 IS NOT NULL))
SIGNAL SQLSTATE '70002' ('La tupla inserita referenzia una tupla di E2_ES1_LAB8 che partecipa a R2!');

INSERT INTO E2_ES1_LAB8 (K2, B_B1, B_B2, K1, Y_) VALUES
('E2_001', 'Value1', 'Extra1', NULL , 'E2_001');-- `Y_` fa riferimento a se stessa (valido)

INSERT INTO E1_ES1_LAB8 (K1, A, K2, C) VALUES
('E1_001', 'Alpha', 'E2_001', 'Description 1');

INSERT INTO E2_ES1_LAB8 VALUES ('E2_005', 'Value3', 'Extra3', NULL, 'E2_001');

INSERT INTO E2_ES1_LAB8 VALUES ('E2_004', 'Value1', 'Extra2', 'E1_001', 'E2_005');

INSERT INTO E2_ES1_LAB8 VALUES ('E2_006', 'Value4', 'Extra4', 'E1_001', 'E2_004'); --DEVE DARE ERRORE



