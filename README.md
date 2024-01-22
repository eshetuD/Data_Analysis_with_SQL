# Data_Analysis_with_SQL
## 1. Sales Distribution by Customer Age Group across Countries
Objective: This analysis aims to provide insights into the distribution of sales across different customer age groups within each country. By categorizing customers into age groups, we can identify patterns and preferences in purchasing behaviour, allowing businesses to tailor marketing strategies accordingly.
<code>
with cte_age as (
	select 
		EnglishCountryRegionName,
		DATEDIFF(Month, BirthDate, OrderDate)/12 as Age,
		SalesOrderNumber
	from
		AdventureWorksDW2019.dbo.FactInternetSales fis
	JOIN
		AdventureWorksDW2019.dbo.DimCustomer cus
	ON
		fis.CustomerKey = cus.CustomerKey
	JOIN
		AdventureWorksDW2019.dbo.DimGeography geo
	ON
		cus.GeographyKey = geo.GeographyKey
),
cte_final as (
	select 
		EnglishCountryRegionName,
		CASE
			WHEN Age < 30 THEN 'a: Under 30'
			WHEN Age BETWEEN 30 AND 40 THEN 'b: 30 - 40'
			WHEN Age BETWEEN 40 AND 50 THEN 'c: 40 - 50'
			WHEN Age BETWEEN 50 AND 60 THEN 'd: 50 - 60'
			When Age > 60 THEN 'e: Above 60'
			ELSE 'Other'
		end as Age_group,
		SalesOrderNumber
	from 
		cte_age
)
select 
	EnglishCountryRegionName, 
	Age_group, 
	count(SalesOrderNumber) as Sales 
from 
	cte_final
group by 
	EnglishCountryRegionName, Age_group
order by 
	EnglishCountryRegionName, Age_group
;
</code>

## 2. Show Each product sale by age group
Objective: Understanding how products perform across different age groups is essential for targeted product development and marketing efforts. This analysis breaks down product sales by customer age groups, offering valuable information to optimize inventory, marketing, and product placement strategies.

<code>
with cte_age as (
	select 
		EnglishProductName,
		sub.EnglishProductSubcategoryName,
		DATEDIFF(Month, BirthDate, OrderDate)/12 as Age,
		SalesOrderNumber
	from
		AdventureWorksDW2019.dbo.FactInternetSales fis
	JOIN
		AdventureWorksDW2019.dbo.DimCustomer cus
	ON
		fis.CustomerKey = cus.CustomerKey
	JOIN
		AdventureWorksDW2019.dbo.DimGeography geo
	ON
		cus.GeographyKey = geo.GeographyKey
	JOIN
		AdventureWorksDW2019.dbo.DimProduct pr
	ON
		pr.ProductKey = fis.ProductKey
	JOIN
		AdventureWorksDW2019.dbo.DimProductSubcategory sub
	ON
		pr.ProductSubcategoryKey = sub.ProductSubcategoryKey
),
cte_final as (
	select 
		EnglishProductSubcategoryName,
		CASE
			WHEN Age < 30 THEN 'a: Under 30'
			WHEN Age BETWEEN 30 AND 40 THEN 'b: 30 - 40'
			WHEN Age BETWEEN 40 AND 50 THEN 'c: 40 - 50'
			WHEN Age BETWEEN 50 AND 60 THEN 'd: 50 - 60'
			When Age > 60 THEN 'e: Above 60'
			ELSE 'Other'
		end as Age_group,
		SalesOrderNumber
	from 
		cte_age
)
select 
	EnglishProductSubcategoryName, 
	Age_group, 
	count(SalesOrderNumber) as Sales 
from 
	cte_final
group by 
	EnglishProductSubcategoryName, Age_group
order by 
	EnglishProductSubcategoryName, Age_group
;
</code>

## 3. Show Monthly Sales for Australia and USA Compoared for the Year 2012

Objective: By comparing the monthly sales figures between Australia and the USA for the year 2012, this analysis aims to identify trends, seasonality, and potential opportunities or challenges in each market. This insight is crucial for strategic planning and resource allocation. 

