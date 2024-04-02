USE restaurant_db;

-- OBJECTIVE 1

-- View the menu_items table

SELECT *
FROM menu_items;

-- write a query to find the number of items on the menu

SELECT
	COUNT(*)
FROM menu_items;

-- What are the least & most expensive items on the menu

SELECT *
FROM menu_items
ORDER BY price;

SELECT *
FROM menu_items
ORDER BY price DESC;

-- How many Italian dishes are on the menu?

SELECT
	COUNT(*)
FROM menu_items
WHERE category = 'Italian';

-- What are the least & most expensive Italian dishes on the menu?

SELECT *
FROM menu_items
WHERE category = 'Italian'
AND price = (SELECT MIN(price) FROM menu_items WHERE category = 'Italian');

SELECT *
FROM menu_items
WHERE category = 'Italian'
AND price = (SELECT MAX(price) FROM menu_items WHERE category = 'Italian');

-- How many dishes are in each category?

SELECT
	category,
    	COUNT(item_name) AS total_items
FROM menu_items
GROUP BY category;

-- What is the average dish price within each category?

SELECT
	category,
    	AVG(price) AS average_dish_price
FROM menu_items
GROUP BY category;

-- OBJECTIVE 2

-- View the order_details table.

SELECT *
FROM order_details;

-- What is the date range of the table

SELECT
	MIN(order_date),
    	MAX(order_date)
FROM order_details;

-- How many orders were made within this date range

SELECT
	COUNT(DISTINCT(order_id))
FROM order_details;

-- How many items were ordered within this date range

SELECT
	COUNT(*)
FROM order_details;

-- Which orders had the most number of items

SELECT
	order_id,
    	COUNT(item_id) AS num_items
FROM order_details
GROUP BY order_id
ORDER BY num_items DESC;

-- How many orders had more than 12 items

SELECT COUNT(*)
FROM
(SELECT
	order_id,
    	COUNT(item_id) AS num_items
FROM order_details
GROUP BY order_id
HAVING COUNT(item_id) > 12) AS num_orders;

-- OBJECTIVE 3

-- Combine the menu_items and order_details tables into a single table

SELECT *
FROM menu_items m
LEFT JOIN order_details o
ON m.menu_item_id = o.item_id;

-- What were the least & most ordered items and What categories were they in

SELECT
	m.item_name,
    	m.category,
	COUNT(o.item_id)
FROM menu_items m
LEFT JOIN order_details o
ON m.menu_item_id = o.item_id
GROUP BY m.item_name,
	 m.category
ORDER BY COUNT(o.item_id);

SELECT
	m.item_name,
    	m.category,
	COUNT(o.item_id)
FROM menu_items m
LEFT JOIN order_details o
ON m.menu_item_id = o.item_id
GROUP BY m.item_name,
	 m.category
ORDER BY COUNT(o.item_id) DESC;

-- What were the top 5 orders that spent the most money

SELECT
	o.order_id,
    	SUM(m.price) AS total_price
FROM menu_items m
LEFT JOIN order_details o
ON m.menu_item_id = o.item_id
GROUP BY o.order_id
ORDER BY total_price DESC
LIMIT 5;

-- View the details of the highest spend order. What insights can you gather from the results

SELECT
	m.category,
    	COUNT(o.item_id)
FROM menu_items m
LEFT JOIN order_details o
ON m.menu_item_id = o.item_id
WHERE o.order_id = 440
GROUP BY m.category;

-- View the details of the top 5 highest spend orders. What insights can you gather from the results

SELECT
	o.order_id,
	m.category,
    	COUNT(o.item_id)
FROM menu_items m
LEFT JOIN order_details o
ON m.menu_item_id = o.item_id
WHERE o.order_id IN (440,2075,1957,330,2675)
GROUP BY o.order_id,
	 m.category;
