USE supplychain;
DESCRIBE supply_chain; 

-- Revenue, Profit and total orders by product category
SELECT
	Category_Name,
    ROUND(SUM(Sales_per_customer),2) As Revenue,
    ROUND(SUM(Sales_per_customer) / COUNT(*), 2) AS Avg_Order_Value,
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
    COUNT(*) AS Orders,
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
    COUNT(*) AS Orders,
	ROUND(AVG(Sales_per_customer),2) AS Avg_Order_Value
FROM supply_chain
GROUP BY Category_Name;

SELECT * FROM vw_category_performance;

-- Top 5 most profitable categories using the reusable view
SELECT
	Category_Name,
    Revenue,
    Profit,
    Avg_Order_Value
FROM vw_category_performance
ORDER BY Profit DESC
LIMIT 5;

-- Categories Ranked by Profit Percentage
SELECT
    Category_Name,
    ROUND(SUM(Sales_per_customer),2) AS Revenue,
    ROUND(SUM(Benefit_per_order),2) AS Profit,
    ROUND((SUM(Benefit_per_order) / SUM(Sales_per_customer)) * 100,2) AS Profit_Margin_Percent
FROM supply_chain
GROUP BY Category_Name
ORDER BY Profit_Margin_Percent DESC;