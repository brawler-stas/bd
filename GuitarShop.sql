Use master
Go
Drop Database if exists GuitarShop
Go
Create Database GuitarShop
Go
Use GuitarShop
GO

-- Таблицы-ребра
-- Создание таблицы "Guitar"
CREATE TABLE Guitar (
    ID INT PRIMARY KEY,
    [Name] VARCHAR(255),
    Brand VARCHAR(255),
    [Type] VARCHAR(255),
    Price DECIMAL(10, 2)
) AS NODE;

-- Создание таблицы "Client"
CREATE TABLE Client (
    ID INT PRIMARY KEY,
    First_Name VARCHAR(255),
    Last_Name VARCHAR(255),
    [Address] VARCHAR(255),
    Phone VARCHAR(20)
) AS NODE;

-- Создание таблицы "Manufacturer"
CREATE TABLE Manufacturer (
    ID INT PRIMARY KEY,
    [Name] VARCHAR(255),
    Country VARCHAR(255),
    Website VARCHAR(255)
) AS NODE;

-- Таблицы-ребра
CREATE TABLE Recommends AS EDGE;
GO
ALTER TABLE Recommends ADD CONSTRAINT EC_Recommends CONNECTION (Client to Client);

CREATE TABLE Buys AS EDGE;
GO
ALTER TABLE Buys ADD CONSTRAINT EC_Buys CONNECTION (Client to Guitar);

CREATE TABLE Produces AS EDGE;
GO
ALTER TABLE Produces ADD CONSTRAINT EC_Produces CONNECTION (Manufacturer To Guitar);

--Заполнение таблиц-узлов
-- Заполнение таблицы "Guitar"
INSERT INTO Guitar (ID, [Name], Brand, [Type], Price)
VALUES 
    (1, 'Stratocaster', 'Fender', 'Electric', 1999.99),
    (2, 'Les Paul', 'Gibson', 'Electric', 2499.99),
    (3, 'Telecaster', 'Fender', 'Electric', 1799.99),
    (4, 'SG', 'Gibson', 'Electric', 1799.99),
    (5, 'J-45', 'Gibson', 'Acoustic', 2299.99),
    (6, 'D-28', 'Martin', 'Acoustic', 2999.99),
    (7, '335', 'Gibson', 'Semi-Hollow', 2999.99),
    (8, 'PRS Custom 24', 'Paul Reed Smith', 'Electric', 3499.99),
    (9, 'ES-335', 'Gibson', 'Semi-Hollow', 3299.99),
    (10, 'Hummingbird', 'Gibson', 'Acoustic', 2699.99);
GO

-- Заполнение таблицы "Client"
INSERT INTO Client (ID, First_Name, Last_Name, [Address], Phone)
VALUES 
    (1, 'John', 'Doe', '123 Main St, City, Country', '+1234567890'),
    (2, 'Jane', 'Smith', '456 Elm St, City, Country', '+9876543210'),
    (3, 'Michael', 'Johnson', '789 Oak St, City, Country', '+1112223334'),
    (4, 'Emily', 'Brown', '321 Pine St, City, Country', '+5556667778'),
    (5, 'William', 'Davis', '654 Maple St, City, Country', '+9998887776'),
    (6, 'Olivia', 'Wilson', '987 Birch St, City, Country', '+4443332222'),
    (7, 'James', 'Taylor', '234 Cedar St, City, Country', '+7778889990'),
    (8, 'Sophia', 'Anderson', '567 Walnut St, City, Country', '+2223334445');
GO

-- Заполнение таблицы "Manufacturer"
INSERT INTO Manufacturer (ID, [Name], Country, Website)
VALUES 
    (1, 'Fender', 'USA', 'https://www.fender.com/'),
    (2, 'Gibson', 'USA', 'https://www.gibson.com/'),
    (3, 'Martin', 'USA', 'https://www.martinguitar.com/'),
    (4, 'Taylor', 'USA', 'https://www.taylorguitars.com/'),
    (5, 'Ibanez', 'Japan', 'https://www.ibanez.com/'),
    (6, 'PRS', 'USA', 'https://www.prsguitars.com/');
GO

-- 8 4 2 7 2 1 3 1 4
INSERT INTO Recommends ($from_id, $to_id)
VALUES 
	((Select $node_id From Client Where id = 1), (Select $node_id From Client Where id = 8)),
	((Select $node_id From Client Where id = 2), (Select $node_id From Client Where id = 4)),
	((Select $node_id From Client Where id = 5), (Select $node_id From Client Where id = 2)),
	((Select $node_id From Client Where id = 3), (Select $node_id From Client Where id = 7)),
	((Select $node_id From Client Where id = 4), (Select $node_id From Client Where id = 2)),
	((Select $node_id From Client Where id = 7), (Select $node_id From Client Where id = 1)),
	((Select $node_id From Client Where id = 6), (Select $node_id From Client Where id = 3)),
	((Select $node_id From Client Where id = 8), (Select $node_id From Client Where id = 1)),
	((Select $node_id From Client Where id = 1), (Select $node_id From Client Where id = 4));
GO

