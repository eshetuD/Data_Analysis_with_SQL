-- 1. Show each country sales by customer age Group
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