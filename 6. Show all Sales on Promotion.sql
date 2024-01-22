-- 6. Show all Sales on Promotion and a Column Showing their new Sales value if 25% discount is applied
select 
	OrderDate,
	SalesReasonName,
	fis.SalesOrderNumber,
	SalesAmount,
	ROUND((SalesAmount*0.75),2) as Sales_amount_after_discount
from
	AdventureWorksDW2019.dbo.FactInternetSales fis
join
	AdventureWorksDW2019.dbo.FactInternetSalesReason fisr
ON
	fis.SalesOrderNumber = fisr.SalesOrderNumber
join
	AdventureWorksDW2019.dbo.DimSalesReason sr
ON
	fisr.SalesReasonKey = sr.SalesReasonKey
WHERE
	SalesReasonName = 'On Promotion'
;