-- Q1) Il numero dei dipartimenti con almeno 7 dipendenti
SELECT COUNT(*) AS NUM_DEPARTMENTS
FROM DEPARTMENT d
WHERE 7 <= (SELECT COUNT(*)
			FROM EMPLOYEE e
			WHERE d.DEPTNO = e.workdept)

-- Q2) I dati dei dipendenti che lavorano in un dipartimento con almeno 7 dipendenti
SELECT e.*
FROM EMPLOYEE e
WHERE e.WORKDEPT IN (SELECT D.DEPTNO
					 FROM DEPARTMENT d
					 WHERE 7 <= (SELECT COUNT(*)
					 			 FROM EMPLOYEE e
					 			 WHERE d.DEPTNO = e.workdept))

-- Q3) I dati del dipartimento con il maggior numero di dipendenti
SELECT d.*
FROM DEPARTMENT d
WHERE (SELECT COUNT(*)
	   FROM EMPLOYEE e
       WHERE d.DEPTNO = e.WORKDEPT) >= ALL (SELECT COUNT(*)
											FROM EMPLOYEE e2
											GROUP BY e2.WORKDEPT)
       

-- Q4) Il nome delle regioni e il totale delle vendite per ogni regione con un totale di vendite maggiore di 30,
-- ordinando per totale vendite decrescente
SELECT s.REGION, SUM(SALES) AS SUM_SALES
FROM SALES s
GROUP BY s.REGION
HAVING SUM(SALES) > 30
ORDER BY SUM_SALES DESC

-- Q5) Lo stipendio medio dei dipendenti che non sono manager di nessun dipartimento
-- JOB = ‘MANAGER’ non è significativo!!
SELECT CAST(AVG(e.SALARY) AS DEC(10, 2)) AS STIPENDIO_MEDIO_NO_MAN
FROM EMPLOYEE e
WHERE e.EMPNO IN (SELECT e2.EMPNO
				  FROM EMPLOYEE e2
				  EXCEPT ALL
				  SELECT d.MGRNO
				  FROM DEPARTMENT d
				  WHERE d.MGRNO IS NOT NULL)

-- Q6) I dipartimenti che non hanno dipendenti il cui cognome inizia per ‘L’
SELECT d.*
FROM DEPARTMENT d
WHERE d.DEPTNO NOT IN (SELECT e.WORKDEPT
					   FROM EMPLOYEE e
					   WHERE LOWER(e.LASTNAME) LIKE 'l%')

-- Q7) I dipartimenti e il rispettivo massimo stipendio per tutti i dipartimenti aventi un salario
-- medio minore del salario medio calcolato considerando i dipendenti di tutti gli altri dipartimenti
SELECT e.WORKDEPT, MAX(e.SALARY)
FROM EMPLOYEE e
GROUP BY e.WORKDEPT
HAVING AVG(e.SALARY) < (SELECT AVG(e2.SALARY)
FROM EMPLOYEE e2)

-- Q8) Per ogni dipartimento determinare lo stipendio medio per ogni lavoro per il quale il
-- livello di educazione medio è maggiore di quello dei dipendenti dello stesso
-- dipartimento che fanno un lavoro differente
SELECT e.WORKDEPT, e.JOB, AVG(e.SALARY) AS AVG_SALARY
FROM EMPLOYEE e
GROUP BY e.JOB, e.WORKDEPT
HAVING AVG(e.EDLEVEL * 1.0) > (SELECT AVG(e2.EDLEVEL)
FROM EMPLOYEE e2
WHERE e2.WORKDEPT = e.WORKDEPT AND e2.JOB <> e.JOB)

-- Q9) Lo stipendio medio dei dipendenti che non sono addetti alle vendite
SELECT CAST(AVG(e.SALARY) AS DEC(8, 2)) AS AVG_SALARY
FROM EMPLOYEE e
WHERE e.LASTNAME NOT IN (SELECT s.SALES_PERSON
						 FROM SALES s)

-- Q10) Per ogni regione, i dati del dipendente che ha il maggior numero di vendite
-- (SUM(SALES)) in quella regione
SELECT DISTINCT s.REGION, e.*
FROM EMPLOYEE e
CROSS JOIN SALES s
WHERE (s.REGION, e.LASTNAME) IN (SELECT s.REGION, s.SALES_PERSON
								 FROM SALES s
								 GROUP BY s.REGION, s.SALES_PERSON
								 HAVING SUM(s.SALES) >= ALL (SELECT SUM(s2.SALES)
								 							 FROM SALES s2
								 							 GROUP BY s2.REGION, s2.SALES_PERSON
								 							 HAVING s2.REGION = s.REGION))