<code>
select 
	SUBSTRING(cast(OrderDateKey as char), 1,6) as MonthKey,
	OrderDate,
	SalesOrderNumber,
	SalesTerritoryCountry
from
	AdventureWorksDW2019.dbo.FactInternetSales fis
JOIN
	AdventureWorksDW2019.dbo.DimSalesTerritory sl
ON
	fis.SalesTerritoryKey = sl.SalesTerritoryKey
WHERE 
	SalesTerritoryCountry IN ('Australia','United States')
AND
	YEAR(OrderDate) = 2012
;
</code>

## 4. Displaying First Re-Order Date for Each Product

Objective: Utilizing the DimInternetSales and Product tables, this analysis provides information on the first re-order date for each product. Knowing when a product is typically re-ordered is vital for managing inventory efficiently, ensuring products are restocked at the right time.
<code>
with cte_first as (
select
	EnglishProductName,
	OrderDateKey,
	SafetyStockLevel,
	ReorderPoint,
	SUM(OrderQuantity) as Sales
from 
	AdventureWorksDW2019.dbo.FactInternetSales fis
JOIN 
	AdventureWorksDW2019.dbo.DimProduct pr
ON
	fis.ProductKey = pr.ProductKey
group by 
	EnglishProductName,
	OrderDateKey,
	SafetyStockLevel,
	ReorderPoint
),
final as (
	select 
		*, 
		CASE WHEN (SafetyStockLevel - Running_Total_Sales) <= ReorderPoint THEN 1 ELSE 0 end as Reorder_Flag
	from
		(
			select 
				*, 
				SUM(Sales) over (partition by EnglishProductName order by OrderDateKey) as Running_Total_Sales 
			from cte_first
		) as Main_SQ
)

select 
	EnglishProductName, 
	MIN(OrderDateKey) as first_reorder_date 
from 
	final
where 
	Reorder_Flag = 1
group by 
	EnglishProductName;
</code>
## 5. Days Between First Order and First Re-Order for Q4 Products

Objective: This analysis calculates the days between the first order and the first re-order for products in Q4. By identifying products that take over a year to re-order, businesses can assess stock levels, potential overstock situations, and adjust their supply chain strategies accordingly.
<code>
with cte_first as (
select
	EnglishProductName,
	OrderDateKey,
	SafetyStockLevel,
	ReorderPoint,
	SUM(OrderQuantity) as Sales
from 
	AdventureWorksDW2019.dbo.FactInternetSales fis
JOIN 
	AdventureWorksDW2019.dbo.DimProduct pr
ON
	fis.ProductKey = pr.ProductKey
group by 
	EnglishProductName,
	OrderDateKey,
	SafetyStockLevel,
	ReorderPoint
),
final as (
	select 
		*, 
		CASE WHEN (SafetyStockLevel - Running_Total_Sales) <= ReorderPoint THEN 1 ELSE 0 end as Reorder_Flag
	from
		(
			select 
				*, 
				SUM(Sales) over (partition by EnglishProductName order by OrderDateKey) as Running_Total_Sales 
			from cte_first
		) as Main_SQ
)
select 
	EnglishProductName,
	MAX(product_first_orderdate) as product_first_orderdate,
	MAX(first_reorder_date) as first_reorder_date,
	DATEDIFF(day,cast(cast(MAX(product_first_orderdate) as char) as date), cast(cast(MAX(first_reorder_date) as char) as date)) as days_to_reorder
from
(
	select 
		EnglishProductName, 
		MIN(OrderDateKey) as product_first_orderdate, 
		null as first_reorder_date
	from 
		cte_first
	group by 
		EnglishProductName
	union all
	select 
		EnglishProductName,
		null as product_first_orderdate,
		MIN(OrderDateKey) as first_reorder_date 
	from 
		final
	where 
		Reorder_Flag = 1
	group by 
		EnglishProductName
) as main_subquery
group by 
	EnglishProductName, 
	DATEDIFF(day,cast(cast(product_first_orderdate as char) as date), cast(cast(first_reorder_date as char) as date))
having
	DATEDIFF(day,cast(cast(MAX(product_first_orderdate) as char) as date), cast(cast(MAX(first_reorder_date) as char) as date)) > 365
;
</code>
