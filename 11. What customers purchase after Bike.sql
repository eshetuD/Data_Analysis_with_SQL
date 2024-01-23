-- For Customer who purchase a mountain, road or touring bike, what is their next non-bike purchase?
WITh cte_all_purchase as(
	select
		fis.CustomerKey,
		SalesOrderNumber,
		OrderDate,
		EnglishProductSubcategoryName,
		ROW_NUMBER() over (partition by fis.CustomerKey order by OrderDate) as Purchase_Num
		from
			AdventureWorksDW2019.dbo.FactInternetSales fis
		JOIN
			AdventureWorksDW2019.dbo.DimCustomer cus
		ON
			fis.CustomerKey = cus.CustomerKey
		JOIN
			AdventureWorksDW2019.dbo.DimProduct pr
		ON
			fis.ProductKey = pr.ProductKey
		JOIN
			AdventureWorksDW2019.dbo.DimProductSubcategory psc
		ON
			pr.ProductSubcategoryKey = psc.ProductSubcategoryKey
),
bike_purchase as(
	select *, Purchase_Num + 1 as next_purchase_number from cte_all_purchase
	where EnglishProductSubcategoryName in ('Mountain Bikes','Touring Bikes','Road Bikes')
)
select bp.*, cap.EnglishProductSubcategoryName as next_product_purchased from bike_purchase bp
left join cte_all_purchase cap
on bp.CustomerKey = cap.CustomerKey AND bp.next_purchase_number = cap.Purchase_Num
where 1=1 AND cap.EnglishProductSubcategoryName not in ('Mountain Bikes','Touring Bikes','Road Bikes')