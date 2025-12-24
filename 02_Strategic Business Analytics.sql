use myntra

select
	*
from
	sales_data

--chage colum name

exec sp_rename 'sales_data.discount','discount_percentage','column'


-- Write a SQL query to find customers who placed more than 3 orders in the last 30 days.


select	
	s.Customer_Name,
	COUNT(*) as 'order_'
from
	sales_data as s
where 
	s.Date_of_Purchase>=DATEADD(DAY,-30,GETDATE())
group by
	s.Customer_Name
having
	COUNT(*)>3
order by
	order_ desc

--Weekly Revenue

select
	year(s.Date_of_Purchase) as year,
	month(s.Date_of_Purchase) as month,
	case
		when day(s.Date_of_Purchase)>21 then 'W-4'
		when day(s.Date_of_Purchase)>15 then 'W-3'
		when day(s.discount_percentage)>7 then 'W-2'
		else 'W-1'
	end as week,
	sum(s.Amount) as revenue
from
	sales_data as s
group by
	year(s.Date_of_Purchase),
	month(s.Date_of_Purchase),
	case
		when day(s.Date_of_Purchase)>21 then 'W-4'
		when day(s.Date_of_Purchase)>15 then 'W-3'
		when day(s.discount_percentage)>7 then 'W-2'
		else 'W-1'
	end 
order by week


--Another way


select
	year(s.Date_of_Purchase) as year,
	month(s.Date_of_Purchase) month,
	datepart(WEEK,s.Date_of_Purchase) as week,
	sum(s.Amount) as revenue
from
	sales_data as s
group by
	year(s.Date_of_Purchase),
	month(s.Date_of_Purchase),
	datepart(WEEK,s.Date_of_Purchase)
order by
	year,month,week



--Find the top 5 highest spending customers in each city from a large transaction table.

with cte as(
select
	s.City,
	s.Customer_Name,
	sum(s.Amount) as spend_amount
from
	sales_data as s
group by
	s.City,
	s.Customer_Name
),
cte2 as(
select
	*,
	DENSE_RANK() over(partition by city order by spend_amount desc) as rank
from
	cte
)
select
	*
from cte2 where rank<=5