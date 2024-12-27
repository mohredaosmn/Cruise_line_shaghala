CREATE DATABASE Cruise_Line
GO
USE Cruise_Line

CREATE TABLE person
(
  personID INT IDENTITY(1,1) NOT NULL,
  Username VARCHAR(50) NOT NULL,
  Email VARCHAR(50) NOT NULL,
  Address VARCHAR(50) NOT NULL,
  Phone VARCHAR(20) NOT NULL,
  Password NVARCHAR(255) NOT NULL,
  FName VARCHAR(50) NOT NULL,
  LName VARCHAR(50) NOT NULL,
  Role CHAR(1) NOT NULL,
  City VARCHAR(50) NOT NULL,
  Country VARCHAR(20) NOT NULL,
  Ssn INT NOT NULL,
  Gender CHAR(1) NOT NULL,
  PRIMARY KEY (personID),
  UNIQUE (Ssn),
  UNIQUE (Username),
  UNIQUE (Email)
);

CREATE TABLE Costumer
(
  Loyalty_Points INT DEFAULT 0,
  personID INT NOT NULL,
  FOREIGN KEY (personID) REFERENCES person(personID)
  ON DELETE CASCADE
  ON UPDATE CASCADE
);

CREATE TABLE Staff
(
  Job VARCHAR(30) NOT NULL,
  personID INT NOT NULL,
  FOREIGN KEY (personID) REFERENCES person(personID)
  ON DELETE CASCADE
  ON UPDATE CASCADE
);

CREATE TABLE Ship
(
  ShipID INT IDENTITY(1,1) NOT NULL,
  Name VARCHAR(20) NOT NULL,
  PRIMARY KEY (ShipID)
);

CREATE TABLE Cruise
(
  CruiseID INT IDENTITY(1,1) NOT NULL,
  Description VARCHAR(200) NOT NULL,
  EndDate DATE NOT NULL,
  StartDate DATE NOT NULL,
  Departure VARCHAR(20) NOT NULL,
  Destination VARCHAR(20) NOT NULL,
  ShipID INT NOT NULL DEFAULT 0,
  PRIMARY KEY (CruiseID),
  FOREIGN KEY (ShipID) REFERENCES Ship(ShipID)
  ON DELETE SET DEFAULT
  ON UPDATE CASCADE
);

CREATE TABLE CabinsOnShip
(
  Type INT NOT NULL,
  Price_Per_Night MONEY NOT NULL,
  CabinID INT IDENTITY(1,1) NOT NULL,
  ShipID INT NOT NULL,
  PRIMARY KEY (CabinID, ShipID),
  FOREIGN KEY (ShipID) REFERENCES Ship(ShipID)
  ON DELETE CASCADE
  ON UPDATE CASCADE

);

CREATE TABLE Payment
(
  PaymentID INT IDENTITY(1,1) NOT NULL,
  PayDate DATE NOT NULL,
  PayAmount MONEY NOT NULL,
  PRIMARY KEY (PaymentID)
);

CREATE TABLE Works_On
(
  personID INT NOT NULL,
  CruiseID INT NOT NULL,
  PRIMARY KEY (personID, CruiseID),
  FOREIGN KEY (personID) REFERENCES person(personID)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (CruiseID) REFERENCES Cruise(CruiseID)
  ON DELETE CASCADE
  ON UPDATE CASCADE
);

CREATE TABLE Booking
(
  BookingID INT IDENTITY(1,1) NOT NULL,
  BookingDate DATE NOT NULL,
  PaymentID INT,
  personID INT NOT NULL,
  CruiseID INT NOT NULL,
  PRIMARY KEY (BookingID),
  FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID)
  ON DELETE SET NULL
  ON UPDATE CASCADE,
  FOREIGN KEY (personID) REFERENCES person(personID)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (CruiseID) REFERENCES Cruise(CruiseID)
  ON DELETE CASCADE
  ON UPDATE CASCADE
);

CREATE TABLE Activity
(
  Capacity INT NOT NULL,
  Name VARCHAR(50) NOT NULL,
  Cost MONEY NOT NULL,
  Date DATE NOT NULL,
  ActivityID INT IDENTITY(1,1) NOT NULL,
  Description VARCHAR(150) NOT NULL,
  Time TIME NOT NULL,
  PaymentID INT,
  CruiseID INT NOT NULL,
  PRIMARY KEY (ActivityID),
  FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID)
  ON DELETE SET NULL
  ON UPDATE CASCADE,
  FOREIGN KEY (CruiseID) REFERENCES Cruise(CruiseID)
  ON DELETE CASCADE
  ON UPDATE CASCADE
);

CREATE TABLE Assigned_Cabins
(
  CabinID INT NOT NULL,
  ShipID INT NOT NULL,
  BookingID INT NOT NULL,
  PRIMARY KEY (CabinID, ShipID, BookingID),
  FOREIGN KEY (CabinID, ShipID) REFERENCES CabinsOnShip(CabinID, ShipID),
  FOREIGN KEY (BookingID) REFERENCES Booking(BookingID)
  ON DELETE CASCADE
  ON UPDATE CASCADE
);

CREATE TABLE Activity_Reservation
(
  Count INT NOT NULL,
  personID INT NOT NULL,
  ActivityID INT NOT NULL,
  PRIMARY KEY (personID, ActivityID),
  FOREIGN KEY (personID) REFERENCES person(personID)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  FOREIGN KEY (ActivityID) REFERENCES Activity(ActivityID)
  ON DELETE CASCADE
  ON UPDATE CASCADE
);

-- (Continue adding tuples up to 20 reservations)

