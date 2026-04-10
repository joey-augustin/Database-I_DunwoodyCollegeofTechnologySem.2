# EXISTING DATABASE SCRIPT - SEE LINE 784 FOR THE BEGINNING OF MY CLEANUP!

CREATE SCHEMA `bookstore`;

DROP DATABASE IF EXISTS BookStore;


CREATE DATABASE BookStore;


USE BookStore;


CREATE TABLE Book(
  BookID INT AUTO_INCREMENT PRIMARY KEY,
  Title VARCHAR(150) NOT NULL,
  PublicationYear INT,
  Publisher VARCHAR(100),
  CountOfPages INT,
  Genre VARCHAR(20) NOT NULL,
  Subgenre VARCHAR(100),
  Edition INT DEFAULT 1,
  MSRP DECIMAL(10, 2) NOT NULL DEFAULT 0,
  Stock INT NOT NULL DEFAULT 0
);


CREATE TABLE Author(
  AuthorID INT AUTO_INCREMENT PRIMARY KEY,
  Title VARCHAR(100),
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(100) NOT NULL,
  Gender VARCHAR(30),
  DateOfBirth DATE,
  DateOfDeath DATE
);


CREATE TABLE BookAuthor(
  BookAuthorID INT AUTO_INCREMENT PRIMARY KEY,
  BookID INT,
  AuthorID INT,
  CONSTRAINT FK_Book_BookID FOREIGN KEY(BookID) REFERENCES Book(BookID),
  CONSTRAINT FK_Author_AuthorID FOREIGN KEY(AuthorID) REFERENCES Author(AuthorID)
);


-- Create Customer Table
CREATE TABLE Customer(
  CustomerID INT AUTO_INCREMENT PRIMARY KEY,
  FirstName VARCHAR(50) NOT NULL,
  LastName VARCHAR(150) NOT NULL,
  BillingAddress VARCHAR(200) NOT NULL,
  DeliveryAddress VARCHAR(200) NOT NULL,
  PhoneNumber VARCHAR(30),
  EmailAddress VARCHAR(320),
  Username VARCHAR(30),
  UserPassword VARCHAR(500),
  IsEducator BIT DEFAULT 0
);


-- Create PaymentMethod table
CREATE TABLE PaymentMethod(
  PaymentMethodID INT AUTO_INCREMENT PRIMARY KEY,
  CardNumber VARCHAR(30) NOT NULL,
  CardHolderName VARCHAR(100) NOT NULL,
  CVV INT NOT NULL,
  ExpMonth INT NOT NULL,
  ExpYear INT NOT NULL
);


-- Create CustomerPaymentMethod
CREATE TABLE CustomerPaymentMethod(
  CustomerPaymentMethodID INT AUTO_INCREMENT PRIMARY KEY,
  CustomerID INT NOT NULL,
  PaymentMethodID INT NOT NULL,
  FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID),
  FOREIGN KEY(PaymentMethodID) REFERENCES PaymentMethod(PaymentMethodID)
);


-- Create Orders table
CREATE TABLE Orders(
  OrderID INT AUTO_INCREMENT PRIMARY KEY,
  CustomerID INT NOT NULL,
  TimeOfOrder DATETIME NOT NULL DEFAULT NOW(),
  TimeOfDelivery DATETIME,
  TotalPrice DECIMAL(10, 2),
  PaymentMethodID INT,
  CONSTRAINT FK_Orders_PaymentMethodID FOREIGN KEY(PaymentMethodID) REFERENCES PaymentMethod(PaymentMethodID)
);


-- Create LineItem table
CREATE TABLE LineItem(
  LineItemID INT AUTO_INCREMENT PRIMARY KEY,
  BookID INT NOT NULL,
  OrderID INT NOT NULL,
  Quantity INT DEFAULT 1,
  TotalPrice DECIMAL(10, 2) NOT NULL
);


