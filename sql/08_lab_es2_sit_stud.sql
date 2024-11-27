/*
DROP TABLE E1_ES2_LAB8;
DROP TABLE E2_ES2_LAB8;
*/

create table E1_ES2_LAB8 (
     K1 VARCHAR(255) not null,
     A VARCHAR(255) not null,
     D VARCHAR(255) not null,
     X_K1 VARCHAR(255),
     R_E_K1 VARCHAR(255),
     R_E_B VARCHAR(255),
     constraint ID_E1_ES2_LAB8_ID primary key (K1));

create table E2_ES2_LAB8 (
     K1 VARCHAR(255) not null,
     C VARCHAR(255) not null,
     B VARCHAR(255) not null,
     constraint ID_E2_ES2_LAB8_ID primary key (K1, B));



alter table E1_ES2_LAB8 add constraint COEX_E1_ES2_LAB8
     check((X_K1 is not null and R_E_K1 is not null and R_E_B is not null)
           or (X_K1 is null and R_E_K1 is null and R_E_B is null)); 

alter table E1_ES2_LAB8 add constraint REF_E1_ES2_LAB8_E1_ES2_LAB8_FK
     foreign key (X_K1)
     references E1_ES2_LAB8;

alter table E1_ES2_LAB8 add constraint REF_E1_ES2_LAB8_E2_ES2_LAB8_FK
     foreign key (R_E_K1, R_E_B)
     references E2_ES2_LAB8;

alter table E1_ES2_LAB8 add constraint REF_E1_ES2_LAB8_E2_ES2_LAB8_CHK
     check((R_E_K1 is not null and R_E_B is not null)
           or (R_E_K1 is null and R_E_B is null)); 

alter table E2_ES2_LAB8 add constraint REF_E2_ES2_LAB8_E1_ES2_LAB8
     foreign key (K1)
     references E1_ES2_LAB8;

CREATE OR REPLACE TRIGGER K1Different
BEFORE INSERT ON E1_ES2_LAB8
REFERENCING NEW AS N
FOR EACH ROW
WHEN (K1 = X_K1 OR K1 = R_E_K1 OR X_K1 = R_E_K1)
SIGNAL SQLSTATE '70001' ('I valori di K1 sono uguali tra di loro');

CREATE OR REPLACE TRIGGER MaxSum100
BEFORE INSERT ON E2_ES2_LAB8
REFERENCING NEW AS N
FOR EACH ROW
WHEN ((SELECT SUM(B)
	   FROM E2_ES2_LAB8 e
	   GROUP BY e.K1
	   HAVING e.K1 = N.K1) > (100 - N.B))
SIGNAL SQLSTATE '70002' ('La somma di B degli stessi valori di E1_ES2_LAB8 sono > 100')

INSERT INTO E1_ES2_LAB8 (K1, A, D, X_K1, R_E_K1, R_E_B) VALUES
('K1_1', 'A1', 'D1', null, null, null),
('K1_2', 'A2', 'D2', null, null, null);

INSERT INTO E2_ES2_LAB8 (K1, B, C) VALUES
('K1_1', 40, 'C1'),
('K1_1', 30, 'C2');

--non va questo inserimento
INSERT INTO E2_ES2_LAB8 (K1, B, C) VALUES
('K1_1', 40, 'C3');