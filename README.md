# Supply Chain Analytics

An end-to-end supply chain analytics project that transforms raw transactional data into actionable business insights across revenue, profitability, product performance, customer segments, markets, and logistics operations.

The project follows a complete analytics workflow:

**Data Audit & Cleaning → Data Transformation & EDA → SQL Business Analysis → Power BI Dashboard**

---

## Project Overview

The objective of this project is to analyze supply chain transaction data and identify patterns in business performance, product profitability, customer behavior, market performance, and shipping operations.

The project uses Python for data preparation and exploratory analysis, MySQL for structured business analysis and validation, and Power BI for interactive dashboard development.

The final analytical dataset contains:

**180,519 records**

---

# 1. Data Preparation & Exploratory Analysis — Python

Python was used as the first stage of the project to inspect, clean, transform, validate, and explore the raw dataset before loading the processed data into MySQL.

### Data Audit

The raw dataset was initially analyzed using Pandas to understand its structure and data quality.

The analysis included:

- Inspecting dataset dimensions
- Reviewing column names and data types
- Checking missing values
- Calculating missing-value percentages
- Checking duplicate records
- Reviewing numerical distributions
- Analyzing categorical values
- Identifying potential data-quality issues
- Checking numerical fields for invalid negative values

### Data Cleaning

Several data-quality issues and redundant fields were investigated and addressed.

The cleaning process included:

- Investigating missing geographic information
- Removing unnecessary geographic fields
- Handling missing customer last names by replacing null values with `Unknown`
- Comparing related customer fields before removing redundant columns
- Validating customer and product attributes
- Investigating duplicate and equivalent fields
- Removing unnecessary fields that were not required for the final analysis
- Removing sensitive or irrelevant customer information
- Reducing the dataset to the fields required for SQL analysis and Power BI

### Date Transformation

Order and shipping date fields were converted from text to datetime format.

Additional analytical date fields were created:

- Order Year
- Order Quarter
- Order Month Number
- Order Month

These fields were later used for time-based analysis and the Power BI date model.

### Feature Engineering

Python was used to create business-focused analytical features.

#### Profit Margin

Profit margin was calculated using benefit per order and sales per customer.

#### Delivery Delay

Delivery delay was calculated by comparing actual shipping days against scheduled shipping days.

A delivery-performance classification was then created:

- Early
- On Time
- Late

### Exploratory Data Analysis

Python was used to investigate:

- Revenue by product category
- Profit by product category
- Monthly revenue trends
- Top products by revenue
- Revenue by customer segment
- Shipping performance by shipping mode

### Data Validation

Related fields were compared before removal to verify whether they contained duplicate or equivalent information.

Examples included comparisons involving:

- Order profit and benefit per order
- Category identifiers
- Customer identifiers
- Product/card identifiers
- Product prices
- Customer-related fields

This validation helped ensure that removing redundant fields would not eliminate required analytical information.

### Dataset Optimization

The final dataset was intentionally reduced to the fields required for analysis and dashboard development.

This reduced unnecessary data loading and helped keep the Power BI model lightweight.

The processed dataset was exported for database ingestion.

---

# 2. SQL Business Analysis — MySQL

The cleaned dataset was loaded into MySQL for structured business analysis and validation.

SQL was used to answer key business questions and generate the metrics used throughout the project.

### Revenue & Profitability Analysis

Analysis included:

- Revenue, profit, and orders by product category
- Products generating above-average revenue
- Most profitable product within each category
- Product-level profit categorization
- Top profitable categories
- Category-level profit margin analysis

### Time-Based Analysis

Monthly revenue analysis was performed to identify revenue trends across the available years.

A month-over-month revenue comparison was also created using SQL window functions.

### Customer Analysis

Customer segment performance was analyzed using:

- Revenue
- Profit
- Order volume
- Average order value

The analysis compared:

- Consumer
- Corporate
- Home Office

### Shipping & Logistics Analysis

Shipping performance was analyzed across:

- Standard Class
- Same Day
- First Class
- Second Class

Metrics included:

- Order volume
- Average delivery delay
- Profit
- Delivery performance

### SQL Techniques Used

The project demonstrates the use of:

- `SELECT`
- `WHERE`
- `GROUP BY`
- `HAVING`
- `ORDER BY`
- Aggregate functions
- Subqueries
- Common Table Expressions (CTEs)
- Window functions
- `LAG()`
- `RANK()`
- `CASE`
- SQL Views