-- Inserting some books
INSERT INTO
  Book(
    Title,
    PublicationYear,
    Publisher,
    CountOfPages,
    Genre,
    Subgenre,
    MSRP
  )
VALUES
  (
    'The Lord of the Rings: Fellowship of the Ring',
    1954,
    'George Allen & Unwin',
    423,
    'Fantasy',
    '',
    19.99
  ),
  (
    'The Lord of the Rings: The Two Towers',
    1954,
    'George Allen & Unwin',
    352,
    'Fantasy',
    '',
    19.99
  ),
  (
    'The Lord of the Rings: The Return of the King',
    1955,
    'George Allen & Unwin',
    416,
    'Fantasy',
    '',
    19.99
  ),
  (
    'Dune',
    1963,
    'Chilton Books',
    412,
    'Science Fiction',
    '',
    19.99
  ),
  (
    'Dune Messiah',
    1969,
    'Putnam Publishing',
    256,
    'Science Fiction',
    '',
    19.99
  ),
  (
    'Children of Dune',
    1976,
    'Putnam',
    444,
    'Science Fiction',
    '',
    19.99
  ),
  (
    'The Hunger Games',
    2008,
    'Scholastic Press',
    374,
    'Adventure',
    'Science Fiction',
    14.99
  ),
  (
    'Catching Fire',
    2009,
    'Scholastic',
    391,
    'Dystopian',
    'Science Fiction',
    14.99
  ),
  (
    'Mockingjay',
    2010,
    'Scholastic',
    390,
    'Adventure',
    'Science Fiction',
    14.99
  ),
  (
    'The Ballad of Songbirds and Snakes',
    2020,
    'Scholastic',
    517,
    'Adventure',
    'Science Fiction',
    14.99
  );


-- Inserting some authors
INSERT INTO
  Author(FirstName, LastName, DateOfBirth, DateOfDeath)
VALUES
  ('J. R. R.', 'Tolkein', '1892-01-03', '1973-09-02'),
  ('Frank', 'Herbert', '1920-10-08', '1986-02-11'),
  ('Suzanne', 'Collins', '1962-08-10', NULL);


-- Creating some book-to-author relationships
INSERT INTO
  BookAuthor(BookID, AuthorID)
VALUES
  (1, 1),
  (2, 1),
  (3, 1),
  (4, 2),
  (5, 2),
  (6, 2),
  (7, 3),
  (8, 3),
  (9, 3),
  (10, 3);


-- Create an Order in the Orders table.
-- We need a customer because Orders table references a CustomerID
-- Create a Customer
INSERT INTO
  Customer(
    FirstName,
    LastName,
    BillingAddress,
    DeliveryAddress,
    PhoneNumber,
    EmailAddress,
    Username,
    UserPassword,
    IsEducator
  )
