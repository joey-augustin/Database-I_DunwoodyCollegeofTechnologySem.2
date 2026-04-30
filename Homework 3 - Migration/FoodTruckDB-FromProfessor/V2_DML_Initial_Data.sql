INSERT INTO Customers (FirstName, LastName, Email, Phone)
VALUES
('John', 'Doe', 'johndoe@notarealemail.com', '123-456-7890'),
('Jane', 'Doe', 'janedoe@notarealemail.com', '098-765-4321');
GO

INSERT INTO Ingredients (Name, UnitCost, InventoryCount)
VALUES
('Tortillas', 0.50, 12),
('Tofu', 0.30, 30)
;
GO

INSERT INTO Recipes (Name, Price)
VALUES
('Taco', 1.50)
;
GO

INSERT INTO RecipeIngredients (Recipe, Ingredient, Amount)
VALUES
(
	(SELECT RecipeID from Recipes WHERE Name='Taco'), 
	(SELECT IngredientID FROM Ingredients WHERE Name='Tortillas'),
	2.0
),
(
	(SELECT RecipeID from Recipes WHERE Name='Taco'), 
	(SELECT IngredientID FROM Ingredients WHERE Name='Tofu'),
	3.0
)
GO

INSERT INTO Orders (CustomerID, TotalPrice)
VALUES (1, 1.50);
GO

INSERT INTO LineItem (OrderID, RecipeID, Quantity)
VALUES (1, 1, 1);
GO