A reusable category-performance view was also created to simplify repeated analysis.

---

# 3. Power BI Dashboard

The final analysis was developed into a three-page interactive Power BI dashboard.

The dashboard uses a lightweight analytical dataset and a dedicated date dimension.

### Data Model

The Power BI model contains:

- `Fact_Supply_Chain`
- `Dim_Date`

The date dimension is connected to the fact table through the order date.

### Page 1 — Executive Overview

Provides a high-level view of overall business performance.

Key metrics and visuals include:

- Total Revenue
- Total Orders
- Total Profit
- Revenue Trend
- Top 5 Revenue Categories
- Revenue by Customer Segment
- Profit by Customer Segment

Interactive filters include:

- Year
- Market
- Customer Segment
- Shipping Mode

### Page 2 — Product & Category Performance

Focuses on product and category-level performance.

Key visuals include:

- Top Products by Revenue
- Top Products by Profit
- Top Revenue Categories
- Highest Profit Margin Category
- Top Categories by Profit Margin
- Revenue vs Profit by Product

The revenue-versus-profit scatter plot provides a product-level view of the relationship between commercial performance and profitability.

### Page 3 — Customer & Logistics Analysis

Focuses on market, customer, and shipping performance.

Key visuals include:

- Revenue by Market
- Orders by Shipping Performance
- Orders by Customer Segment
- Delivery Delay Distribution
- Customer and logistics KPIs

Interactive filters include:

- Year
- Market
- Customer Segment
- Shipping Mode

---

# 4. Key Business Findings

The analysis identified several notable patterns.

### Category Performance

- **Fishing** is the highest-revenue and highest-profit category.
- **Cleats** and **Camping & Hiking** are also major contributors to revenue and profit.
- Several high-revenue categories also demonstrate strong absolute profitability.

### Product Performance

- **Field & Stream Sportsman 16 Gun Fire Safe** is the highest-revenue and highest-profit product in the analyzed dataset.
- Several products generate substantially higher revenue than the average product.
- Product profitability varies considerably across the portfolio.

### Customer Segments

- **Consumer** customers generate the largest share of revenue.
- Corporate and Home Office segments contribute significant additional revenue and profit.

### Profit Margin

- **Golf Bags & Carts** has the highest category-level average profit margin in the analyzed results.
- Profit margin varies substantially between categories, demonstrating that high revenue does not necessarily correspond to the highest margin.

### Shipping Performance

- **Standard Class** accounts for the largest order volume.
- **Second Class** has the highest average delivery delay among the shipping modes analyzed.
- Delivery performance varies significantly across shipping modes.

---

# 5. Key Metrics

The dashboard tracks business metrics including:

- Total Revenue
- Total Profit
- Total Orders
- Average Order Value
- Profit Margin
- Delivery Delay
- Late Delivery Rate
- Customer Segment Performance
- Market Performance
- Shipping Performance

---

# 6. Tools & Technologies

- **Python** — Data cleaning, transformation, validation, feature engineering, and exploratory data analysis
- **Pandas** — Data manipulation and analysis
- **NumPy** — Numerical operations
- **MySQL** — Data storage, SQL analysis, and validation
- **SQL** — Business analysis and analytical querying
- **Power BI** — Interactive dashboard development and visualization
- **DAX** — KPI and analytical measure development

---

# 7. Analytical Skills Demonstrated

- Data cleaning and preprocessing
- Data quality assessment
- Data transformation
- Feature engineering
- Exploratory data analysis
- Business-focused SQL analysis
- Aggregations and subqueries
- Common Table Expressions
- Window functions
- SQL views
- KPI development
- Profitability analysis
- Customer segmentation
- Market analysis
- Product performance analysis
- Logistics analysis
- Delivery performance analysis
- Data modeling
- DAX measures
- Interactive dashboard development
- Business data storytelling

---

# 8. Project Structure

```text
Supply-Chain-Analytics/
│
├── Python/
│   └── Supply_Chain_Analytics.ipynb
│
├── SQL/
│   └── supply_chain_analysis.sql
│
├── PowerBI/
│   └── Supply_Chain_Dashboard.pbix
│
├── Screenshots/
│   ├── Executive_Overview.png
│   ├── Product_Category_Performance.png
│   └── Customer_Logistics_Analysis.png
│
└── README.md