VALUES
  (
    'John',
    'Smith',
    '123 Olive St., Minneapolis, MN 55408',
    '123 Olive St., Minneapolis, MN 55408',
    '123-456-7890',
    '',
    '',
    '',
    0
  ),
  (
    'Tina',
    'Anderson',
    '1010 Willow St., Minneapolis, MN 55408',
    '1010 Willow St., Minneapolis, MN 55408',
    '123-456-7890',
    '',
    '',
    '',
    0
  ),
  (
    'Marcus',
    'Aurelius',
    '101 Roman Way, Rome, NY 13440',
    '101 Roman Way, Rome, NY 13440',
    '555-0101',
    'marcus.a@example.com',
    'maurelius',
    '$2y$10$Y1rxyzT8P9Aq...mockhash1',
    0
  ),
  (
    'Marie',
    'Curie',
    '456 Radium Rd, Paris, TX 75460',
    'Science Dept, University, Paris, TX 75460',
    '555-0102',
    'mcurie@science.edu',
    'mcurie',
    '$2y$10$X2sabcU9Q0Br...mockhash2',
    1
  ),
  (
    'Arthur',
    'Dent',
    '789 Bypass Blvd, London, OH 43140',
    '789 Bypass Blvd, London, OH 43140',
    '555-0103',
    'arthur.dent@galaxy.net',
    'adent',
    '$2y$10$W3tbcdV0R1Cs...mockhash3',
    0
  ),
  (
    'Ada',
    'Lovelace',
    '202 Engine Ave, Boston, MA 02110',
    '202 Engine Ave, Boston, MA 02110',
    '555-0104',
    'ada@computing.org',
    'alovelace',
    '$2y$10$V4ucdeW1S2Dt...mockhash4',
    1
  ),
  (
    'Bruce',
    'Wayne',
    '1007 Mountain Drive, Gotham, NJ 07001',
    'Wayne Enterprises, Gotham, NJ 07001',
    '555-0105',
    'bwayne@wayne-enterprises.com',
    'bwayne',
    '$2y$10$U5vdefX2T3Eu...mockhash5',
    0
  ),
  (
    'Diana',
    'Prince',
    '300 Embassy Row, Washington, DC 20008',
    '300 Embassy Row, Washington, DC 20008',
    '555-0106',
    'diana.prince@museum.gov',
    'dprince',
    '$2y$10$T6wefgY3U4Fv...mockhash6',
    0
  ),
  (
    'Richard',
    'Feynman',
    '404 Quantum Ln, Pasadena, CA 91125',
    '404 Quantum Ln, Pasadena, CA 91125',
    '555-0107',
    'rfeynman@caltech.edu',
    'rfeynman',
    '$2y$10$S7xfghZ4V5Gw...mockhash7',
    1
  ),
  (
    'Grace',
    'Hopper',
    '505 Navy Blvd, Arlington, VA 22202',
    '505 Navy Blvd, Arlington, VA 22202',
    '555-0108',
    'ghopper@navy.mil',
    'ghopper',
    '$2y$10$R8yghiA5W6Hx...mockhash8',
    1
  ),
  (
    'Tony',
    'Stark',
    '10880 Malibu Point, Malibu, CA 90265',
    'Stark Tower, New York, NY 10001',
    '555-0109',
    'tony@starkindustries.com',
    'tstark',
    '$2y$10$Q9zhijB6X7Iy...mockhash9',
    0
  ),
  (
    'Katherine',
    'Johnson',
    '606 Orbit Way, Hampton, VA 23666',
    '606 Orbit Way, Hampton, VA 23666',
    '555-0110',
    'kjohnson@space.gov',
    'kjohnson',
    '$2y$10$P0aijkC7Y8Jz...mockhash10',
    1
  );


-- After adding PaymentMethodID to the Orders table and making it a Foreign Key,
-- We now also need a PaymentMethod record
INSERT INTO
  PaymentMethod(
    CardNumber,
    CardHolderName,
    CVV,
    ExpMonth,
    ExpYear
  )
VALUES
  (
    '4444 2222 3333 4444',
    'John Smith',
    100,
    02,
    2029
  ),
  (
    '1111 3333 4444 5555',
    'Tina Anderson',
    565,
    04,
    2027
  ),
  (
    '1111 2222 3333 4444',
    'Marcus Aurelius',
    123,
    10,
    2028
  ),
  (
    '2222 3333 4444 5555',
    'Marie Curie',
    456,
    11,
    2027
  ),
  (
    '3333 4444 5555 6666',
    'Arthur Dent',
    789,
    5,
    2029
  ),
  (
    '4444 5555 6666 7777',
    'Ada Lovelace',
    321,
    12,
    2030
  ),
  (
    '5555 6666 7777 8888',
    'Bruce Wayne',
    654,
    8,
    2031
  ),
  (
    '6666 7777 8888 9999',
    'Diana Prince',
    987,
    3,
    2028
  ),
  (
    '7777 8888 9999 0000',
    'Richard Feynman',
    147,
    7,
    2026
  ),
  (
    '8888 9999 0000 1111',
    'Grace Hopper',
    258,
    9,
    2029
  ),
  (
    '9999 0000 1111 2222',
    'Tony Stark',
    369,
    10,
    2032
  ),
  (
    '0000 1111 2222 3333',
    'Katherine Johnson',
    741,
    1,
    2027
  );


