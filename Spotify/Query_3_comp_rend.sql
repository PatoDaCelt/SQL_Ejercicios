-- Comparación de rendimiento de las recomendaciones

-- Comparar la satisfacción de las recomendaciones musicales de los usuarios de cada plan frente al promedio global.

WITH global_avg_table AS (
    SELECT 
        ROUND(AVG(music_recc_rating), 1) AS global_avg
    FROM spotify_data
)

SELECT
    spotify_subscription_plan,
    ROUND(AVG(music_recc_rating), 1) AS plan_avg,
    global_avg,
    (ROUND(AVG(music_recc_rating), 1) - global_avg) AS delta
FROM spotify_data
CROSS JOIN global_avg_table
GROUP BY spotify_subscription_plan, global_avg