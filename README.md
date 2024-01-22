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

