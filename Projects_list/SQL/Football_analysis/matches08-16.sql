SELECT 
    name
FROM 
    sqlite_schema
WHERE 
    type ='table' AND 
    name NOT LIKE 'sqlite_%';
	
SELECT COUNT(*)
FROM pragma_table_info('Match');

SELECT *
FROM pragma_table_info('Match');
	
SELECT COUNT(*) FROM Match;

SELECT COUNT(DISTINCT(match_api_id)) AS Quantity_Games FROM Match
-- Each Row is a game

-- How many countries:
SELECT COUNT(DISTINCT(country_id)) NUMBER_OF_COUNTRIES FROM Match

SELECT DISTINCT(name) COUNTRY_NAME FROM Country

-- This database has records of 25,979 games of 11 countries and its first leagues. 

--How many teams per league and season:
SELECT c.name Country_name, l.name League_name, m.season, 
COUNT(DISTINCT(m.home_team_api_id)) NUMBER_OF_TEAMS FROM Match m
INNER JOIN Country c ON m.country_id = c.id
INNER JOIN League l on m.league_id = l.id
GROUP BY 1,2,3

--How many teams per country and league:
SELECT c.name Country_name, l.name League_name,
COUNT(DISTINCT(m.home_team_api_id)) NUMBER_OF_TEAMS FROM Match m
INNER JOIN Country c ON m.country_id = c.id
INNER JOIN League l on m.league_id = l.id
GROUP BY 1,2 ORDER BY 3  DESC

--How many teams per country and league WITH PERCENTAGE
WITH TOTAL_TEAMS AS (
SELECT c.name Country_name, l.name League_name,
COUNT(DISTINCT(m.home_team_api_id)) NUMBER_OF_TEAMS FROM Match m
INNER JOIN Country c ON m.country_id = c.id
INNER JOIN League l on m.league_id = l.id
GROUP BY 1,2 ORDER BY 3  DESC)
SELECT *, 
ROUND(NUMBER_OF_TEAMS*100.00/(SELECT sum(NUMBER_OF_TEAMS) FROM TOTAL_TEAMS),2) as 'PERCENTAGE OF TOTAL'
FROM TOTAL_TEAMS
GROUP BY Country_name, League_name
ORDER BY 4 DESC

--How many teams per country and league WITH PERCENTAGE V2:
SELECT c.name Country_name, l.name League_name,
COUNT(DISTINCT(m.home_team_api_id)) NUMBER_OF_TEAMS,
ROUND(COUNT(DISTINCT(m.home_team_api_id)) *100.00/(SELECT sum(COUNT(DISTINCT(home_team_api_id))) FROM Match),2) as 'PERCENTAGE OF TOTAL' 
FROM Match m
INNER JOIN Country c ON m.country_id = c.id
INNER JOIN League l on m.league_id = l.id
GROUP BY 1,2 ORDER BY 3  DESC

-- TOTAL MATCHES BY COUNTRY AND LEAGUE
SELECT c.name Country_name, l.name League_name, COUNT(*) Q_GAMES FROM Match m
INNER JOIN Country c ON m.country_id = c.id
INNER JOIN League l on m.league_id = l.id
GROUP BY c.name, l.name ORDER BY 3 DESC

-- TOTAL MATCHES AND PERCENTAGE BY LEAGUE
WITH GEN_GAMES AS (
SELECT c.name Country_name, l.name League_name, COUNT(*) Q_GAMES FROM Match m
INNER JOIN Country c ON m.country_id = c.id
INNER JOIN League l on m.league_id = l.id
GROUP BY c.name, l.name ORDER BY 3 DESC)
SELECT *, ROUND(Q_GAMES*100.00/(SELECT SUM(Q_GAMES) FROM GEN_GAMES),2) AS 'PERCENTAGE OF TOTAL'
FROM GEN_GAMES
GROUP BY Country_name, League_name
ORDER BY 4 DESC       

-- Another way for percentage
SELECT  l.name League_name, COUNT(*) Q_GAMES, ROUND(COUNT(*)*100.00/(SELECT COUNT(*) FROM Match),2) as 'PERCENTAGE OF TOTAL'
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

-- Quantity of home and away goals BY league.
SELECT l.name AS League_name, 
SUM(m.home_team_goal) as Home_Goals,
SUM(m.away_team_goal) as Away_Goals,
SUM(m.home_team_goal) + SUM(m.away_team_goal) AS TOTAL_GOALS
FROM Match m
INNER JOIN League l on m.league_id = l.id
GROUP BY 1 ORDER BY 4 DESC

-- AVERAGE GOALS BY LEAGUE
SELECT l.name AS League_name, 
ROUND(AVG(m.home_team_goal),2) as AVG_Home_Goals,
ROUND(AVG(m.away_team_goal),2) as AVG_Away_Goals,
ROUND(AVG(m.home_team_goal) + AVG(m.away_team_goal),2) AS AVG_TOTAL_GOALS
FROM Match m
INNER JOIN League l on m.league_id = l.id
GROUP BY 1 ORDER BY 4 DESC

