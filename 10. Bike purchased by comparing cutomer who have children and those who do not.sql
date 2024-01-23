-- 3. Bikes Sales over time compared for customer who have children and customer who do not
WITh cte_children as(
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
	SUBSTRING(cast(OrderDateKey as varchar),1,6) as Month_key,
	CASE WHEN TotalChildren = 0 THEN 'No Children'
	ELSE 'Has Children' end as Has_Children,
	count(SalesOrderNumber) as Purchase
	from cte_children
	Where SUBSTRING(cast(OrderDateKey as varchar),1,4) = '2012'
	group by SUBSTRING(cast(OrderDateKey as varchar),1,6), TotalChildren
;