-- 8 3 2 7 6 3 5 3 5 1
INSERT INTO Buys($from_id, $to_id)
VALUES 
    ((SELECT $node_id FROM Client WHERE ID = 1), (SELECT $node_id FROM Guitar WHERE ID = 8)),
    ((SELECT $node_id FROM Client WHERE ID = 1), (SELECT $node_id FROM Guitar WHERE ID = 1)),
    ((SELECT $node_id FROM Client WHERE ID = 2), (SELECT $node_id FROM Guitar WHERE ID = 2)),
    ((SELECT $node_id FROM Client WHERE ID = 3), (SELECT $node_id FROM Guitar WHERE ID = 7)),
    ((SELECT $node_id FROM Client WHERE ID = 4), (SELECT $node_id FROM Guitar WHERE ID = 6)),
    ((SELECT $node_id FROM Client WHERE ID = 5), (SELECT $node_id FROM Guitar WHERE ID = 3)),
    ((SELECT $node_id FROM Client WHERE ID = 6), (SELECT $node_id FROM Guitar WHERE ID = 5)),
    ((SELECT $node_id FROM Client WHERE ID = 7), (SELECT $node_id FROM Guitar WHERE ID = 4)),
    ((SELECT $node_id FROM Client WHERE ID = 2), (SELECT $node_id FROM Guitar WHERE ID = 10)),
    ((SELECT $node_id FROM Client WHERE ID = 8),(SELECT $node_id FROM Guitar WHERE ID = 9));
GO

-- 5 8 1 6 4 10 7 9 2 3
INSERT INTO Produces ($from_id, $to_id)
VALUES 
	((Select $node_id From Manufacturer Where id = 1), (Select $node_id From Guitar Where id = 5)),
	((Select $node_id From Manufacturer Where id = 2), (Select $node_id From Guitar Where id = 8)),
	((Select $node_id From Manufacturer Where id = 3), (Select $node_id From Guitar Where id = 1)),
	((Select $node_id From Manufacturer Where id = 4), (Select $node_id From Guitar Where id = 6)),
	((Select $node_id From Manufacturer Where id = 5), (Select $node_id From Guitar Where id = 4)),
	((Select $node_id From Manufacturer Where id = 6), (Select $node_id From Guitar Where id = 10)),
	((Select $node_id From Manufacturer Where id = 1), (Select $node_id From Guitar Where id = 7)),
	((Select $node_id From Manufacturer Where id = 2), (Select $node_id From Guitar Where id = 9)),
	((Select $node_id From Manufacturer Where id = 3), (Select $node_id From Guitar Where id = 2)),
	((Select $node_id From Manufacturer Where id = 4), (Select $node_id From Guitar  Where id = 3));
GO

-- Найти всех клиентов, которые давали рекомендации клиенту Jane Smith:
SELECT C1.First_Name AS [Client],
       C2.First_Name AS [Recommends]
FROM Client AS C1, Recommends as R, Client AS C2
WHERE Match(C1-(R)->C2)
	  And C2.First_Name = N'Jane'
	  and C2.Last_Name = N'Smith'
GO

-- Найти всех производителей гитар Stratocaster:
Select M.[Name], M.Country, M.Website
From Manufacturer as M
	 , Produces as P
	 , Guitar as G
Where Match(M-(P)->G)
	  And G.[Name] = N'Stratocaster'  
Go

-- Найти всех клиентов, купивших гитару Telecaster:
Select C.First_Name, C.Last_Name
From Client as C
	 , Buys as B
	 , Guitar as G
Where Match(C-(B)->G)
	  And G.[Name] = N'Telecaster' 
Go

-- Найти все гитары клиента John Doe:
SELECT G.[Name] as [Guitar]
FROM Client as T
	 , Buys as B
	 , Guitar as G
WHERE T.First_Name = N'John'
	  and MATCH(T-(B)->G)
GO

-- Найти хозяина и производителя гитары Hummingbird:
select  G.[Name] as Guitar, M.[Name] as Manufacturer,  CONCAT(C.First_Name, C.Last_Name) as Client
from Guitar as G
	 , Buys as B
	 , Client as C
	 , Produces as P
	 , Manufacturer as M
where G.[Name] = 'Hummingbird'
and MATCH(C-(B)->G)
and MATCH(M-(P)->G)

-- Поиск кратчайшего пути рекомендаций между двумя клиентами (используя "+"):

SELECT C1.First_Name
, STRING_AGG(C2.First_Name, '->') WITHIN GROUP (GRAPH PATH) AS
Recommends
FROM Client AS C1
, Recommends FOR PATH AS R
, Client FOR PATH AS C2
WHERE MATCH(SHORTEST_PATH(C1(-(R)->C2)+))
AND C1.First_Name = N'Olivia';

--Поиск кратчайшего пути между клиентами, где количество ребер не превышает 2 (используя "{1,n}"): 

SELECT C1.First_Name
, STRING_AGG(C2.First_Name, '->') WITHIN GROUP (GRAPH PATH) AS
Recommends
FROM Client AS C1
, Recommends FOR PATH AS R
, Client FOR PATH AS C2
WHERE MATCH(SHORTEST_PATH(C1(-(R)->C2){1,2}))
AND C1.First_Name = N'Olivia';