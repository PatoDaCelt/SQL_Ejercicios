-- Top 5 compradores qué más han gastado
SELECT
    user_id,
    SUM(final_price_rs) AS total_amount
FROM ecommerce_sales
GROUP BY user_id
ORDER BY total_amount DESC
LIMIt 5