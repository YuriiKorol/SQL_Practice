/* Task: Calculate the average spending of all customers in each category.
         For each customer, show by what percentage their spending is above or below the category average.
         Display only the records where the customer spent more than the category average. */

WITH cte AS (
SELECT people.name AS p_name
      ,categories.name AS cat_name
      ,SUM(price)  AS tot_pers_in_cat
FROM orders
JOIN shop ON orders.shopId = shop.id                                          
JOIN people ON orders.personId = people.id                       -- Calculation of each customer’s spending by category
JOIN categories ON categories.id = shop.category_id                                   
GROUP BY people.id, categories.id
ORDER BY people.id)
,
ranked AS (
SELECT cat_name
	  ,avg(tot_pers_in_cat) AS avg_in_category             -- Average order value by category
FROM cte
GROUP BY cat_name)
SELECT cte.p_name
      ,cte.cat_name
      ,cte.tot_pers_in_cat
      ,ranked.avg_in_category
	  ,ROUND(((tot_pers_in_cat - avg_in_category) / avg_in_category) * 100, 2) AS pct_diff_from_category_avg                -- For each customer, calculate the percentage difference between their spending																															-- and the category average; keep only customers who spent above the category averag
FROM cte
JOIN ranked ON ranked.cat_name = cte.cat_name  
WHERE cte.tot_pers_in_cat > ranked.avg_in_category;
