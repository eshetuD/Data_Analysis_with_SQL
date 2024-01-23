-- 1. Customer commute by distance and country
WITh cte_bike_sale as(
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
	Country,
	CommuteDistance,
	count(DISTINCT(SalesOrderNumber)) as Sales
	from
		cte_bike_sale
	group by
		Country,
		CommuteDistance
	Order by
		Country,
		CommuteDistance
;