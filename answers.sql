-- TRANSFORMING THE TABLE INTO 1NF
WITH RECURSIVE split_products AS (
  SELECT 
    OrderID,
    CustomerName,
    TRIM(SUBSTRING_INDEX(Products, ',', 1)) AS Product,
    TRIM(SUBSTRING(Products, LENGTH(SUBSTRING_INDEX(Products, ',', 1)) + 2)) AS rest
  FROM ProductDetail

  UNION ALL

  SELECT 
    OrderID,
    CustomerName,
    TRIM(SUBSTRING_INDEX(rest, ',', 1)) AS Product,
    TRIM(SUBSTRING(rest, LENGTH(SUBSTRING_INDEX(rest, ',', 1)) + 2)) AS rest
  FROM split_products
  WHERE rest != ''
)

SELECT 
  OrderID,
  CustomerName,
  Product
FROM 
  split_products
ORDER BY 
  OrderID;


-- TRANSFORMING THE TABLE INTO 2NF WITHOUT DROPPING THE ORIGINAL TABLE
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insert data into the new tables
INSERT INTO Orders
SELECT DISTINCT OrderID, CustomerName FROM OrderDetails;

INSERT INTO OrderItems
SELECT OrderID, Product, Quantity FROM OrderDetails;