-- Link the customers to the payment methods
INSERT INTO
  CustomerPaymentMethod(CustomerID, PaymentMethodID)
VALUES
  (1, 1),
  (2, 2),
  (3, 3),
  (4, 4),
  (5, 5),
  (6, 6),
  (7, 7),
  (8, 8),
  (9, 9),
  (10, 10),
  (11, 11),
  (12, 12);


-- Now we can create the Order because all of our FK constraints will be satisfied
INSERT INTO
  Orders(
    CustomerID,
    TimeOfOrder,
    TimeOfDelivery,
    TotalPrice,
    PaymentMethodID
  )
VALUES
  (
    1,
    '2026-02-01 09:15:00',
    '2026-02-04 14:30:00',
    40.00,
    1
  ),
  (
    2,
    '2026-02-02 11:20:00',
    '2026-02-05 10:15:00',
    20.00,
    2
  ),
  (
    1,
    '2026-03-01 09:15:00',
    '2026-03-04 14:30:00',
    40.00,
    1
  ),
  (
    2,
    '2026-03-02 11:20:00',
    '2026-03-05 10:15:00',
    20.00,
    2
  ),
  (
    3,
    '2026-03-05 14:45:00',
    '2026-03-08 09:00:00',
    45.50,
    3
  ),
  (
    4,
    '2026-03-10 16:30:00',
    '2026-03-13 11:45:00',
    30.00,
    4
  ),
  (
    5,
    '2026-03-12 08:00:00',
    '2026-03-15 13:20:00',
    58.00,
    5
  ),
  (
    6,
    '2026-03-15 19:10:00',
    '2026-03-18 15:50:00',
    42.00,
    6
  ),
  (
    7,
    '2026-03-20 12:25:00',
    '2026-03-23 16:10:00',
    76.00,
    7
  ),
  (
    8,
    '2026-03-22 10:05:00',
    '2026-03-25 10:30:00',
    27.50,
    8
  ),
  (
    9,
    '2026-03-25 14:55:00',
    '2026-03-28 12:00:00',
    50.00,
    9
  ),
  (
    10,
    '2026-03-26 09:40:00',
    '2026-03-29 11:00:00',
    54.00,
    10
  ),
  (
    11,
    '2026-03-27 11:15:00',
    '2026-03-30 14:20:00',
    50.00,
    11
  ),
  (
    12,
    '2026-03-28 15:30:00',
    '2026-03-31 09:30:00',
    35.00,
    12
  ),
  (1, '2026-03-29 08:45:00', NULL, 25.00, 1),
  (2, '2026-03-29 13:10:00', NULL, 33.00, 2),
  (3, '2026-03-30 10:05:00', NULL, 30.00, 3),
  (4, '2026-03-30 14:50:00', NULL, 43.00, 4),
  (5, '2026-03-31 09:15:00', NULL, 22.00, 5),
  (6, '2026-03-31 11:30:00', NULL, 54.00, 6),
  (9, '2026-03-31 12:45:00', NULL, 12.50, 9),
  (12, '2026-03-31 13:20:00', NULL, 41.00, 12);


-- Add LineItem records to our Order
INSERT INTO
  LineItem(BookID, OrderID, Quantity, TotalPrice)
