-- Método de pago más usado
SELECT 
    payment_method,
    COUNT(payment_method) AS total_uses
FROM ecommerce_sales
GROUP BY payment_method
ORDER BY total_uses DESC