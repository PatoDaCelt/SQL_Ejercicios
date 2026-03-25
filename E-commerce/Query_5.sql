-- Segmentar los clientes según cuánto dinero han gastado en total.
-- Elite, Premium y Regular
SELECT
    user_id,
    SUM(final_price_rs) AS total_spent,
    CASE
        WHEN SUM(final_price_rs) > 500 THEN 'Elite'
        WHEN SUM(final_price_rs) >= 300 THEN 'Premium'
        WHEN SUM(final_price_rs) < 300 THEN 'Regular'
        ELSE 'None'
    END AS customer_segment
FROM ecommerce_sales
GROUP BY user_id
ORDER BY total_spent DESC
