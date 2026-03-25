-- Categoria que ganan más dinero
SELECT 
    category,
    COUNT(*) AS total_orders,
    ROUND(SUM(final_price_rs), 2) AS total
FROM ecommerce_sales
GROUP BY category
ORDER BY total DESC;