VALUES
  (4, 1, 2, 19.99 * 2),
  (5, 1, 1, 19.99),
  (6, 1, 1, 19.99),
  (7, 2, 1, 14.99),
  (3, 1, 1, 10.00),
  (3, 2, 2, 30.00),
  (4, 3, 1, 20.00),
  (5, 4, 1, 12.50),
  (5, 5, 1, 8.00),
  (5, 6, 1, 25.00),
  (6, 7, 1, 30.00),
  (7, 8, 2, 36.00),
  (7, 9, 1, 22.00),
  (8, 10, 3, 42.00),
  (9, 1, 1, 10.00),
  (9, 3, 1, 20.00),
  (9, 5, 2, 16.00),
  (9, 7, 1, 30.00),
  (10, 2, 1, 15.00),
  (10, 4, 1, 12.50),
  (11, 6, 2, 50.00),
  (12, 8, 1, 18.00),
  (12, 9, 1, 22.00),
  (12, 10, 1, 14.00),
  (13, 1, 5, 50.00),
  (14, 2, 1, 15.00),
  (14, 3, 1, 20.00),
  (15, 4, 2, 25.00),
  (16, 5, 1, 8.00),
  (16, 6, 1, 25.00),
  (17, 7, 1, 30.00),
  (18, 8, 1, 18.00),
  (18, 1, 1, 10.00),
  (18, 2, 1, 15.00),
  (19, 9, 1, 22.00),
  (20, 10, 1, 14.00),
  (20, 3, 2, 40.00),
  (21, 4, 1, 12.50),
  (22, 5, 2, 16.00),
  (22, 6, 1, 25.00);


-- View: Customer Order Summary 
CREATE VIEW vw_CustomerOrderSummary AS
SELECT
  c.CustomerID,
  CONCAT(c.FirstName, ' ', c.LastName) AS FullName,
  c.EmailAddress,
  c.IsEducator,
  COUNT(o.OrderID) AS TotalOrders,
  COALESCE(SUM(o.TotalPrice), 0.00) AS TotalLifetimeSpent
FROM
  Customer c
  LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY
  c.CustomerID,
  FullName,
  c.EmailAddress,
  c.IsEducator;


SELECT
  CustomerID,
  FullName,
  EmailAddress,
  IsEducator,
  TotalOrders,
  TotalLifetimeSpent
FROM
  vw_CustomerOrderSummary;


-- View: Fulfillment Queue
CREATE VIEW vw_FulfillmentQueue AS
SELECT
  o.OrderID,
  o.TimeOfOrder,
  CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
  c.DeliveryAddress,
  o.TotalPrice AS OrderValue
FROM
  Orders o
  JOIN Customer c ON o.CustomerID = c.CustomerID
WHERE
  o.TimeOfDelivery IS NULL
ORDER BY
  o.TimeOfOrder ASC;


SELECT
  OrderID,
  TimeOfOrder,
  CustomerName,
  DeliveryAddress,
  OrderValue
FROM
  vw_FulfillmentQueue;


-- View: Book Sales Analytics
CREATE VIEW vw_BookSalesAnalytics AS
SELECT
  li.BookID,
  COUNT(DISTINCT li.OrderID) AS NumberOfOrders,
  SUM(li.Quantity) AS TotalUnitsSold,
  SUM(li.TotalPrice) AS TotalRevenueGenerated
FROM
  LineItem li
GROUP BY
  li.BookID
ORDER BY
  TotalRevenueGenerated DESC;


SELECT
  BookID,
  NumberOfOrders,
  TotalUnitsSold,
  TotalRevenueGenerated
FROM
  vw_BookSalesAnalytics;


-- View: Comprehensive Order Receipt
CREATE VIEW vw_ComprehensiveOrderDetails AS
SELECT
  o.OrderID,
  o.TimeOfOrder,
  CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
  c.EmailAddress,
  pm.CardHolderName AS BilledTo,
  RIGHT(pm.CardNumber, 4) AS CardLastFour,
  o.TotalPrice AS OrderTotal,
  SUM(li.Quantity) AS TotalItemsInOrder
FROM
  Orders o
  JOIN Customer c ON o.CustomerID = c.CustomerID
  JOIN PaymentMethod pm ON o.PaymentMethodID = pm.PaymentMethodID
  JOIN LineItem li ON o.OrderID = li.OrderID
