-- Información de comportamiento

-- Se requiere saber si los usuarios que escuchan Podcast son más propensos a estar satisfechos con la variedad que ofrece la plataforma.

-- Se debe devolver el podcast preferido, un promedio de la calificación de recomendaciones, un conteo total de usuarios que escuchan podcast.

WITH pod_satisfacction_metrics AS (
    SELECT
        preffered_pod_format,
        CASE
            WHEN pod_variety_satisfaction = 'Very Dissatisfied' THEN 0
            WHEN pod_variety_satisfaction = 'Dissatisfied' THEN 1
            WHEN pod_variety_satisfaction = 'Ok' THEN 2
            WHEN pod_variety_satisfaction = 'Satisfied' THEN 3
            WHEN pod_variety_satisfaction = 'Very Satisfied' THEN 4
            ELSE NULL
        END AS rating_num
        FROM spotify_data
        WHERE preferred_listening_content IN ('Both', 'Podcast')
            AND preffered_pod_format IS NOT NULL
)

SELECT
    preffered_pod_format,
    ROUND(AVG(rating_num)) AS avg_rating,
    COUNT(*) AS total_users
FROM pod_satisfacction_metrics
GROUP BY preffered_pod_format
HAVING ROUND(AVG(rating_num)) >= 3
ORDER BY total_users DESC