-- Q11) I codici dei dipendenti che svolgono un’attività per la quale ogni tupla di EMPPROJACT
-- riguarda un periodo minore di 200 giorni
SELECT DISTINCT e.EMPNO
FROM EMPPROJACT e
WHERE e.ACTNO IN (SELECT e2.ACTNO --codici di progetti in cui tutte le tuple sono < 200 giorni
					   FROM EMPPROJACT e2
					   EXCEPT
					   SELECT e3.ACTNO
					   FROM EMPPROJACT e3
					   WHERE DAYS(e3.EMENDATE) - DAYS(e3.EMSTDATE) > 200)

-- Q12) Le attività, e il codice del relativo dipartimento, svolte da dipendenti di un solo
-- dipartimento
SELECT DISTINCT e.ACTNO, e2.WORKDEPT
FROM EMPPROJACT e
JOIN EMPLOYEE e2 ON e2.EMPNO = e.EMPNO
WHERE e.ACTNO IN (SELECT e.ACTNO
				  FROM EMPPROJACT e
				  JOIN EMPLOYEE e2 ON e2.EMPNO = e.EMPNO
				  GROUP BY e.ACTNO
				  HAVING COUNT(DISTINCT e2.WORKDEPT) = 1)

/*
Q1)

NUM_DIP_7_EMP
-------------
            3

  1 record selezionato/i.


Q2)

EMPNO  FIRSTNME     MIDINIT LASTNAME        WORKDEPT PHONENO HIREDATE   JOB      EDLEVEL SEX BIRTHDATE  SALARY      BONUS       COMM       
------ ------------ ------- --------------- -------- ------- ---------- -------- ------- --- ---------- ----------- ----------- -----------
000060 IRVING       F       STERN           D11      6423    14/09/2003 MANAGER       16 M   07/07/1975    72250,00      500,00     2580,00
000070 EVA          D       PULASKI         D21      7831    30/09/2005 MANAGER       16 F   26/05/2003    96170,00      700,00     2893,00
000090 EILEEN       W       HENDERSON       E11      5498    15/08/2000 MANAGER       16 F   15/05/1971    89750,00      600,00     2380,00
000150 BRUCE                ADAMSON         D11      4510    12/02/2002 DESIGNER      16 M   17/05/1977    55280,00      500,00     2022,00
000160 ELIZABETH    R       PIANKA          D11      3782    11/10/2006 DESIGNER      17 F   12/04/1980    62250,00      400,00     1780,00
000170 MASATOSHI    J       YOSHIMURA       D11      2890    15/09/1999 DESIGNER      16 M   05/01/1981    44680,00      500,00     1974,00
000180 MARILYN      S       SCOUTTEN        D11      1682    07/07/2003 DESIGNER      17 F   21/02/1979    51340,00      500,00     1707,00
000190 JAMES        H       WALKER          D11      2986    26/07/2004 DESIGNER      16 M   25/06/1982    50450,00      400,00     1636,00
000200 DAVID                BROWN           D11      4501    03/03/2002 DESIGNER      16 M   29/05/1971    57740,00      600,00     2217,00
000210 WILLIAM      T       JONES           D11      0942    11/04/1998 DESIGNER      17 M   23/02/2003    68270,00      400,00     1462,00
000220 JENNIFER     K       LUTZ            D11      0672    29/08/1998 DESIGNER      18 F   19/03/1978    49840,00      600,00     2387,00
000230 JAMES        J       JEFFERSON       D21      2094    21/11/1996 CLERK         14 M   30/05/1980    42180,00      400,00     1774,00
000240 SALVATORE    M       MARINO          D21      3780    05/12/2004 CLERK         17 M   31/03/2002    48760,00      600,00     2301,00
000250 DANIEL       S       SMITH           D21      0961    30/10/1999 CLERK         15 M   12/11/1969    49180,00      400,00     1534,00
000260 SYBIL        P       JOHNSON         D21      8953    11/09/2005 CLERK         16 F   05/10/1976    47250,00      300,00     1380,00
000270 MARIA        L       PEREZ           D21      9001    30/09/2006 CLERK         15 F   26/05/2003    37380,00      500,00     2190,00
000280 ETHEL        R       SCHNEIDER       E11      8997    24/03/1997 OPERATOR      17 F   28/03/1976    36250,00      500,00     2100,00
000290 JOHN         R       PARKER          E11      4502    30/05/2006 OPERATOR      12 M   09/07/1985    35340,00      300,00     1227,00
000300 PHILIP       X       SMITH           E11      2095    19/06/2002 OPERATOR      14 M   27/10/1976    37750,00      400,00     1420,00
000310 MAUDE        F       SETRIGHT        E11      3332    12/09/1994 OPERATOR      12 F   21/04/1961    35900,00      300,00     1272,00
200170 KIYOSHI              YAMAMOTO        D11      2890    15/09/2005 DESIGNER      16 M   05/01/1981    64680,00      500,00     1974,00
200220 REBA         K       JOHN            D11      0672    29/08/2005 DESIGNER      18 F   19/03/1978    69840,00      600,00     2387,00
200240 ROBERT       M       MONTEVERDE      D21      3780    05/12/2004 CLERK         17 M   31/03/1984    37760,00      600,00     2301,00
200280 EILEEN       R       SCHWARTZ        E11      8997    24/03/1997 OPERATOR      17 F   28/03/1966    46250,00      500,00     2100,00
200310 MICHELLE     F       SPRINGER        E11      3332    12/09/1994 OPERATOR      12 F   21/04/1961    35900,00      300,00     1272,00

  25 record selezionato/i.


Q3)

DEPTNO DEPTNAME                             MGRNO  ADMRDEPT LOCATION        
------ ------------------------------------ ------ -------- ----------------
D11    MANUFACTURING SYSTEMS                000060 D01      -               

  1 record selezionato/i.


Q4)

REGION          SUM_SALES  
--------------- -----------
Quebec                   53
Ontario-South            52
Manitoba                 41

  3 record selezionato/i.


Q5)

AVG_SALARY 
-----------
   49199,41

  1 record selezionato/i.


Q6)

DEPTNO DEPTNAME                             MGRNO  ADMRDEPT LOCATION        
------ ------------------------------------ ------ -------- ----------------
B01    PLANNING                             000020 A00      -               
C01    INFORMATION CENTER                   000030 A00      -               
D01    DEVELOPMENT CENTER                   -      A00      -               
D21    ADMINISTRATION SYSTEMS               000070 D01      -               
E01    SUPPORT SERVICES                     000050 A00      -               
E11    OPERATIONS                           000090 E01      -               
F22    BRANCH OFFICE F2                     -      E01      -               
G22    BRANCH OFFICE G2                     -      E01      -               
H22    BRANCH OFFICE H2                     -      E01      -               
I22    BRANCH OFFICE I2                     -      E01      -               
J22    BRANCH OFFICE J2                     -      E01      -               

  11 record selezionato/i.


Q7)

WORKDEPT MAX_SALARY 
-------- -----------
D21         96170,00
E11         89750,00
E21         86150,00

  3 record selezionato/i.


Q8)

WORKDEPT JOB      AVG_SALARY 
-------- -------- -----------
A00      PRES       152750,00
A00      SALESREP    56500,00
C01      MANAGER     98250,00
D11      DESIGNER    57437,00
D21      MANAGER     96170,00
E11      MANAGER     89750,00
E21      FIELDREP    39274,00

  7 record selezionato/i.


Q9)

AVG_SALARY 
-----------
   58636,28

  1 record selezionato/i.


Q10)

REGION          EMPNO  FIRSTNME     MIDINIT LASTNAME        WORKDEPT PHONENO HIREDATE   JOB      EDLEVEL SEX BIRTHDATE  SALARY      BONUS       COMM       
--------------- ------ ------------ ------- --------------- -------- ------- ---------- -------- ------- --- ---------- ----------- ----------- -----------
Manitoba        000330 WING                 LEE             E21      2103    23/02/2006 FIELDREP      14 M   18/07/1971    45370,00      500,00     2030,00
Ontario-North   000330 WING                 LEE             E21      2103    23/02/2006 FIELDREP      14 M   18/07/1971    45370,00      500,00     2030,00
Ontario-South   000330 WING                 LEE             E21      2103    23/02/2006 FIELDREP      14 M   18/07/1971    45370,00      500,00     2030,00
Quebec          000330 WING                 LEE             E21      2103    23/02/2006 FIELDREP      14 M   18/07/1971    45370,00      500,00     2030,00

  4 record selezionato/i.


Q11)

EMPNO 
------
000130
000140
000200

  3 record selezionato/i.


Q12)

ACTNO DEPT
----- ----
   20 A00 
   30 B01 
   40 D11 
   50 D11 
   90 C01 
  100 C01 
  110 C01 
  130 E11 
  140 E21 
  150 E21 
  160 E21 
  170 E21 

  12 record selezionato/i.
*/