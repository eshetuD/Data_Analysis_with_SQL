-- 4. Using DimInternetSales and Product Table, Display each product first re-Order date
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
	EnglishProductName
;