create database Inventory_Management_System;
use Inventory_Management_System;
select * from inventory_main_table;
select * from supplier_table;

alter table inventory_main_table
add column total_sales float;

update inventory_main_table
set total_sales =(quantity*unit_price);

#Q1: Find the total value of inventory for each product (quantity * unit_price).
select product_name, (quantity*unit_price) as "Total_value"
from inventory_main_table;

select product_name, sum(quantity*unit_price) as "total"
from inventory_main_table
group by product_name;

# Q2: Show products with more than 100 units and unit price less than 200.
select product_name, quantity, unit_price
from inventory_main_table
where quantity>100 and unit_price<200;

# Q3: Count the number of products in each category.

select category, count(product_id)
from inventory_main_table
group by category;

select * from inventory_main_table;
select * from supplier_table;
# Q4: Find top 5 most expensive products.

select product_name, unit_price
from inventory_main_table
order by unit_price desc
limit 5;

# Q5: Find categories with more than 4000 products.
select category, count(product_id)
from inventory_main_table
group by category
having count(product_id) > 4000;

# Q6: Update quantity to 0 for discontinued products.
update inventory_main_table
set quantity = 0
where discontinued=1;

# Q7: Delete products with zero quantity and discontinued.

delete from inventory_main_table
where quantity =0 and discontinued =1;

select * from inventory_main_table;
select * from supplier_table;

# Q8: Add a new column for stock_status.

alter table inventory_main_table
add column stock_status varchar(50);

# Q9: Find how many days since the last order.
select product_name, last_order_date,
datediff(curdate(), last_order_date) as "last_order_today"
from inventory_main_table;

# Q10: Classify products into 'Low', 'Medium', 'High' stock.
select product_name,
 case 
   when quantity >450 then "High"
   when quantity between 200 and 450 then "Medium"
   else "Low"
end as "Stock"
from inventory_main_table;

# Q12: Find products more expensive than average unit_price.
select product_name, unit_price
from inventory_main_table
where unit_price >  (select avg(unit_price)
					 from inventory_main_table);

# Q16: Calculate running total of quantity per category.
select category, sum(quantity)
from inventory_main_table
group by category;

select product_id,category, 
sum(quantity) over (partition by category order by product_id) as "total"
from inventory_main_table;

# Q11: Extract month from date_added.

select month(date_added) as "month"
from inventory_main_table;

select * from inventory_main_table;
select * from supplier_table;
# Q15: Rank products by unit price within each category.

select product_id,category,
rank() over (partition by category order by unit_price) as "Rank"
from inventory_main_table;

# Q18: Find products below reorder level and not ordered in last 60 days.
select product_id, product_name, last_order_date
from inventory_main_table
where reorder_level< 50 and last_order_date<"2025-06-25"
order by last_order_date desc
limit 60;

# Q17: Find previous quantity using LAG().
select quantity,
lag(quantity) over (order by quantity) as "lag"
from inventory_main_table;

# Q19: Total reorder value needed for each supplier.

select supplier_id
from supplier_table
where supplier_id in (select supplier_id, sum(reorder_level)
				     from inventory_main_table
                      group by supplier_id);

# find total stock value per category.

select category, sum(quantity)
from inventory_main_table
group by category;

with my_cte as ( 
select category,product_name, sum(quantity) as "total_quantity"
from inventory_main_table
group by category,product_name)

select total_quantity
from my_cte;


# Join inventory with suppliers.

select inv.product_name, inv.quantity, sp.supplier_name
from inventory_main_table as inv
inner join supplier_table as sp
on inv.supplier_id = sp.supplier_id;

select * from inventory_main_table;
select * from supplier_table;

# Q1: Show top 10 products with highest inventory value.

select product_name, quantity
from inventory_main_table
order by quantity desc
limit 10;

# Q9: Combine all products that are discontinued or below reorder level (no duplicates).
select  discontinued from inventory_main_table
where discontinued=0
Union
select reorder_level from inventory_main_table
where  reorder_level <20;

# Q2: List warehouses where total quantity is above 3000.

select warehouse_location, sum(quantity)
from inventory_main_table
group by warehouse_location
having sum(quantity) >3000;

select * from inventory_main_table;
select * from supplier_table;

# Q7: Show product(s) with the highest unit price.
select product_name,category
from inventory_main_table
where unit_price= ( select max(unit_price)
			       from inventory_main_table);

# Q3: Show average price per category, sorted descending.

select category, avg(unit_price) as "avge"
from inventory_main_table
group by category
order by avge desc;

# Q8: List distrinct categories that contain discontinued products.
select distinct category
from inventory_main_table
where discontinued=0;

# Q6: List products priced above the average unit price.
# Q5: Show products where total stock value (quantity * price) is between 1000 and 5000.

select * from inventory_main_table;
select * from supplier_table;