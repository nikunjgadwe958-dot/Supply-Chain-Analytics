use supplychain;

DROP TABLE IF EXISTS supply_chain;

CREATE TABLE supply_chain (
    `Type` VARCHAR(50),
    `Days for shipping (real)` INT,
    `Days for shipment (scheduled)` INT,
    `Benefit per order` DECIMAL(10,2),
    `Sales per customer` DECIMAL(10,2),
    `Delivery Status` VARCHAR(50),
    `Late_delivery_risk` TINYINT,
    `Category Id` INT,
    `Category Name` VARCHAR(100),
    `Customer City` VARCHAR(100),
    `Customer Country` VARCHAR(100),
    `Customer Fname` VARCHAR(100),
    `Customer Id` INT,
    `Customer Lname` VARCHAR(100),
    `Customer Segment` VARCHAR(50),
    `Customer State` VARCHAR(100),
    `Department Id` INT,
    `Department Name` VARCHAR(100),
    `Latitude` DECIMAL(10,6),
    `Longitude` DECIMAL(10,6),
    `Market` VARCHAR(100),
    `Order City` VARCHAR(100),
    `Order Country` VARCHAR(100),
    `order date (DateOrders)` DATETIME,
    `Order Id` INT,
    `Order Item Cardprod Id` INT,
    `Order Item Discount` DECIMAL(10,2),
    `Order Item Discount Rate` DECIMAL(10,4),
    `Order Item Id` INT,
    `Order Item Product Price` DECIMAL(10,2),
    `Order Item Profit Ratio` DECIMAL(10,6),
    `Order Item Quantity` INT,
    `Sales` DECIMAL(10,2),
    `Order Region` VARCHAR(100),
    `Order State` VARCHAR(100),
    `Order Status` VARCHAR(100),
    `Product Description` TEXT,
    `Product Name` VARCHAR(255),
    `Product Status` INT,
    `shipping date (DateOrders)` DATETIME,
    `Shipping Mode` VARCHAR(100),
    `Order Year` INT,
    `Order Quarter` VARCHAR(10),
    `Order Month Number` INT,
    `Order Month` VARCHAR(20),
    `Profit Margin(%)` DECIMAL(10,6),
    `Delivery Delay` INT,
    `Shipping Performance` VARCHAR(20)
);

-- Revenue, Profit and total orders by product category
SELECT
	Category_Name,
    ROUND(SUM(Sales_per_customer),2) As Revenue,
    ROUND(SUM(Benefit_per_order),2) AS Profit,
    COUNT(*) AS Orders
FROM supply_chain
GROUP BY Category_Name
ORDER BY Profit DESC;

-- Monthly revenue trend
SELECT 
	Order_Year,
    Order_Month_Number,
    ROUND(SUM(sales_per_customer),2) AS Revenue
FROM supply_chain
GROUP BY Order_Year, ORder_Month_Number
ORDER BY Order_Year, Order_Month_Number;

-- Products Generating above Average Revenue
SELECT
	Product_name,
    Round(SUM(Sales_per_Customer),2) AS Revenue
FROM supply_chain
GROUP BY Product_Name
HAVING SUM(Sales_per_customer) > 
	(SELECT AVG(Product_Revenue)
    FROM(
		SELECT SUM(Sales_per_customer) AS Product_Revenue
        FROM supply_chain
        GROUP BY Product_Name)
	AS Avg_Revenue)
ORDER BY Revenue DESC;

-- Rank Products by Profit within each Category

WITH Product_Profit AS(
SELECT
	Category_Name,
    Product_Name,
    ROUND(SUM(Benefit_per_order),2) AS Profit
FROM supply_chain
GROUP BY Category_Name, Product_Name
 ),
Ranked_Product AS (
SELECT *,
	RANK() OVER(PARTITION BY Category_Name ORDER BY Profit Desc) AS Profit_Rank
FROM Product_Profit)

SELECT
	Category_Name,
    Product_Name,
    Profit
FROM Ranked_Product
WHERE Profit_Rank = 1
ORDER BY Profit DESC;

-- Shipping performance by shipping mode
SELECT
	shipping_mode,
    COUNT(*) AS Orders,
    ROUND(AVG(Delivery_Delay),2) AS Avg_Delay,
	ROUND(SUM(Benefit_per_order),2) AS Profit
FROM supply_chain
GROUP BY Shipping_Mode
ORDER BY Avg_delay;

-- Month-over-month revenue comparison
WITH Monthly_Revenue AS(
	SELECT
		Order_Year,
        Order_Month_Number,
        ROUND(SUM(Sales_per_customer),2) AS Revenue
	FROM supply_chain
    GROUP BY Order_Year, Order_Month_Number
    )
SELECT
	Order_Year,
    Order_Month_Number,
    Revenue,
    LAG(Revenue) OVER(ORDER BY Order_Year, Order_Month_Number)
    AS Previous_Month_Revenue,
    ROUND(Revenue - LAG(Revenue) OVER(ORDER BY Order_Year, Order_Month_Number),2
    ) AS Revenue_Change
FROM Monthly_Revenue;

-- Revenue, profit and order dsitribution by customer segment
SELECT
	Customer_Segment,
    ROUND(SUM(Sales_Per_Customer),2) AS Revenue,
    ROUND(SUM(Benefit_Per_Order),2) AS Profit,
    COUNT(Order_Item_Quantity) AS Orders,
    ROUND(AVG(Sales_per_customer),2) AS Avg_Order_value
FROM supply_chain
GROUP BY Customer_Segment
ORDER BY Revenue DESC;

-- Categorize products based on total profit
SELECT
	Product_Name,
    ROUND(SUM(Benefit_Per_Order),2) AS Total_Profit,
	CASE
		WHEN SUM(Benefit_per_order) < 0 THEN "Loss-Making"
		WHEN SUM(Benefit_per_order) BETWEEN 0 and 500 THEN  "Low Profit"
		ELSE "High Profit"
	END AS Profit_Category
FROM supply_chain
GROUP BY Product_Name
ORDER BY Total_Profit DESC;

-- Create a reusable category performance view
CREATE VIEW vw_category_performance AS 
SELECT
	Category_Name,
    ROUND(SUM(Sales_per_customer),2) AS Revenue,
    ROUND(SUM(Benefit_per_order),2) AS Profit,
    COUNT(Order_Item_Quantity) AS Orders,
	ROUND(AVG(Sales_per_customer),2) AS Avg_Order_Value
FROM supply_chain
GROUP BY Category_Name;

-- Top 5 most profitable categories using the reusable view
SELECT
	Category_Name,
    Revenue,
    Profit,
    Avg_Order_Value
FROM vw_category_performance
ORDER BY Profit DESC
LIMIT 5;
