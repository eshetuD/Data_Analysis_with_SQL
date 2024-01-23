-- 2. Amount of purchase by customers shown with their yearly income
WITh cte_purchase as(
	select 
		OrderDateKey,
		OrderDate,
		fis.CustomerKey,
		BirthDate,
		YearlyIncome,
		TotalChildren,
		CommuteDistance,
		EnglishCountryRegionName as Country,
		EnglishProductSubcategoryName as Bike_type,
		SalesAmount,
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
			fis.ProductKey = pr.ProductKey
		JOIN
			AdventureWorksDW2019.dbo.DimProductSubcategory psc
		ON
			pr.ProductSubcategoryKey = psc.ProductSubcategoryKey
		WHERE
			EnglishProductSubcategoryName IN ('Mountain Bikes', 'Touring Bikes','Road Bikes')
)
select 
		CustomerKey, 
		CASE WHEN YearlyIncome < 50000 THEN 'a: Less Than $50k'
		WHEN YearlyIncome BETWEEN 50000 AND 75000 THEN 'b: $50k - $75k'
		WHEN YearlyIncome BETWEEN 75000 AND 100000 THEN 'b: $75k - $100k'
		WHEN YearlyIncome > 100000 THEN 'd: Above $100k'
		ELSE 'Other' end as YearlyIncome,
		count(SalesOrderNumber) as Purchases
	from 
		cte_purchase
	group by 
		CustomerKey, 
		YearlyIncome
;