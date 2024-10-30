-- Q8) La coppia di nomi di table che compaiono più frequentemente insieme in uno stesso
-- schema
WITH TABELLA(TABNAME1, TABNAME2, NUM) AS (SELECT t.TABNAME, t2.TABNAME, COUNT(*)
										  FROM SYSCAT.TABLES t
										  JOIN SYSCAT.TABLES t2 ON t.TABSCHEMA = t2.TABSCHEMA
										  WHERE t.TABNAME <> t2.TABNAME
										  GROUP BY t.TABNAME, t2.TABNAME)
SELECT TABNAME1, TABNAME2, NUM
FROM TABELLA t
WHERE NUM = (SELECT MAX(NUM)
			 FROM TABELLA t2)

-- Q9) Per ogni nome di table (TYPE = 'T'), quante volte è ripetuta su SIT_STUD, fornendo i
-- timestamp di creazione minimo e massimo e ordinando per valori decrescenti di
-- ripetizione, ma solo per table ripetute almeno 4 volte
WITH TABELLA_RIPETIZIONI(TABNAME, NUM) AS (SELECT TABNAME, COUNT(*)
										   FROM SYSCAT.TABLES
										   WHERE TYPE = 'T'
										   GROUP BY TABNAME
										   HAVING COUNT(*) >= 4),
TABELLA_MAX_CREAZIONE(TABNAME, CREATE_TIME) AS (SELECT TABNAME, MAX(CREATE_TIME)
												FROM SYSCAT.TABLES
												GROUP BY TABNAME),
TABELLA_MIN_CREAZIONE(TABNAME, CREATE_TIME) AS (SELECT TABNAME, MIN(CREATE_TIME)
												FROM SYSCAT.TABLES
												GROUP BY TABNAME)
SELECT t1.TABNAME, t2.CREATE_TIME, t3.CREATE_TIME
FROM TABELLA_RIPETIZIONI t1
JOIN TABELLA_MAX_CREAZIONE t2 ON t1.TABNAME = t2.TABNAME
JOIN TABELLA_MIN_CREAZIONE t3 ON t2.TABNAME = t3.TABNAME