SELECT 
    c.CruiseID AS Cruise_Number, 
    sh.Name AS ShipName, 
    c.Description, 
    c.EndDate, 
    c.StartDate, 
    c.Destination, 
    c.Departure, 
    MIN(CS.Price_Per_Night) AS MinPrice, 
    MAX(CS.Price_Per_Night) AS MaxPrice
FROM Cruise c
JOIN Ship sh ON sh.ShipID = c.ShipID
JOIN CabinsOnShip CS ON sh.ShipID = CS.ShipID
JOIN Activity a ON a.CruiseID = c.CruiseID
WHERE 1=1
AND c.Departure='Miami'
GROUP BY 
    c.CruiseID, 
    sh.Name, 
    c.Description, 
    c.EndDate, 
    c.StartDate, 
    c.Destination, 
    c.Departure
HAVING 
    MIN(CS.Price_Per_Night) < 200 
    AND COUNT(a.ActivityID) > 0 
ORDER BY sh.Name;



SELECT Departure
FROM Cruise
ORDER BY Departure


		"\r\n\r\nSELECT \r\n    c.CruiseID AS Cruise_Number, \r\n    sh.Name AS ShipName, \r\n    c.Description, \r\n    c.EndDate, \r\n    c.StartDate, \r\n    c.Destination, \r\n    c.Departure, \r\n    MIN(CS.Price_Per_Night) AS MinPrice, \r\n    MAX(CS.Price_Per_Night) AS MaxPrice\r\nFROM Cruise c\r\nJOIN Ship sh ON sh.ShipID = c.ShipID\r\nJOIN CabinsOnShip CS ON sh.ShipID = CS.ShipID\r\nWHERE 1=1  AND c.Departure = '0' AND c.Destination = '0'\r\n    GROUP BY \r\n        c.CruiseID, \r\n        sh.Name, \r\n        c.Description, \r\n        c.EndDate, \r\n        c.StartDate, \r\n        c.Destination, \r\n        c.DepartureHAVING\r\nMIN(CS.Price_Per_Night) < 0 ORDER BY sh.Name;"	string




SELECT	Destination
FROM Cruise
ORDER BY Destination



SELECT 
    c.CruiseID AS Cruise_Number, 
    sh.Name AS ShipName, 
    c.Description, 
    c.EndDate, 
    c.StartDate, 
    c.Destination, 
    c.Departure, 
    MIN(CS.Price_Per_Night) AS MinPrice, 
    MAX(CS.Price_Per_Night) AS MaxPrice
FROM Cruise c
JOIN Ship sh ON sh.ShipID = c.ShipID
JOIN CabinsOnShip CS ON sh.ShipID = CS.ShipID
JOIN Activity a ON a.CruiseID = c.CruiseID
WHERE 1=1  AND c.Departure = 'System.Data.DataRowView' AND c.Destination = 'System.Data.DataRowView'
    GROUP BY 
        c.CruiseID, 
        sh.Name, 
        c.Description, 
        c.EndDate, 
        c.StartDate, 
        c.Destination, 
        c.Departure
		HAVING
MIN(CS.Price_Per_Night) < 200 AND COUNT(a.ActivityID) > 0 
ORDER BY sh.Name;




SELECT 
    c.CruiseID AS Cruise_Number, 
    sh.Name AS ShipName, 
    c.Description, 
    c.EndDate, 
    c.StartDate, 
    c.Destination, 
    c.Departure, 
    MIN(CS.Price_Per_Night) AS MinPrice, 
    MAX(CS.Price_Per_Night) AS MaxPrice
FROM Cruise c
JOIN Ship sh ON sh.ShipID = c.ShipID
JOIN CabinsOnShip CS ON sh.ShipID = CS.ShipID
JOIN Activity a ON a.CruiseID = c.CruiseID
WHERE 1=1  AND c.Departure = 'System.Data.DataRowView' AND c.Destination = 'System.Data.DataRowView'

    GROUP BY 
        c.CruiseID, 
        sh.Name, 
        c.Description, 
        c.EndDate, 
        c.StartDate, 
        c.Destination, 
        c.Departure
		HAVING
MIN(CS.Price_Per_Night) < 200 AND COUNT(a.ActivityID) > 0 
ORDER BY sh.Name;




SELECT 
    c.CruiseID AS Cruise_Number, 
    sh.Name AS ShipName, 
    c.Description, 
    c.EndDate, 
    c.StartDate, 
    c.Destination, 
    c.Departure 
FROM Cruise c
JOIN Ship sh ON sh.ShipID = c.ShipID
WHERE 1=1  AND c.Departure = 'Seattle' AND c.Destination = 'Alaska'
    GROUP BY 
        c.CruiseID, 
        sh.Name, 
        c.Description, 
        c.EndDate, 
        c.StartDate, 
        c.Destination, 
        c.Departure
HAVING
COUNT(a.ActivityID) > 0 
ORDER BY sh.Name;







SELECT 
    c.CruiseID AS Cruise_Number, 
    sh.Name AS ShipName, 
    c.Description, 
    c.EndDate, 
    c.StartDate, 
    c.Destination, 
    c.Departure, 
    MIN(CS.Price_Per_Night) AS MinPrice, 
    MAX(CS.Price_Per_Night) AS MaxPrice
FROM Cruise c
JOIN Ship sh ON sh.ShipID = c.ShipID
JOIN CabinsOnShip CS ON sh.ShipID = CS.ShipID
WHERE 1=1  AND c.Departure = 'Athens' AND c.Destination = 'Santorini'

    GROUP BY 
        c.CruiseID, 
        sh.Name, 
        c.Description, 
        c.EndDate, 
        c.StartDate, 
        c.Destination, 
        c.Departure
ORDER BY sh.Name;