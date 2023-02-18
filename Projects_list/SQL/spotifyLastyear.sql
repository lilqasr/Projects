CREATE DATABASE SPOTIFY;
USE SPOTIFY;
SELECT * FROM  streaminghistory;

DESCRIBE streaminghistory;

ALTER TABLE streaminghistory
CHANGE COLUMN endTime PLAYED_ON datetime,
CHANGE COLUMN  artistName ARTISTNAME VARCHAR(4000) NOT NULL,
CHANGE COLUMN  trackName TRACKNAME VARCHAR(4000) NOT NULL,
CHANGE COLUMN  msPlayed MILLISECONDS INTEGER NOT NULL;

DESCRIBE streaminghistory;

SELECT * FROM streaminghistory;

ALTER TABLE streaminghistory
CHANGE COLUMN  MILLISECONDS MILLISECONDSPLAYED INTEGER NOT NULL;

SELECT COUNT(ARTISTNAME)
FROM streaminghistory;

-- Period of time cover by this data:

SELECT MIN(PLAYED_ON) start_date,
MAX(PLAYED_ON) end_date,
DATEDIFF(MAX(PLAYED_ON),MIN(PLAYED_ON)) total_days
FROM streaminghistory;

-- HOW MANY ARTIST DID I LISTEN TO?

SELECT COUNT(DISTINCT(ARTISTNAME)) TOTAL_ARTIST_PLAYED
FROM STREAMINGHISTORY;

-- TOTAL MINUTES PLAYED
SELECT SUM(MILLISECONDSPLAYED/60000) `TOTAL MINUTES PLAYED`
FROM STREAMINGHISTORY;

-- TOTAL HOURS PLAYED
SELECT SUM(MILLISECONDSPLAYED/3600000) `TOTAL HOURS PLAYED`
FROM STREAMINGHISTORY;
-- WHO WHERE MY FAVORITE ARTIST?

-- Times played by artist
SELECT COUNT(*) TIMESPLAYED, ARTISTNAME
FROM STREAMINGHISTORY
GROUP BY ARTISTNAME ORDER BY 1 DESC;

-- Minutes played by artist

SELECT ARTISTNAME, SUM(MILLISECONDSPLAYED/60000) MINUTESPLAYED 
FROM STREAMINGHISTORY
GROUP BY ARTISTNAME ORDER BY 2 DESC LIMIT 10;


SELECT COUNT(*)
FROM STREAMINGHISTORY;


-- MOST ARTIST PLAYED PER MONTH

ALTER TABLE STREAMINGHISTORY
ADD COLUMN MONTH_PLAYED INT NOT NULL AFTER PLAYED_ON;

UPDATE STREAMINGHISTORY
SET MONTH_PLAYED = EXTRACT(YEAR_MONTH FROM PLAYED_ON);

SELECT * FROM STREAMINGHISTORY;

-- MOST PLAYED ARTIST

WITH ARTISTMONTHRANK AS (
SELECT MONTH_PLAYED, ARTISTNAME, COUNT(ARTISTNAME) TIMES_PLAYED,
RANK() OVER (PARTITION BY MONTH_PLAYED order by MONTH_PLAYED DESC, count(ARTISTNAME) DESC) as rank_artist_played
FROM STREAMINGHISTORY GROUP BY MONTH_PLAYED, ARTISTNAME)
SELECT * FROM ARTISTMONTHRANK
where rank_artist_played <=1;

-- MOST LISTENED ARTIST BY MONTH
WITH ARTISTLISTENEDRANK AS (
SELECT MONTH_PLAYED, ARTISTNAME, SUM(MILLISECONDSPLAYED/60000) MINUTES_PLAYED,
RANK() OVER (PARTITION BY MONTH_PLAYED order by MONTH_PLAYED DESC, SUM(MILLISECONDSPLAYED*60000) DESC) as rank_artist_LISTENED
FROM STREAMINGHISTORY GROUP BY MONTH_PLAYED, ARTISTNAME)
SELECT * FROM ARTISTLISTENEDRANK
where rank_artist_LISTENED <=1;

-- MOST MINUTES LISTENED BY MONTH

