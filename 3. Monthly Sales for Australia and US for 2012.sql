-- 3. Show Monthly Sales for Australia and USA Compoared for the Year 2012

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