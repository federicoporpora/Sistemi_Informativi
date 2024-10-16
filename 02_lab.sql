DROP TABLE A1114450.MODELLI

DROP TABLE A1114450.RIVENDITORI

DROP TABLE A1114450.AUTO

CREATE TABLE MODELLI(
Modello varchar(50) NOT NULL PRIMARY KEY,
Marca varchar(50) NOT NULL,
Cilindrata integer NOT NULL,
Alimentazione varchar(50) NOT NULL,
VelMax integer NOT NULL,
PrezzoListino dec(8, 2) NOT NULL
)

CREATE TABLE RIVENDITORI(
CodR varchar(50) NOT NULL PRIMARY KEY,
Citta varchar(50) NOT NULL
)

CREATE TABLE AUTO(
Targa varchar(50) NOT NULL PRIMARY KEY,
Modello varchar(50) NOT NULL REFERENCES MODELLI(Modello) ON DELETE CASCADE,
CodR varchar(50) NOT NULL REFERENCES RIVENDITORI(CodR) ON DELETE CASCADE,
PrezzoVendita dec(8, 2) NOT NULL,
Km integer NOT NULL,
Anno integer NOT NULL,
Venduta varchar(2),
CHECK (Venduta = 'SI' OR Venduta IS NULL)
)

-- Q1) Le Maserati ancora in vendita a Bologna a un prezzo inferiore al 70% del listino
SELECT a.*
FROM AUTO a
JOIN MODELLI m ON m.MODELLO = a.MODELLO
JOIN RIVENDITORI r ON r.CODR = a.CODR
WHERE a.VENDUTA IS NULL AND LOWER(r.Citta) = 'bologna' AND a.PREZZOVENDITA < (m.PREZZOLISTINO * 0.70) AND lower(m.MARCA) = 'maserati'

-- Q2) Il prezzo medio di un'auto a benzina con cilindrata (cc) < 1000, almeno 5 anni di vita e meno di 80000 Km
SELECT avg(a.PREZZOVENDITA)
FROM AUTO a
JOIN MODELLI m ON m.MODELLO = a.MODELLO
JOIN RIVENDITORI r ON r.CODR = a.CODR
WHERE LOWER(m.ALIMENTAZIONE) = 'benzina' AND m.CILINDRATA < 1000 AND (YEAR(CURRENT DATE) - a.ANNO) > 5 AND a.KM < 80000

-- Q3) Per ogni modello con velocità massima > 180 Km/h, il prezzo più basso a Bologna
SELECT min(a.PREZZOVENDITA), a.MODELLO
FROM AUTO a
JOIN MODELLI m ON m.MODELLO = a.MODELLO
JOIN RIVENDITORI r ON r.CODR = a.CODR
WHERE m.VELMAX > 180 AND LOWER(r.Citta) = 'bologna'
GROUP BY a.MODELLO

-- Q4) Il numero di auto complessivamente trattate e vendute in ogni città
SELECT count(TARGA), r.CITTA
FROM AUTO a
JOIN MODELLI m ON m.MODELLO = a.MODELLO
JOIN RIVENDITORI r ON r.CODR = a.CODR
GROUP BY r.CITTA

SELECT count(TARGA), r.CITTA
FROM AUTO a
JOIN MODELLI m ON m.MODELLO = a.MODELLO
JOIN RIVENDITORI r ON r.CODR = a.CODR
WHERE a.VENDUTA = 'SI'
GROUP BY r.CITTA

-- Q5) I rivenditori che hanno ancora in vendita almeno il 20% delle auto complessivamente trattate,
-- ordinando il risultato per città e quindi per codice rivenditore
SELECT r.CODR
FROM RIVENDITORI r
JOIN AUTO a ON r.CODR = a.CODR
GROUP BY r.CODR
HAVING count(a.VENDUTA) <= count(*)*0.8

-- Q6) I rivenditori che hanno disponibili auto di modelli mai venduti prima da loro
SELECT a.CODR
FROM AUTO a
GROUP BY a.CODR, a.MODELLO
HAVING COUNT(a.VENDUTA) = 0

-- Q7) Per ogni rivenditore, il numero di auto vendute, solo se il prezzo medio di tali auto risulta minore di 90000 Euro
SELECT r.CITTA, r.CODR, count(a.VENDUTA)
FROM AUTO a
JOIN RIVENDITORI r ON r.CODR = a.CODR
GROUP BY r.CITTA, r.CODR
HAVING avg(a.PREZZOVENDITA) < 90000

-- Q8) Per ogni auto A, il numero di auto vendute a un prezzo minore di quello di A
SELECT a.TARGA, COUNT(a2.TARGA)
FROM AUTO a
LEFT JOIN AUTO a2 ON a.PREZZOVENDITA > a2.PREZZOVENDITA AND a2.VENDUTA = 'SI'
GROUP BY a.TARGA

-- Q9) Per ogni anno e ogni modello, il rapporto medio tra prezzo di vendita e prezzo di listino, considerando un minimo di 2 auto vendute
SELECT a.MODELLO, AVG(a.PREZZOVENDITA / m.PREZZOLISTINO)
FROM AUTO a
JOIN MODELLI m ON a.MODELLO = m.MODELLO
GROUP BY a.ANNO, a.MODELLO
HAVING COUNT(a.VENDUTA) >= 2

-- Q10) Per ogni modello, i rivenditori che non ne hanno mai trattata una di quel modello
SELECT UNIQUE a.MODELLO, r.CODR
FROM AUTO a, RIVENDITORI r
WHERE a.CODR != r.CODR
GROUP BY a.MODELLO, r.CODR
EXCEPT ALL
SELECT UNIQUE a.MODELLO, a.CODR
FROM AUTO a
GROUP BY a.MODELLO, a.CODR