SELECT MONTH_PLAYED, SUM(MILLISECONDSPLAYED/60000) `MINUTES PLAYED`
FROM STREAMINGHISTORY
GROUP BY MONTH_PLAYED ORDER BY 1;

-- TOP SONGS PLAYED, TIMES AND MINUTES:
SELECT TRACKNAME, COUNT(*) `TIMES PLAYED`
FROM STREAMINGHISTORY
GROUP BY TRACKNAME ORDER BY 2 DESC LIMIT 10;

SELECT TRACKNAME, SUM(MILLISECONDSPLAYED/60000) `MINUTES PLAYED`
FROM STREAMINGHISTORY
GROUP BY TRACKNAME ORDER BY 2 DESC LIMIT 10;

FROM STREAMINGHISTORY

-- FIND WHAT I LISTEN IN A PARTICULAR DAY AND TIME RANGE
-- SELECT ARTIST LISTENED ON MONDAY MORNINGS:
SELECT
    COUNT(*),
    ARTISTNAME
FROM STREAMINGHISTORY
WHERE dayofweek(PLAYED_ON) = 2 AND HOUR(PLAYED_ON) IN ('8','9','10','11','12')
GROUP BY ARTISTNAME ORDER BY 1 DESC ;

-- SELECT ARTIST LISTENED ON MONDAY AFTERNOON:
SELECT
    COUNT(*),
    ARTISTNAME
FROM STREAMINGHISTORY
WHERE dayofweek(PLAYED_ON) = 2 AND HOUR(PLAYED_ON) IN ('16','17','18','19','20','21')
GROUP BY ARTISTNAME ORDER BY 1 DESC ;

-- SELECT LAST SONG PLAYED

SELECT *
FROM STREAMINGHISTORY
WHERE PLAYED_ON = (SELECT MAX(PLAYED_ON) FROM STREAMINGHISTORY);

-- SELECT MUSIC PLAYED ON MONDAYS MORNING
SELECT *
FROM STREAMINGHISTORY
WHERE DAYOFWEEK(PLAYED_ON) = 2 AND HOUR(PLAYED_ON) IN ('8','9','10','11','12');

-- SELECT MUSIC PLAYED ON WEEKENDS:
SELECT
    COUNT(*),
    ARTISTNAME
FROM STREAMINGHISTORY
WHERE dayofweek(PLAYED_ON) IN (6,7,1)
GROUP BY ARTISTNAME ORDER BY 1 DESC ;

SELECT * 
FROM STREAMINGHISTORY
WHERE ARTISTNAME = 'Brainy';

-- PLAYS BY DAY
SELECT COUNT(*) PLAYED_ON,DAYOFWEEK(PLAYED_ON)
FROM STREAMINGHISTORY
GROUP BY DAYOFWEEK(PLAYED_ON);

SELECT DAYNAME(PLAYED_ON), COUNT(*)
FROM STREAMINGHISTORY
GROUP BY DAYNAME(PLAYED_ON);

-- PLAYS BY DAY AND MONTH
SELECT MONTH(PLAYED_ON), DAYOFWEEK(PLAYED_ON), COUNT(*) PLAYED_ON
FROM STREAMINGHISTORY
GROUP BY MONTH(PLAYED_ON), DAYOFWEEK(PLAYED_ON)
ORDER BY 1, 2;

-- PLAYS BY DAY AND MONTH
SELECT MONTHNAME(PLAYED_ON), DAYNAME(PLAYED_ON), COUNT(*) PLAYED_ON
FROM STREAMINGHISTORY
GROUP BY MONTHNAME(PLAYED_ON), DAYNAME(PLAYED_ON)
ORDER BY 1, 2;

-- PLAYS BY HOURS:
SELECT HOUR(PLAYED_ON), COUNT(*) PLAYED_ON
FROM STREAMINGHISTORY
GROUP BY HOUR(PLAYED_ON)
ORDER BY 2 DESC;

-- PLAYS BY MONTH:
SELECT MONTH(PLAYED_ON), COUNT(*) PLAYED_ON
FROM STREAMINGHISTORY
GROUP BY MONTH (PLAYED_ON)
ORDER BY 2 DESC;
