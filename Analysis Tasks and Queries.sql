'
Analysis Tasks and Queries
Task 1: Total Orders by Customers
'       
Select c.customer_id, 
       c.first_name||' '||c.last_name as Full_Name, 
       count(o.order_id) as Total_order 
from customers as c 
join orders as o 
on c.customer_id = o.customer_id 
group by c.customer_id, Full_Name
order by Total_order desc;
'
Insight:
Customers with the most orders are your most loyal buyers — great candidates for loyalty rewards.
       

Task 2: Total Sales per Store
'
select o.store_id, s.store_name, sum(oi.list_price * oi.quantity) as Total_sales
from orders as o
join stores as s on o.store_id = s.store_id 
join order_items as oi on o.order_id = oi.order_id 
group by o.store_id, s.store_name
order by total_sales desc; ''
       
'Insight:Stores with higher sales contribute more revenue — focus marketing and resources there.

Task 3: Orders Status Count
'
select order_status, count(*) from orders group by order_status;
'
Insight:Shows how many orders are pending, shipped, or cancelled — helps track store performance.

Task 4: Top 5 Customers by Spending
'      
select c.first_name||' '||c.last_name as Full_Name, o.customer_id,
       sum(oi.list_price * oi.quantity) as Total_Sales
from customers as c 
join orders as o on c.customer_id = o.customer_id 
join order_items as oi on o.order_id = oi.order_id 
group by o.customer_id, Full_Name
order by Total_sales desc
limit 10;'
       
Insight:These customers spend the most — offer special discounts or loyalty benefits.
'
Task 5: Top Selling Products
Select p.product_id, p.product_name, sum(oi.quantity) as total_Quantity
from products as p 
join order_items as oi on p.product_id = oi.product_id 
group by p.product_id, p.product_name 
order by total_Quantity desc
limit 10;'
Insight:
Shows the most popular products — make sure these are always in stock.
'
Task 6: Sales per Category
Select c.category_id, c.category_name, sum(oi.List_price * oi.quantity) as total_Sales
from categories as c
join products as p on c.category_id = p.category_id 
join order_items as oi on p.product_id = oi.product_id 
group by c.category_id, c.category_name;''
'Insight:
Categories with higher sales bring more profit — focus promotions on these.
'
Task 7: Staff Performance
Select st.staff_id, st.first_name, st.last_name, count(o.order_id) as Total_order
from staffs as st 
join orders as o on st.staff_id = o.staff_id 
group by st.staff_id, st.first_name, st.last_name
order by Total_order desc;'
Insight:
Staff with higher order counts are top performers — useful for incentives or appraisals.

Task 8: Rank Customers by Total Spending
'
with ranked_customer_by_total_spending as(
Select c.customer_id,
       c.first_name||' '||c.last_name as Full_name,
       sum(oi.quantity * oi.list_price) as total_sales,
       dense_rank() over(order by sum(oi.quantity * oi.list_price) desc) as ranked_customer 
from customers as c 
join orders as o on c.customer_id = o.customer_id 
join order_items as oi on o.order_id = oi.order_id 
group by c.customer_id, c.first_name, c.last_name
)
select customer_id, full_name, total_sales, ranked_customer
from ranked_customer_by_total_spending;'
Insight:
Ranking shows which customers are top spenders — great for segmentation and marketing focus.
'
Task 9: Monthly Sales Trend per Store
Select st.store_id , st.store_name , to_char(o.order_date, 'Month') as Month,
       sum(oi.Quantity * oi.list_price) as Total_sales
from stores as st
join orders as o on st.store_id = o.store_id 
join order_items as oi on o.order_id = oi.order_id 
group by st.store_id, st.store_name, to_char(o.order_date, 'Month')
order by month asc;'
Insight:
Tracks month-by-month sales trends — helps plan seasonal discounts and promotions.
'
Task 10: Most Profitable Product per Category
With product_profit as (
Select ct.category_id, ct.category_name, p.product_name,
       sum(oi.quantity * oi.list_price) as product_sales,
       rank() over(partition by ct.category_name order by sum(oi.quantity * oi.list_price) desc) as ranked_in_category
from categories as ct 
join products as p on ct.category_id = p.category_id 
join order_items as oi on p.product_id = oi.product_id 
group by ct.category_id, ct.category_name, p.product_name
)
select category_name, product_name , product_sales , ranked_in_category
from product_profit
where ranked_in_category = 1;'
Insight:
Shows top-performing products within each category — great for identifying bestsellers.
'
Task 11: Low Stock Products
with low_Stock as (
Select s.store_id, s.store_name, p.product_name, st.quantity
from stores as s
join stocks as st on s.store_id = st.store_id 
join products as p on st.product_id = p.product_id 
where st.quantity < 10
)
select * from low_stock
order by store_id , quantity desc;





