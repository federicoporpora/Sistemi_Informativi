--
-- Script SQL: Dati per l'esercitazione 2 (L02)
-- 

--
-- Si ringrazia Andrea Masini per il contributo
--

INSERT INTO RIVENDITORI VALUES 
('RIV01', 'Venezia'),
('RIV02','Bologna'),
('RIV03','Bologna'),
('RIV04','Rimini')
;

INSERT INTO MODELLI
VALUES 
('Agila', 'Opel', 998, 'Benzina', 180, 12000.00),
('Aventador', 'Lamborghini', 6498, 'Benzina', 350, 432729.00),
('Ghibli', 'Maserati', 3799, 'Benzina', 326, 150000.00),
('Stratos', 'Lancia', 2419, 'Benzina', 230, 130000.00);

INSERT INTO AUTO VALUES 
('AG123AG', 'Agila', 'RIV03', 10500.00, 50000, 2003, NULL),
('AG234AG', 'Agila', 'RIV03', 9000.00, 70000, 2003, NULL),
('AV456AV', 'Aventador', 'RIV02',430000.00, 0, 2017, NULL),
('AV567AV', 'Aventador', 'RIV02', 400000.00, 0, 2015, 'SI'),
('GH789GH', 'Ghibli', 'RIV01', 90000.00, 0, 2015, 'SI'),
('GH890GH', 'Ghibli', 'RIV02', 100000.00, 30000, 2013, NULL),
('GH901GH', 'Ghibli','RIV03', 70000.00, 50000, 2015, 'SI'),
('ST123ST', 'Stratos', 'RIV04', 80000.00, 15000, 1997, 'SI'),
('ST234ST', 'Stratos','RIV04', 95000.00, 70000, 2012, 'SI');