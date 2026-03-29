-- Query de segemntación de usuarios gratuitos y preferencias

-- Devolver los generos musicales preferidos y cuantos usuarios los proferien que cumpla con los siguiente:
-- Usuarios mujeres de 20 a 35 años
-- Que utilicen Smartphone
-- Plan de suscripción Free

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