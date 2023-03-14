SELECT COUNT(*) FROM Match;

SELECT COUNT(DISTINCT(country_id)) FROM Match

SELECT COUNT(DISTINCT(league_id)) FROM Match

-- This database has records of 25,979 games of 11 countries and its first leagues. 

SELECT c.name Country_name, l.name League_name, season FROM Match m
INNER JOIN Country c ON m.country_id = c.id
INNER JOIN League l on m.league_id = l.id

-- TOTAL MATCHES BY COUNTRY AND LEAGUE
SELECT c.name Country_name, l.name League_name, COUNT(*) Q_GAMES FROM Match m
INNER JOIN Country c ON m.country_id = c.id
INNER JOIN League l on m.league_id = l.id
GROUP BY c.name, l.name ORDER BY 3 DESC

WITH GEN_GAMES AS (
SELECT c.name Country_name, l.name League_name, COUNT(*) Q_GAMES FROM Match m
INNER JOIN Country c ON m.country_id = c.id
INNER JOIN League l on m.league_id = l.id
GROUP BY c.name, l.name ORDER BY 3 DESC)
SELECT *, ROUND(Q_GAMES/(SELECT SUM(Q_GAMES) FROM GEN_GAMES),2) AS 'PERCENTAGE OF TOTAL'
FROM GEN_GAMES
GROUP BY Country_name, League_name

-- TOTAL MATCHES AND PERCENTAGE BY LEAGUE
SELECT  l.name League_name, COUNT(*) Q_GAMES, ROUND(COUNT(*)*100.00/(SELECT COUNT(*) FROM Match)) as 'PERCENTAGE OF TOTAL'
 FROM Match m
INNER JOIN League l on m.league_id = l.id
GROUP BY l.name ORDER BY 2 DESC

SELECT COUNT(*) FROM Team

-- IT HAS THE STATS FOR 299 TEAMS

-- QUANTITY OF TEAMS RECORDED IN MATCH TABLE
SELECT COUNT(DISTINCT(home_team_api_id)), COUNT(DISTINCT(away_team_api_id))
FROM Match

-- Quantity of teams (home and away) recorded by league
SELECT l.name AS League_name, 
COUNT(DISTINCT(m.home_team_api_id)) AS QUANTITY_OF_HOMETEAMS, 
COUNT(DISTINCT(m.away_team_api_id)) AS QUANTITY_OF_AWAYTEAMS 
FROM Match m
INNER JOIN League l on m.league_id = l.id
GROUP BY 1 ORDER BY 2 DESC

-- How many games per league each season
SELECT l.name League_name, m.season, COUNT(match_api_id) Q_GAMES FROM Match m
INNER JOIN League l on m.league_id = l.id
GROUP BY l.name, m.season ORDER BY 1,2 

-- Quantity of teams (home and away) recorded by league and season
SELECT l.name AS League_name, m.season,
COUNT(DISTINCT(m.home_team_api_id)) AS QUANTITY_OF_HOMETEAMS, 
COUNT(DISTINCT(m.away_team_api_id)) AS QUANTITY_OF_AWAYTEAMS 
FROM Match m
INNER JOIN League l on m.league_id = l.id
GROUP BY 1,2 ORDER BY 2

-- ASROMA GOALS BY SEASON 
SELECT m.season, t.team_short_name AS HOME_TEAM,
t2.team_short_name AS AWAY_TEAM,
m.home_team_goal as Home_Goals,
m.away_team_goal as Away_Goals
FROM Match m
INNER JOIN Team t on m.home_team_api_id = t.team_api_id
INNER JOIN Team t2 on m.away_team_api_id = t2.team_api_id
WHERE t.team_short_name = 'ROM' OR t2.team_short_name = 'ROM'


-- THIS IS THE RIGHT - ROMA GOALS PER SEASON
WITH ROMA_GAMES AS (
SELECT m.season, t.team_short_name AS HOME_TEAM,
t2.team_short_name AS AWAY_TEAM,
m.home_team_goal as Home_Goals,
m.away_team_goal as Away_Goals
FROM Match m
INNER JOIN Team t on m.home_team_api_id = t.team_api_id
INNER JOIN Team t2 on m.away_team_api_id = t2.team_api_id
WHERE t.team_short_name = 'ROM' OR t2.team_short_name = 'ROM')
SELECT season,  SUM(CASE WHEN HOME_TEAM = 'ROM' THEN Home_Goals ELSE 0 END) TOTAL_HOME_GOALS,
SUM(CASE WHEN AWAY_TEAM = 'ROM' THEN Away_Goals ELSE 0 END) TOTAL_AWAY_GOALS,
SUM(CASE WHEN AWAY_TEAM = 'ROM' THEN Away_Goals ELSE 0 END) + SUM(CASE WHEN HOME_TEAM = 'ROM' THEN Home_Goals ELSE 0 END) AS TOTAL_GOALS_PER_SEASON
FROM ROMA_GAMES
GROUP BY season


-- Roma games, goals and points
SELECT m.season, t.team_short_name AS HOME_TEAM,
t2.team_short_name AS AWAY_TEAM,
m.home_team_goal as Home_Goals,
m.away_team_goal as Away_Goals,
CASE 
WHEN t.team_short_name = 'ROM' AND m.home_team_goal = m.away_team_goal THEN 1
WHEN t2.team_short_name = 'ROM' AND m.home_team_goal = m.away_team_goal THEN 1
WHEN t.team_short_name = 'ROM' AND m.home_team_goal > m.away_team_goal THEN 3
WHEN t2.team_short_name = 'ROM' AND m.home_team_goal < m.away_team_goal THEN 3
ELSE 0 END AS POINTS
FROM Match m
INNER JOIN Team t on m.home_team_api_id = t.team_api_id
INNER JOIN Team t2 on m.away_team_api_id = t2.team_api_id
WHERE t.team_short_name = 'ROM' OR t2.team_short_name = 'ROM' AND m.season = '2008/2009'

-- Roma points per season
WITH ROMASEASON AS (
SELECT m.season, t.team_short_name AS HOME_TEAM,
t2.team_short_name AS AWAY_TEAM,
m.home_team_goal as Home_Goals,
m.away_team_goal as Away_Goals,
CASE 
WHEN t.team_short_name = 'ROM' AND m.home_team_goal = m.away_team_goal THEN 1
WHEN t2.team_short_name = 'ROM' AND m.home_team_goal = m.away_team_goal THEN 1
WHEN t.team_short_name = 'ROM' AND m.home_team_goal > m.away_team_goal THEN 3
WHEN t2.team_short_name = 'ROM' AND m.home_team_goal < m.away_team_goal THEN 3
ELSE 0 END AS POINTS
FROM Match m
INNER JOIN Team t on m.home_team_api_id = t.team_api_id
INNER JOIN Team t2 on m.away_team_api_id = t2.team_api_id
WHERE t.team_short_name = 'ROM' OR t2.team_short_name = 'ROM')
SELECT season, SUM(POINTS)
FROM ROMASEASON
GROUP BY season