-- Quantity of home and away goals BY league and season
SELECT l.name AS League_name, m.season,
SUM(m.home_team_goal) as Home_Goals,
SUM(m.away_team_goal) as Away_Goals,
SUM(m.home_team_goal) + SUM(m.away_team_goal) AS TOTAL_GOALS,
RANK() OVER (PARTITION BY m.season order by SUM(m.home_team_goal) + SUM(m.away_team_goal)  DESC) as Rank_League_Season
FROM Match m
INNER JOIN League l on m.league_id = l.id
WHERE l.name in ('Spain LIGA BBVA','Italy Serie A', 'England Premier League','Germany 1. Bundesliga','France Ligue 1')
GROUP BY 1,2 ORDER BY 2 ASC,  5 DESC


-- AVERAGE GOALS BY LEAGUE AND SEASON
SELECT l.name AS League_name, m.season,
ROUND(AVG(m.home_team_goal),2) as AVG_Home_Goals,
ROUND(AVG(m.away_team_goal),2) as AVG_Away_Goals,
ROUND(AVG(m.home_team_goal) + AVG(m.away_team_goal),2) AS AVG_TOTAL_GOALS,
RANK() OVER (PARTITION BY m.season order by AVG(m.home_team_goal) + AVG(m.away_team_goal) DESC) as Rank_League_Season
FROM Match m
INNER JOIN League l on m.league_id = l.id
WHERE l.name in ('Spain LIGA BBVA','Italy Serie A', 'England Premier League','Germany 1. Bundesliga','France Ligue 1')
GROUP BY 1,2 

-- How many games in Serie A:
SELECT l.name League_name, m.season, COUNT(match_api_id) Quantity_GAMES FROM Match m
INNER JOIN League l on m.league_id = l.id
WHERE l.name = 'Italy Serie A'
GROUP BY l.name, m.season ORDER BY 2 

-- TOTAL AS ROMA GAMES 
SELECT COUNT(*) as ASROMA_TOTAL_GAMES
FROM Match m
INNER JOIN Team t on m.home_team_api_id = t.team_api_id
INNER JOIN Team t2 on m.away_team_api_id = t2.team_api_id
WHERE t.team_short_name = 'ROM' OR t2.team_short_name = 'ROM'

-- AS ROMA GAMES BY SEASON
SELECT m.season, COUNT(*) TOTAL_GAMES
FROM Match m
INNER JOIN Team t on m.home_team_api_id = t.team_api_id
INNER JOIN Team t2 on m.away_team_api_id = t2.team_api_id
WHERE t.team_short_name = 'ROM' OR t2.team_short_name = 'ROM'
GROUP BY 1

-- AS ROMA SEASON 2011/2012
	SELECT m.season, t.team_short_name AS HOME_TEAM,
	t2.team_short_name AS AWAY_TEAM,
	m.home_team_goal as Home_Goals,
	m.away_team_goal as Away_Goals
	FROM Match m
	INNER JOIN Team t on m.home_team_api_id = t.team_api_id
	INNER JOIN Team t2 on m.away_team_api_id = t2.team_api_id
	WHERE (t.team_short_name = 'ROM' OR t2.team_short_name = 'ROM') AND m.league_id='10257' AND m.season = '2011/2012'

-- ASROMA GOALS BY SEASON 
SELECT m.season, 
SUM(CASE WHEN t.team_short_name = 'ROM' THEN m.home_team_goal ELSE 0 END)  + SUM(CASE WHEN t2.team_short_name= 'ROM' THEN m.away_team_goal  ELSE 0 END) TOTAL_SCORED_GOALS,
SUM(CASE WHEN t.team_short_name <> 'ROM' THEN m.home_team_goal ELSE 0 END)  + SUM(CASE WHEN t2.team_short_name<> 'ROM' THEN m.away_team_goal  ELSE 0 END) TOTAL_ALLOWED_GOALS
FROM Match m
INNER JOIN Team t on m.home_team_api_id = t.team_api_id
INNER JOIN Team t2 on m.away_team_api_id = t2.team_api_id
WHERE t.team_short_name = 'ROM' OR t2.team_short_name = 'ROM'
GROUP BY 1

-- ASROMA GOALS SCORED AND ALLOWED 
SELECT 
SUM(CASE WHEN t.team_short_name = 'ROM' THEN m.home_team_goal ELSE 0 END)  + SUM(CASE WHEN t2.team_short_name= 'ROM' THEN m.away_team_goal  ELSE 0 END) TOTAL_SCORED_GOALS,
SUM(CASE WHEN t.team_short_name <> 'ROM' THEN m.home_team_goal ELSE 0 END)  + SUM(CASE WHEN t2.team_short_name<> 'ROM' THEN m.away_team_goal  ELSE 0 END) TOTAL_ALLOWED_GOALS
FROM Match m
INNER JOIN Team t on m.home_team_api_id = t.team_api_id
INNER JOIN Team t2 on m.away_team_api_id = t2.team_api_id
WHERE t.team_short_name = 'ROM' OR t2.team_short_name = 'ROM'

-- THIS IS ANOTHER WAY - ROMA GOALS PER SEASON
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

-- AS ROMA POINTS PER SEASON
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
SELECT season, SUM(POINTS) AS TOTAL_POINTS
FROM ROMASEASON
GROUP BY season
