-- 2. Show Each product sale by age group
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