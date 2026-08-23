-- View original dataset before making any changes.
SELECT *
FROM world_life_expectancy
; 

-- Identify duplicate records based on Country and Year.
SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM world_life_expectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1
; 

-- Assign row numbers to duplicate Country and Year combinations.
-- to identify which duplicate records should be removed.
SELECT * 
FROM (
	SELECT Row_ID, 
	CONCAT(Country, Year),
	ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
	FROM world_life_expectancy
    ) AS Row_Table
WHERE Row_Num > 1
;

-- Create backup table before modifying the original dataset.
CREATE TABLE world_life_expectancy_backup
LIKE world_life_expectancy
;

-- Copy all original records into the backup table.
INSERT INTO world_life_expectancy_backup
SELECT *
FROM world_life_expectancy
;

-- Verify that the original and backup tables contain the same number of records.
SELECT COUNT(*)
FROM world_life_expectancy;

SELECT COUNT(*)
FROM world_life_expectancy_backup;

-- Remove duplicates records while keeping one record for each Country and Year.
DELETE FROM world_life_expectancy
WHERE 
	Row_ID IN (
    SELECT Row_ID
FROM (
	SELECT Row_ID, 
	CONCAT(Country, Year),
	ROW_NUMBER() OVER(PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
	FROM world_life_expectancy
    ) AS Row_Table
WHERE Row_Num > 1
)
;

-- Identify records with missing Status values.
SELECT *
FROM world_life_expectancy
WHERE Status = ''
; 

-- Review the valid Status categories in the dataset.
SELECT DISTINCT(Status)
FROM world_life_expectancy
WHERE Status <> '' 
; 

-- Identify countries classified as Developing.
SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing'
;

-- Fill missing Status values by matching countries with existing Developing records.
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.country = t2.country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing'
;

-- Review United States records to verify its development status.
SELECT *
FROM world_life_expectancy
WHERE Country = 'United States of America'
; 

-- Fill missing Status values by matching countries with existing Developed records.
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.country = t2.country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed'
;

-- Review the dataset after standardizing Status values.
SELECT *
FROM world_life_expectancy
;

-- Identify records with missing life expectancy values.
SELECT *
FROM world_life_expectancy
WHERE life_expectancy = ''
;

-- Review life expectancy values by country and year.
SELECT Country, Year, life_expectancy
FROM world_life_expectancy
;

-- Calculate replacement values for missing life expectancy records using the average of the previous and following years.
SELECT t1.Country, t1.Year, t1.life_expectancy, 
t2.Country, t2.Year, t2.life_expectancy,
t3.Country, t3.Year, t3.life_expectancy,
ROUND((t2.life_expectancy + t3.life_expectancy)/2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.life_expectancy = ''
;

-- Populate missing life expectancy values using the average of the previous and following years for the same country.
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
SET t1.life_expectancy = ROUND((t2.life_expectancy + t3.life_expectancy)/2,1)
WHERE t1.life_expectancy = ''
;

-- Review the final cleaned dataset.
SELECT *
FROM world_life_expectancy
;









