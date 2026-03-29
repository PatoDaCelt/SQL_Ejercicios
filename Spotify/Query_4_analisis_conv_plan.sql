-- Analisis de conversión de plan
-- Identificar el Prime Time de coversión. Ya que se desea comprobar si el momento del día en que los usarios escuchan musica influye en su disposición a pagar un plan premium.

SELECT 
    music_time_slot,
    total_free_users,
    CAST(ROUND((100.0 * interested / total_free_users), 1) AS VARCHAR) || '%' AS porcent_willingness_users_yes
FROM (
    SELECT 
        music_time_slot,
        COUNT(user_id) AS total_free_users,
        SUM(CASE
                WHEN premium_sub_willingness = 'Yes' THEN 1
                ELSE 0
            END) AS interested
    FROM spotify_data
    WHERE spotify_subscription_plan = 'Free (ad-supported)'
    GROUP BY music_time_slot
    HAVING COUNT(user_id) > 10
) AS a
ORDER BY (100.0 * interested / total_free_users) DESC