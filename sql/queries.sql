--Topic: Online Store Sales Analysis

/* Task: Top 3 products sold in 2025
         The task could have been simplified using LIMIT, but it may cut off rows with identical values*/
WITH cte AS (
SELECT shop.title
      ,count(*) AS cnt_orders 
FROM orders
JOIN shop ON shop.id = orders.shopId
WHERE YEAR(orders.date_time) = 2025
GROUP BY shop.id)
,ranked AS (
SELECT title
	  ,cnt_orders
      ,DENSE_RANK() OVER (ORDER BY cnt_orders DESC) AS rank_ord
FROM cte)
SELECT * 
FROM ranked 
WHERE rank_ord <= 3;
 
/* Task: Show the product name, its price, and the average price of its category, but only for products that are more expensive than the average price of their category.
   Approach 1: Correlated subquery.
               The inner subquery is executed for each row of the outer query*/
SELECT 
     shop.title
    ,shop.price 
    ,(
        SELECT AVG(shop_inner.price)
        FROM shop AS shop_inner
        WHERE shop_inner.category_id = shop.category_id    
     ) AS avg_cat_price
FROM shop
WHERE shop.price > (
        SELECT AVG(shop_inner.price)
        FROM shop AS shop_inner
        WHERE shop_inner.category_id = shop.category_id 
                   );

-- Approach 2: JOIN with aggregated table
-- More efficient for larger datasets
SELECT 
     shop.title
    ,shop.price
    ,avg_tb.avg_cat_price
FROM shop
JOIN (
        SELECT AVG(shop_inner.price) AS avg_cat_price
        	  ,category_id
        FROM shop AS shop_inner
        GROUP BY category_id   
     ) AS avg_tb
ON shop.category_id = avg_tb.category_id
WHERE shop.price > avg_tb.avg_cat_price
	
/* Task: Find products with the minimum price in their category using a correlated subquery
         The inner subquery is executed for each row of the outer query, which allows values to be compared row by row.*/
SELECT shop.title
      ,shop.price
      ,shop.category_id
FROM shop
WHERE shop.price = (SELECT MIN(s2.price) FROM shop s2
				    WHERE s2.category_id = shop.category_id);

-- Task: Distribution of orders by price and season for the year 2025
SELECT 
      CASE 
            WHEN price < 1500
            THEN 'small'
            WHEN price <= 2200
      		THEN 'medium'
      		ELSE 'large'
      		END            AS order_size
      ,CASE
	      	WHEN MONTH(orders.date_time) IN (12, 1, 2) THEN 'winter'
	        WHEN MONTH(orders.date_time) IN (3, 4, 5) THEN 'spring'
	        WHEN MONTH(orders.date_time) IN (6, 7, 8) THEN 'summer'
	        ELSE 'autumn'
	      	END            AS season
      , count(*) AS cnt
FROM orders
JOIN shop ON shop.id = orders.shopId
WHERE YEAR(orders.date_time) = 2025
GROUP BY order_size, season
ORDER BY order_size, season;

-- Task: Store profit by month with cumulative total at the end of the year 2025 
WITH base AS (
    SELECT 
         month(orders.date_time) AS month_time
        ,SUM(price) AS revenue
    FROM orders
    JOIN shop ON shop.id = orders.shopId
    WHERE YEAR(orders.date_time) = 2025
    GROUP BY month_time
)
SELECT 
    month_time,
    revenue,
    SUM(revenue) OVER (ORDER BY month_time) AS cumulative_revenue
FROM base;
