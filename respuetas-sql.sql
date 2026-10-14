--2026-MND-1
--DIFICULTAD: Muy fácil
--1- Devuelve todas las películas
SELECT * FROM MOVIES;
--2- Devuelve todos los géneros existentes
SELECT * FROM GENRES;
--3- Devuelve la lista de todos los estudios de grabación que estén activos
SELECT * FROM STUDIOS WHERE STUDIO_ACTIVE = 1;
--4- Devuelve una lista de los 20 últimos miembros en anotarse a la plataforma
SELECT * FROM USERS ORDER BY USER_JOIN_DATE DESC LIMIT 20;
--38- Devuelve una lista de los 10 usuarios con más tiempo de antigüedad en la plataforma
SELECT * FROM USERS ORDER BY USER_JOIN_DATE ASC LIMIT 10;
--39- Devuelve una lista con los nombres de los actores fallecidos.
SELECT ACTOR_NAME FROM ACTORS WHERE ACTOR_DEAD_DATE IS NOT NULL;
--40- Devuelve una lista con todos los nombres de los directores que estén vivos.
SELECT DIRECTOR_NAME FROM DIRECTORS WHERE DIRECTOR_DEAD_DATE IS NULL;
--41- Devuelve el nombre y precio de todas las suscripciones disponibles en la plataforma
SELECT PLAN_NAME, PLAN_PRICE FROM SUBSCRIPTIONS;
--42- Devuelve la cantidad total de películas registradas en la base de datos.
SELECT COUNT(*) AS TOTAL_MOVIES FROM MOVIES;
--43- Devuelve las 10 películas más largas registradas en la base de datos.
SELECT * FROM MOVIES ORDER BY 
--14- Devuelve el nombre de todas las películas y el nombre del estudio que las ha realizado
SELECT MOVIE_NAME, STUDIO_NAME FROM MOVIES JOIN STUDIOS ON MOVIES.STUDIO_ID = STUDIOS.STUDIO_ID;
--15- Devuelve los miembros que accedieron al menos una película entre el año 2010 y el 2015
SELECT DISTINCT(s.USER_NAME) FROM USER_MOVIE_ACCESS uma INNER JOIN USERS s ON s.USER_ID = uma.USER_ID WHERE ACCESS_DATE >= DATE '2010-01-01' AND ACCESS_DATE <= DATE '2015-01-01'; 
--16- Devuelve cuantas películas hay de cada país
SELECT NATIONALITY_NAME, COUNT(MOVIE_NAME) AS "Quantity" FROM MOVIES INNER JOIN NATIONALITIES ON MOVIES.NATIONALITY_ID = NATIONALITIES.NATIONALITY_ID GROUP BY NATIONALITY_NAME; 
--17- Devuelve todas las películas que hay de género documental
SELECT m.MOVIE_NAME, g.GENRE_NAME FROM MOVIES m JOIN GENRES g  ON m.GENRE_ID  = g.GENRE_ID WHERE g.GENRE_NAME = 'Documentary'
--18- Devuelve todas las películas creadas por directores nacidos a partir de 1980 y que todavía están vivos
SELECT m.MOVIE_NAME, d.DIRECTOR_NAME FROM MOVIES m JOIN DIRECTORS d ON m.DIRECTOR_ID = d.DIRECTOR_ID WHERE d.DIRECTOR_BIRTH_DATE >= '1980-01-01' AND d.DIRECTOR_DEAD_DATE IS NULL;
--19- Indica si hay alguna coincidencia de nacimiento de ciudad (y si las hay, indicarlas) entre los miembros de la plataforma y los directores
SELECT USER_TOWN, USER_NAME, DIRECTOR_NAME FROM USERS INNER JOIN DIRECTORS ON USERS.USER_town = DIRECTORS.DIRECTOR_BIRTH_PLACE;
--20- Devuelve el nombre y el año de todas las pORS ma ON ma.MOVIE_ID = m.MOVIE_ID JOIN ACTORS a ON ma.ACTOR_ID = a.ACTOR_ID GROUP BY m.MOVIE_ID;
--28- Indica cual es el nombre del director del que más películas se ha accedido
SELECT d.DIRECTOR_NAME, COUNT(uma.ACCESS_ID) AS "RENTED_MOVIES" FROM USER_MOVIE_ACCESS uma INNER JOIN MOVIES m ON uma.MOVIE_ID = m.MOVIE_ID INNER JOIN DIRECTORS d ON m.DIRECTOR_ID = d.DIRECTOR_ID GROUP BY d.DIRECTOR_ID ORDER BY RENTED_MOVIES DESC LIMIT 1;
--29- Indica cuantos premios han ganado cada uno de los estudios con las películas que han creado
SELECT s.STUDIO_NAME, SUM (a.AWARD_WIN ) AS "AWARDS_WIN" FROM MOVIES m INNER JOIN AWARDS a ON m.MOVIE_ID = a.MOVIE_ID INNER JOIN STUDIOS s ON m.STUDIO_ID = s.STUDIO_ID GROUP BY s.STUDIO_ID;
--30- Indica el número de premios a los que estuvo nominado un actor, pero que no ha conseguido (Si una película está nominada a un premio, su actor también lo está)
SELECT DISTINCT u.USER_NAME, u.USER_TOWN, u.USER_PHONE FROM USER_MOVIE_ACCESS uma INNER JOIN AWARDS a ON uma.MOVIE_ID = a.MOVIE_ID INNER JOIN USERS u ON uma.USER_ID = u.USER_ID WHERE a.AWARD_NOMINATION > 150 AND a.AWARD_WIN < 50;
--31- Indica cuantos actores y directores hicieron películas para los estudios no activos
SELECT COUNT(DISTINCT m.DIRECTOR_ID) AS "DIRECTOR_NUMBER", COUNT(DISTINCT ma.ACTOR_ID) AS "ACTOR_NUMBER" FROM STUDIOS s INNER JOIN MOVIES m ON s.STUDIO_ID = m.STUDIO_ID INNER JOIN MOVIES_ACTORS ma ON ma.MOVIE_ID = m.MOVIE_ID WHERE s.STUDIO_ACTIVE = FALSE;
--32- Indica el nombre, ciudad, y teléfono de todos los miembros de la plataforma que hayan accedido películas que hayan sido nominadas a más de 150 premios y ganaran menos de 50
SELECT DISTINCT u.USER_NAME, u.USER_TOWN, u.USER_PHONE FROM USER_MOVIE_ACCESS uma INNER JOIN AWARDS a ON uma.MOVIE_ID = a.MOVIE_ID INNER JOIN USERS u ON uma.USER_ID = u.USER_ID WHERE a.AWARD_NOMINATION > 150 AND a.AWARD_WIN < 50;
--33- Comprueba si hay errores en la BD entre las películas y directores (un director muerto en el 76 no puede dirigir una película en el 88)
SELECT d.DIRECTOR_NAME, d.DIRECTOR_DEAD_DATE, MAX(m.MOVIE_RELEASE_DATE) AS MOVIE_RELEASE_DATE FROM MOVIES m INNER JOIN DIRECTORS d ON m.DIRECTOR_ID = d.DIRECTOR_ID WHERE m.MOVIE_RELEASE_DATE > d.DIRECTOR_DEAD_DATE GROUP BY d.DIRECTOR_ID;
--34- Utilizando la información de la sentencia anterior, modifica la fecha de defunción a un año más tarde del estreno de la película (mediante sentencia SQL)
UPDATE DIRECTORS d SET DIRECTOR_DEAD_DATE = (SELECT MAX(DATEADD(YEAR, 1, m.MOVIE_RELEASE_DATE)) FROM MOVIES m WHERE m.DIRECTOR_ID = d.DIRECTOR_ID AND m.MOVIE_RELEASE_DATE > d.DIRECTOR_DEAD_DATE) WHERE EXISTS (SELECT 1 FROM MOVIES m WHERE m.DIRECTOR_ID = d.DIRECTOR_ID AND m.MOVIE_RELEASE_DATE > d.DIRECTOR_DEAD_DATE);
--DIFICULTAD: Berserk mode (enunciados simples, mucha diversión…)
--35- Indica cuál es el género favorito de cada uno de los directores cuando dirigen una película
WITH GENRE_COUNTS AS 
(
SELECT d.DIRECTOR_ID, d.DIRECTOR_NAME, g.GENRE_ID, g.GE