-- 7. Show each customer key, the sales value of their first sales, and the sale value of their last sales.
-- And also show the difference betweent the two
with cte_first as (
	select
		CustomerKey,
		SalesAmount,
		OrderDate,
		ROW_NUMBER() over (partition by CustomerKey order by OrderDate asc) as Order_Num
	from
		AdventureWorksDW2019.dbo.FactInternetSales
),
cte_second as(
	select
		CustomerKey,
		SalesAmount,
		OrderDate,
		ROW_NUMBER() over (partition by CustomerKey order by OrderDate desc) as Order_Num
	from
		AdventureWorksDW2019.dbo.FactInternetSales
)

select 
	CustomerKey, 
	SUM(first_purchase_value) as first_purchase_value,
	SUM(last_purchase_value) as last_purchase_value,
	ROUND((SUM(last_purchase_value) - SUM(first_purchase_value)),2) as change_val
from
	(select CustomerKey, SalesAmount as first_purchase_value, null as last_purchase_value from cte_first where Order_Num = 1
	union all
	select CustomerKey, null as first_purchase_value, SalesAmount as last_purchase_value from cte_second where Order_Num = 1
	) subquery
group by CustomerKey
having (SUM(last_purchase_value) - SUM(first_purchase_value)) <> 0
order by change_val;