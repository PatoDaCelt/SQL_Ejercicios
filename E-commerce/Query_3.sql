-- Meses con más ventas
SELECT
    TO_CHAR(purchase_date, 'Month - YYYY') AS month,
    COUNT(*) AS total_sales,
    SUM(final_price_rs) AS monthly_rev
FROM ecommerce_sales
GROUP BY month
ORDER BY monthly_rev DESC
LIMIT 5