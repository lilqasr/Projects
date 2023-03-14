USE spotify;
/* The first thing was to import the files 
on individuals tables and then make the union*/

CREATE TABLE spotihist (
SELECT * FROM historyfirst
UNION 
SELECT * FROM historyfirst1
UNION 
SELECT * FROM historyfirst2);

SELECT * FROM spotihist;

-- Then change name of some of the columns:

ALTER TABLE spotihist
CHANGE COLUMN ts when_played VARCHAR(100),
CHANGE COLUMN master_metadata_track_name track_name VARCHAR(200),
CHANGE COLUMN master_metadata_album_artist_name artist_name VARCHAR(200),
CHANGE COLUMN master_metadata_album_album_name album_name VARCHAR(200);

/* I realize there was some characters that did not allow to convert the datetime column (ts/when_played).
So i had to replace this characters:*/

UPDATE spotihist
SET when_played = REPLACE(REPLACE(when_played, 'T', ' '),'Z', ''); 

UPDATE spotihist
SET when_played = REPLACE (when_played, 'Z', '');

ALTER TABLE spotihist
MODIFY when_played DATETIME;

-- PERIOD OF TIME COVERED BY THIS DATA:

SELECT MIN(when_played) start_date,
MAX(when_played) end_date,
DATEDIFF(MAX(when_played),MIN(when_played)) total_days
FROM spotihist;

-- WHEN DID I START  TO LISTENING SPOTIFY

SELECT when_played, track_name, artist_name, ms_played, conn_country, reason_end 
FROM spotihist
WHERE when_played = (SELECT min(when_played) FROM spotihist);

/*How many artist i've listened to it; how many songs; 
how many hours in all of these years; which countries from; */

-- HOW MANY ARTISTS
SELECT COUNT(DISTINCT(artist_name)) AS `Q. ARTIST PLAYED`
FROM spotihist;

-- HOW MANY HOURS
SELECT ROUND(SUM(ms_played/3600000),2) as `TOTAL HOURS PLAYED`
FROM spotihist;

-- HOW MANY SONGS
SELECT COUNT(DISTINCT(track_name)) AS `TOTAL # OF SONGS`
FROM spotihist;

-- TOTAL HOURS PER COUNTRY?
SELECT conn_country, ROUND(SUM(ms_played/3600000),2) AS `# HOURS BY COUNTRY`
FROM spotihist
GROUP BY conn_country ORDER BY 2 DESC;

-- TOP 10 MOST LISTENED ARTIST AND SONGS:

SELECT artist_name, ROUND(SUM(ms_played/3600000),2) AS `HOURS PLAYED`, 
COUNT(*) AS `TIMES PLAYED`
FROM SPOTIHIST
GROUP BY ARTIST_NAME ORDER BY 2 DESC LIMIT 10;

SELECT TRACK_NAME, ROUND(SUM(ms_played/3600000),2) AS `HOURS PLAYED`, 
COUNT(*) AS `TIMES PLAYED`
FROM SPOTIHIST
GROUP BY TRACK_NAME ORDER BY 2 DESC LIMIT 10;

SELECT *
FROM spotihist
where artist_name = 'None';

SELECT spotify_track_uri, episode_name, episode_show_name, spotify_episode_uri
FROM spotihist
where episode_show_name <> 'None';

SELECT episode_show_name, ROUND(SUM(ms_played/3600000),2) AS `HOURS PLAYED`
FROM spotihist
where episode_show_name <> 'None'
GROUP BY episode_show_name ORDER BY 2 DESC LIMIT 10;

-- TIME SERIES ANALYISIS

-- Hours listening spotify by year

WITH YEARS_PLAYED AS (
SELECT EXTRACT(YEAR FROM WHEN_PLAYED) AS YEAR_PLAYED, SUM(MS_PLAYED/3600000) AS `HOURS_PLAYED`,
LAG(SUM(MS_PLAYED/3600000)) OVER (ORDER BY EXTRACT(YEAR FROM WHEN_PLAYED)) AS PREV_HR_PLAYED
FROM SPOTIHIST
GROUP BY YEAR_PLAYED)
SELECT *, 
(HOURS_PLAYED-PREV_HR_PLAYED) as HOURS_CHANGE,
ROUND(((HOURS_PLAYED/PREV_HR_PLAYED)-1)*100,2) PCT_CHANGE
FROM YEARS_PLAYED;

-- Change between 2017 and 2020

WITH YEARS_PLAYED AS (
SELECT EXTRACT(YEAR FROM WHEN_PLAYED) AS YEAR_PLAYED, SUM(MS_PLAYED/3600000) AS `HOURS_PLAYED`,
LAG(SUM(MS_PLAYED/3600000)) OVER (ORDER BY EXTRACT(YEAR FROM WHEN_PLAYED)) AS PREV_HR_PLAYED
FROM SPOTIHIST
GROUP BY YEAR_PLAYED)
SELECT year_played, (SELECT HOURS_PLAYED from years_played where year_played = 2020) - 
(SELECT HOURS_PLAYED from years_played where year_played = 2017) as `2017-2020 CHANGE`
FROM YEARS_PLAYED
WHERE YEAR_PLAYED = 2020;

FROM SPOTIHIST
GROUP BY `YEAR PLAYED` ORDER BY 1;

-- First, it is necessary to create a column for year

ALTER TABLE spotihist
ADD COLUMN year_played INT NOT NULL AFTER when_played;

UPDATE spotihist
SET year_played = EXTRACT(YEAR FROM when_played);

select * from spotihist;

-- Group plays by year

SELECT year_played, COUNT(year_played)
FROM spotihist
GROUP BY year_played ORDER BY year_played ASC;

/* How many minutes did i play every year?*/

SELECT year_played, SUM(ms_played/60000) as minutes_played
FROM spotihist
GROUP BY year_played ORDER BY minutes_played DESC;

--

SELECT year_played, artist_name, COUNT(artist_name) 
FROM spotihist
group by year_played, artist_name
order by COUNT(artist_name) DESC;

-- WHICH ARE THE TOP 3 PLAYED ARTIST BY YEAR

with ranking_artist as (
select year_played, artist_name, count(artist_name) AS Times_Played,
RANK() OVER (PARTITION BY year_played order by year_played DESC, count(artist_name) DESC) as rank_artist_played
from spotihist group by year_played, artist_name)
SELECT * FROM ranking_artist
where rank_artist_played <=3;

-- WHICH ARE THE TOP 3 LISTENED ARTIST BY YEAR

with most_listened_artist as (
select year_played, artist_name, sum(ms_played/3600000) AS Hours_Played,
RANK() OVER (PARTITION BY year_played order by year_played DESC, sum(ms_played/3600000) DESC) as rank_artist_listened
from spotihist group by year_played, artist_name)
SELECT * FROM most_listened_artist
where rank_artist_listened <=3;

-- WHAT IS THIS 'NONE' ARTIST?
SELECT * 
FROM spotihist
WHERE artist_name = 'None';

SELECT ms_played, track_name, artist_name, album_name, episode_name  
FROM spotihist
WHERE artist_name = 'None'
ORDER BY episode_name;