GROUP BY
  o.OrderID,
  o.TimeOfOrder,
  CustomerName,
  c.EmailAddress,
  BilledTo,
  CardLastFour,
  OrderTotal;


SELECT
  OrderID,
  TimeOfOrder,
  CustomerName,
  EmailAddress,
  BilledTo,
  CardLastFour,
  OrderTotal,
  TotalItemsInOrder
FROM
  vw_ComprehensiveOrderDetails;
  
  
 -- =================
 -- BOOKSTORE CLEANUP
 -- =================
  
-- INDEXES (improving query performance by optimizing WHERE, ORDER BY, and JOIN operations)
  
  Create INDEX lineItem_orderID
  ON LineItem(OrderID);
  
  CREATE INDEX orders_customerID
  ON Orders(CustomerID);
  
  CREATE INDEX orders_timeOfDelivery
  ON Orders(TimeOfDelivery);
  
  CREATE INDEX orders_timeOfOrder
  ON Orders(TimeOfOrder);
  -- The "Time Of Order" index will speed up queries by sorting order in a specific time range by when they were placed, 
  -- rather than checking every row in the Orders table.
  
  
-- ROLES (defining roles-based access levels to enforce database security)

CREATE ROLE 'dbAdministrator';
CREATE ROLE 'shopClerk';
CREATE ROLE 'inventoryManager';
CREATE ROLE 'stockCheckerApp';
CREATE ROLE 'customerSupport';


-- ROLE PERMISSIONS (assigning permissions to enforce proper access for each role)

GRANT ALL PRIVILEGES ON BookStore.* TO 'dbAdministrator';

GRANT SELECT, INSERT, UPDATE ON BookStore.Orders TO 'shopClerk';
GRANT SELECT, INSERT, UPDATE ON BookStore.LineItem TO 'shopClerk';
GRANT SELECT ON BookStore.Customer TO 'shopClerk';
GRANT SELECT ON BookStore.Book TO 'shopClerk';

GRANT SELECT, INSERT, UPDATE, DELETE ON BookStore.Book TO 'inventoryManager';
GRANT SELECT ON BookStore.LineItem TO 'inventoryManager';

GRANT SELECT ON BookStore.Book TO 'stockCheckerApp';

GRANT SELECT ON BookStore.Customer TO 'customerSupport';
GRANT SELECT ON BookStore.Orders TO 'customerSupport';
-- This would be a role that customers ask questions to about orders, but would not necessarily be modifying anyting in the database.
-- This is why they will have read-only access, and have that access for customers and for orders.


-- USERS (creating local users for the roles)

CREATE USER 'adminUser'@'localhost' IDENTIFIED BY 'Admin123';
CREATE USER 'clerkUser'@'localhost' IDENTIFIED BY 'Clerk123';
CREATE USER 'managerUser'@'localhost' IDENTIFIED BY 'Manager123';
CREATE USER 'appUser'@'localhost' IDENTIFIED BY 'App123';
CREATE USER 'supportUser'@'localhost' IDENTIFIED BY 'Support123';


-- ASSIGN ROLES (connecting the users to their roles)

GRANT 'dbAdministrator' TO 'adminUser'@'localhost';
GRANT 'shopClerk' TO 'clerkUser'@'localhost';
GRANT 'inventoryManager' TO 'managerUser'@'localhost';
GRANT 'stockCheckerApp' TO 'appUser'@'localhost';
GRANT 'customerSupport' TO 'supportUser'@'localhost';


-- SET DEFAULT ROLES (ensuring each user automatically assumes their assigned role at login)

SET DEFAULT ROLE 'dbAdministrator' TO 'adminUser'@'localhost';
SET DEFAULT ROLE 'shopClerk' TO 'clerkUser'@'localhost';
SET DEFAULT ROLE 'inventoryManager' TO 'managerUser'@'localhost';
SET DEFAULT ROLE 'stockCheckerApp' TO 'appUser'@'localhost';
SET DEFAULT ROLE 'customerSupport' TO 'supportUser'@'localhost';