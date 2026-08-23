-- Review how average life expectancy changed over time.
SELECT 
	Year,
	ROUND(AVG(life_expectancy), 2) AS average_life_expectancy
FROM world_life_expectancy
GROUP BY Year
HAVING average_life_expectancy > 0
ORDER BY Year
;


-- Compare average life expectancy between Developed and Developing countries.
SELECT 
	Status,
	ROUND(AVG(life_expectancy), 2) AS average_life_expectancy
FROM world_life_expectancy
GROUP BY Status
HAVING average_life_expectancy > 0
ORDER BY average_life_expectancy DESC
;


-- Identify the 10 countries with the highest average life expectancy.
SELECT 
	Country,
	ROUND(AVG(life_expectancy), 2) AS average_life_expectancy
FROM world_life_expectancy
GROUP BY Country
HAVING average_life_expectancy > 0
ORDER BY average_life_expectancy DESC
LIMIT 10
;


-- Identify the 10 countries with the lowest average life expectancy, excluding countries with an average life expectancy of 0.
SELECT 
	Country,
	ROUND(AVG(life_expectancy), 2) AS average_life_expectancy
FROM world_life_expectancy
GROUP BY Country
HAVING average_life_expectancy > 0
ORDER BY average_life_expectancy ASC
LIMIT 10
;


-- Compare average life expectancy across different schooling levels.
SELECT 
	CASE
		WHEN Schooling < 8 THEN 'Low Schooling'
		WHEN Schooling BETWEEN 8 AND 12 THEN 'Medium Schooling'
		ELSE 'High Schooling'
	END AS schooling_level,
	ROUND(AVG(life_expectancy), 2) AS average_life_expectancy
FROM world_life_expectancy
WHERE Schooling > 0
GROUP BY schooling_level
HAVING average_life_expectancy > 0
ORDER BY average_life_expectancy
;


-- Compare average life expectancy across different GDP ranges.
SELECT 
	CASE
		WHEN GDP < 1000 THEN 'Under 1,000'
		WHEN GDP < 5000 THEN '1,000 - 4,999'
		WHEN GDP < 10000 THEN '5,000 - 9,999'
		ELSE '10,000+'
	END AS GDP_range,
	ROUND(AVG(life_expectancy), 2) AS average_life_expectancy
FROM world_life_expectancy
WHERE GDP > 0
GROUP BY GDP_range
HAVING average_life_expectancy > 0
ORDER BY average_life_expectancy
;


-- Identify the countries with the greatest increase in life expectancy between 2007 and 2022.
SELECT 
	Country,
	MAX(CASE WHEN Year = 2007 THEN life_expectancy END) AS life_expectancy_2007,
	MAX(CASE WHEN Year = 2022 THEN life_expectancy END) AS life_expectancy_2022,
	ROUND(
		MAX(CASE WHEN Year = 2022 THEN life_expectancy END) -
		MAX(CASE WHEN Year = 2007 THEN life_expectancy END),
		2
	) AS life_expectancy_change
FROM world_life_expectancy
GROUP BY Country
HAVING life_expectancy_2007 > 0
AND life_expectancy_2022 > 0
ORDER BY life_expectancy_change DESC
LIMIT 10
;