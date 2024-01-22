-- 5. Using Q4, Add a column to show the days between the products first order and first re-order date to see if the company may have too much stock for some.
-- Show the products which took over one year to need to be reordered.
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
	MAX(product_first_orderdate) as product_first_orderdate,
	MAX(first_reorder_date) as first_reorder_date,
	DATEDIFF(day,cast(cast(MAX(product_first_orderdate) as char) as date), cast(cast(MAX(first_reorder_date) as char) as date)) as days_to_reorder
from
(
	select 
		EnglishProductName, 
		MIN(OrderDateKey) as product_first_orderdate, 
		null as first_reorder_date
	from 
		cte_first
	group by 
		EnglishProductName
	union all
	select 
		EnglishProductName,
		null as product_first_orderdate,
		MIN(OrderDateKey) as first_reorder_date 
	from 
		final
	where 
		Reorder_Flag = 1
	group by 
		EnglishProductName
) as main_subquery
group by 
	EnglishProductName, 
	DATEDIFF(day,cast(cast(product_first_orderdate as char) as date), cast(cast(first_reorder_date as char) as date))
having
	DATEDIFF(day,cast(cast(MAX(product_first_orderdate) as char) as date), cast(cast(MAX(first_reorder_date) as char) as date)) > 365
;