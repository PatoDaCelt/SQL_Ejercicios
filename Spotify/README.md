# Análisis de usuarios de Spotify

Este proyecto utiliza un dataset de encuestas de usuarios de Spotify para entender cómo los diferentes perfiles demográficos interactúan con la música y los podcasts, así como su disposición a pagar por planes premium.

## Objetivo
Se tiene el objetivo de utilizar los datos de usuarios como información estrategica que ayude a responder preguntas y se puede mejorar la estrategia de recomendaciones.

## Tecnologías utilizadas
* **Base de Datos:** PostgreSQL
* **Lenguaje:** SQL
* **Procesamiento previo:** Python (Pandas) para la generación de `user_id` aleatorios.

## Estructura de la BD
Tabla: spotify_data

| Columna | Tipo de Dato | Descripción |
| :--- | :--- | :--- |
| `user_id` | VARCHAR | Identificador único |
| `age` | VARCHAR | Identificador único generado para el análisis |
| `spotify_subscription_plan` | VARCHAR | Tipo de plan actual (Free o Premium) |
| `preferred_listening_content` | VARCHAR | Contenido preferido (Music o Podcast) |
| `pod_host_preference`| VARCHAR | Preferencia sobre el tipo de anfitrión del podcast |

## Querys realizadas
### Query_1 - Segemntación de usuarios gratuitos y preferencias:
Esta consulta revela que géneros musicales dominan el consumo de los usuarios mujeres de entre 20 y 35 años con plan gratuito y que usan Spotify principalmente desde sus dispositivos móviles.

```sql
SELECT
    fav_music_genre,
    COUNT(user_id) AS total_users
FROM spotify_data
WHERE gender = 'Female'
    AND age = '20-35'
    AND spotify_listening_device LIKE '%Smartphone%'
    AND spotify_subscription_plan = 'Free (ad-supported)'
GROUP BY fav_music_genre
ORDER BY total_users DESC
```

| fav_music_genre | total_users |
| :--- | :--- |
| Melody | 173 |
| Pop | 45 |
| Electronic/Dance | 11 |
| Classical | 10 |
| Kpop | 4 |
| Rap | 3 |
| All | 2 |
| Classical & melody, dance | 1 |

El resultado muestra que este grupo demográfico tiene preferencia con el género de musica Melody y Pop, es decir, que buscan un contenido más comercial mientras tienen un plan gratuito.

### Query_2 - Información de comportamiento de usuarios en podcast:
Consulta para identificar qeu formatos de podcast generan una mayor satisfacción en los usuarios y cuál es el volumen de audiencia para estos formatos líderes.

```sql
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
```

Se utilizó un CASE WHEN para convertir escalas cualitativas en valores contables promediables.
La cláusula HAVING ayuda a filtrar grupos basados en una agregación.
La query tiene una estructura limpia y legible mediante el uso de CTEs.

| preffered_pod_format | avg_rating | total_users |
| :--- | :--- | :--- |
| Interview	| 3 | 39 |
| Conversational | 3 | 17 |
| Educational | 3 | 8 |

El formato de podcast de Interview es el más consumido por los usuarios y mantiene un nivel de satisfacción sólido.

### Query_3 - Comparación de rendimiento de las recomendaciones:

```sql
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
```
Se utilizó una CTE para aislar el cálculo global, tambien se empleó el uso del CROSS JOIN que compara cada fila contra ese valor unico.

| spotify_subscription_plan | plan_avg | global_avg |  delta |
| :--- | :--- | :--- | :--- |
| Free (ad-supported)	| 3.6 | 3.5 | 0.1 |
| Premium (paid subscription) | 3.1 | 3.5 | -0.4 |

El resultado nos dice que si el delta es negativo la media del plan está por debajo la media global de satisfacción. Esto nos permite identificar si los anuncios en el plan Free estan afectando negativamente la percepción de la calidad de las recomendaciones musicales.

### Query_4 - Analisis de conversión de plan:
Identificar el Prime Time de coversión, ya que se desea comprobar si el momento del día en que los usarios escuchan musica influye en su disposición a pagar un plan premium.

```sql
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
```
Se filtraron los usuarios con planes gratuitos y se calculó el porcentaje de disposición a ser Premium agrupandolo por cada franja horaria. Despues, se aplicó el filtro HAVING a esa agrupación para asegurar que la muestra sea representativa con más de 10 usuarios por franja, para evitar incongruencias estadisticas.

| music_time_slot | total_free_users | porcent_willingness_users_yes |
| :--- | :--- | :--- |
| Afternoon | 81 | 44.4% |
| Morning | 75 | 32.0%|
| Night | 268 | 20.1% |

Los usuarios que escuchan música durente la Tarde muestran más interés en cambiarse a un plan premium comparado con los de otras frnajas horarias, lo que sugiere una oportunidad para lanzar anuncios de suscripción durante ese horario específico.