-- =====================
-- FOOD TRUCK MIGRATION
-- =====================


USE foodtruck;
GO


-- NEW TABLE: FoodTrucks
-- Stores information about each individual food truck in the fleet.

CREATE TABLE FoodTrucks(
  TruckID INT IDENTITY(1,1) NOT NULL,
  Name VARCHAR(100) NOT NULL,
  LicensePlate VARCHAR(20),
  Location VARCHAR(200),
  IsActive BIT DEFAULT 1 NOT NULL,
  CONSTRAINT PK_FoodTrucks PRIMARY KEY (TruckID)
);
GO


-- NEW TABLE: TruckInventory
-- Tracks ingredient stock levels per truck, so each truck can have its own inventory separate from the global Ingredients catalog.

CREATE TABLE TruckInventory(
  TruckID INT NOT NULL,
  IngredientID INT NOT NULL,
  StockCount INT NOT NULL DEFAULT 0,
  CONSTRAINT PK_TruckInventory PRIMARY KEY (TruckID, IngredientID),
  CONSTRAINT FK_TruckInventory_TruckID FOREIGN KEY (TruckID) REFERENCES FoodTrucks(TruckID),
  CONSTRAINT FK_TruckInventory_IngredientID FOREIGN KEY (IngredientID) REFERENCES Ingredients(IngredientID)
);
GO


-- ALTER TABLE: Orders
-- Adding TruckID so every order can be traced back to the truck that made it. 

ALTER TABLE Orders
  ADD TruckID INT NULL;
GO


-- Inserting our two starter trucks.

SET IDENTITY_INSERT FoodTrucks ON;

INSERT INTO
  FoodTrucks(TruckID, Name, LicensePlate, Location, IsActive)
VALUES
  (1, 'Truck One', 'ABC-123', 'St. Paul', 1),
  (2, 'Truck Two', 'JKA-606', 'Minneapolis', 1);

SET IDENTITY_INSERT FoodTrucks OFF;
GO


-- Backfill all existing orders to Truck One since they predate the addition of a second food truck.

UPDATE Orders
SET TruckID = 1
WHERE TruckID IS NULL;
GO


-- Now that all rows have a value, make the column not null and add the foreign key constraint.

ALTER TABLE Orders
  ALTER COLUMN TruckID INT NOT NULL;
GO

ALTER TABLE Orders
  ADD CONSTRAINT FK_Orders_TruckID FOREIGN KEY (TruckID) REFERENCES FoodTrucks(TruckID);
GO


-- Give each truck a starting inventory based on the current ingredients list.

INSERT INTO
  TruckInventory(TruckID, IngredientID, StockCount)
SELECT
  t.TruckID,
  i.IngredientID,
  i.InventoryCount
FROM FoodTrucks t
CROSS JOIN Ingredients i;
GO


-- View sales by truck. Shows total orders, total revenue, and total items sold broken down by truck.

CREATE VIEW vw_SalesByTruck AS
SELECT
  ft.TruckID,
  ft.Name AS TruckName,
  COUNT(DISTINCT o.OrderID) AS TotalOrders,
  SUM(o.TotalPrice) AS TotalRevenue,
  SUM(li.Quantity) AS TotalItemsSold
FROM FoodTrucks ft
  JOIN Orders o ON ft.TruckID = o.TruckID
  JOIN LineItem li ON o.OrderID = li.OrderID
GROUP BY
  ft.TruckID,
  ft.Name;
GO


-- View inventory by truck. Shows the current stock level and total stock value for each ingredient per truck.

CREATE VIEW vw_InventoryByTruck AS
SELECT
  ft.TruckID,
  ft.Name AS TruckName,
  i.IngredientID,
  i.Name AS IngredientName,
  i.UnitCost,
  ti.StockCount,
  (ti.StockCount * i.UnitCost) AS StockValue
FROM FoodTrucks ft
  JOIN TruckInventory ti ON ft.TruckID = ti.TruckID
  JOIN Ingredients i ON ti.IngredientID = i.IngredientID;
GO