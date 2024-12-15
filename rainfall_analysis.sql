-- 1. Which city recorded the highest and lowest average annual rainfall for each year between 2015 and 2023?

-- i) Highest average annual rainfall
SELECT 
	year_, 
    city, 
    avg_rainfall AS 'Highest avg. annual rainfall (mm)'
FROM
	(SELECT 
		year_, 
        city, 
        ROUND(AVG(rainfall_mm), 2) avg_rainfall, 
        RANK() OVER(PARTITION BY year_ ORDER BY ROUND(AVG(rainfall_mm), 2) DESC) AS rn
	FROM
		rainfall
		GROUP BY 1, 2) a
WHERE rn < 2;

-- ii) Lowest average annual rainfall
SELECT 
	year_, 
    city, 
    avg_rainfall AS 'Lowest avg. annual rainfall (mm)'
FROM
	(SELECT 
		year_, 
        city, 
        ROUND(AVG(rainfall_mm), 2) avg_rainfall, 
        RANK() OVER(PARTITION BY year_ ORDER BY ROUND(AVG(rainfall_mm), 2) ASC) AS rn
	FROM
		rainfall
		GROUP BY 1, 2) a
WHERE rn < 2;

-- 2. How has rainfall varied over the years across different cities or regions in Germany?

/*
SELECT DISTINCT(city)
FROM rainfall;

Berlin, Munich, Hamburg, Cologne, Frankfurt, Stuttgart, Dusseldorf, Dresden, Leipzig, Hanover
*/

SELECT
	year_,
    MAX(CASE WHEN city = 'Berlin' THEN avg_rainfall ELSE NULL END) AS Avg_Berlin_Rain,
    MAX(CASE WHEN city = 'Munich' THEN avg_rainfall ELSE NULL END) AS Avg_Munich_Rain,
    MAX(CASE WHEN city = 'Hamburg' THEN avg_rainfall ELSE NULL END) AS Avg_Hamburg_Rain,
    MAX(CASE WHEN city = 'Cologne' THEN avg_rainfall ELSE NULL END) AS Avg_Cologne_Rain,
    MAX(CASE WHEN city = 'Frankfurt' THEN avg_rainfall ELSE NULL END) AS Avg_Frankfurt_Rain,
    MAX(CASE WHEN city = 'Stuttgart' THEN avg_rainfall ELSE NULL END) AS Avg_Stuttgart_Rain,
    MAX(CASE WHEN city = 'Dusseldorf' THEN avg_rainfall ELSE NULL END) AS Avg_Dusseldorf_Rain,
    MAX(CASE WHEN city = 'Dresden' THEN avg_rainfall ELSE NULL END) AS Avg_Dresden_Rain,
    MAX(CASE WHEN city = 'Leipzig' THEN avg_rainfall ELSE NULL END) AS Avg_Leipzig_Rain,
    MAX(CASE WHEN city = 'Hanover' THEN avg_rainfall ELSE NULL END) AS Avg_Hanover_Rain
FROM
	(SELECT year_, city, ROUND(AVG(rainfall_mm),2) AS avg_rainfall
	FROM rainfall
	GROUP BY 1, 2) a
GROUP BY 1
ORDER BY 1;

-- 3. Which months typically receive the most and least rainfall on average?

-- i) Most rainfall on average 
SELECT MONTHNAME(STR_TO_DATE(month_, '%m')) AS 'MONTH', ROUND(AVG(rainfall_mm), 2) AS 'Avg Rainfall (mm)'
FROM rainfall
GROUP BY 1 ORDER BY 2 DESC LIMIT 1;

-- ii) Least rainfall on average
SELECT MONTHNAME(STR_TO_DATE(month_, '%m')) AS 'MONTH', ROUND(AVG(rainfall_mm), 2) AS 'Avg Rainfall (mm)'
FROM rainfall
GROUP BY 1 ORDER BY 2 LIMIT 1;

-- 4. Which cities recorded the highest and lowest average temperatures for each season over the years?

-- Highest seasonal average temperature
SELECT year_, city, season,
    avg_temp AS 'Highest Average Temperature'
FROM
	(SELECT year_, city,
    CASE
		WHEN month_ in (12, 1, 2) THEN 'Winter'
        WHEN month_ in (3, 4, 5) THEN 'Spring'
        WHEN month_ in (6, 7, 8) THEN 'Summer'
        WHEN month_ in (9, 10, 11) THEN 'Autumn'
	END AS season,
    ROUND(AVG(temperature), 1) AS avg_temp,
    RANK() OVER(PARTITION BY year_, city ORDER BY ROUND(AVG(temperature), 1) DESC) AS rnk
	FROM rainfall
	GROUP BY 1, 2, 3) a
WHERE rnk = 1;

-- Lowest seasonal average temperature
SELECT year_, city, season,
    avg_temp AS 'Lowest Average Temperature'
FROM
	(SELECT year_, city,
    CASE
		WHEN month_ in (12, 1, 2) THEN 'Winter'
        WHEN month_ in (3, 4, 5) THEN 'Spring'
        WHEN month_ in (6, 7, 8) THEN 'Summer'
        WHEN month_ in (9, 10, 11) THEN 'Autumn'
	END AS season,
    ROUND(AVG(temperature), 1) AS avg_temp,
    RANK() OVER(PARTITION BY year_, city ORDER BY ROUND(AVG(temperature), 1) ASC) AS rnk
	FROM rainfall
	GROUP BY 1, 2, 3) a
WHERE rnk = 1;

-- 5. Which city had the highest and lowest average temperature in each year?

-- i) Highest average annual temperature
SELECT 
	year_, 
    city, 
    avg_temp AS 'Highest avg. annual temperature'
FROM
	(SELECT 
		year_, 
        city, 
        ROUND(AVG(temperature), 1) avg_temp, 
        RANK() OVER(PARTITION BY year_ ORDER BY ROUND(AVG(temperature), 1) DESC) AS rn
	FROM
		rainfall
		GROUP BY 1, 2) a
WHERE rn < 2;

-- ii) Lowest average annual temperature
SELECT 
	year_, 
    city, 
    avg_temp AS 'Lowest avg. annual temperature'
FROM
	(SELECT 
		year_, 
        city, 
        ROUND(AVG(temperature), 1) avg_temp, 
        RANK() OVER(PARTITION BY year_ ORDER BY ROUND(AVG(temperature), 1) ASC) AS rn
	FROM
		rainfall
		GROUP BY 1, 2) a
WHERE rn < 2;

-- 6. What are the maximum and minimum temperatures recorded for each year between 2015 and 2023?

-- i) Maximum temperature recorded for each year
SELECT year_, city, month_name, temperature
FROM
	(SELECT year_, 
    city, 
    MONTHNAME(STR_TO_DATE(month_, '%m')) AS month_name, 
    temperature, 
    RANK() OVER(PARTITION BY year_ ORDER BY temperature DESC) AS rnk 
	FROM rainfall
	GROUP BY 1, 2, 3) a
WHERE rnk = 1;

-- ii) Minimum temperature recorded for each year
SELECT year_, city, month_name, temperature
FROM
	(SELECT year_, 
	city, 
	MONTHNAME(STR_TO_DATE(month_, '%m')) AS month_name, 
	temperature, 
	RANK() OVER(PARTITION BY year_ ORDER BY temperature ASC) AS rnk 
	FROM rainfall
	GROUP BY 1, 2, 3) a
WHERE rnk = 1;

-- 7. Which cities experience the highest and lowest humidity levels for each year between 2015 and 2023?

-- i) Highest humidity levels for each year
SELECT year_, city, month_name, humidity
FROM
	(SELECT year_, 
    city, 
    MONTHNAME(STR_TO_DATE(month_, '%m')) AS month_name, 
    humidity, 
    RANK() OVER(PARTITION BY year_ ORDER BY humidity DESC) AS rnk 
	FROM rainfall
	GROUP BY 1, 2, 3) a
WHERE rnk = 1;

-- ii) Lowest humidity levels for each year
SELECT year_, city, month_name, humidity
FROM
	(SELECT year_, 
    city, 
    MONTHNAME(STR_TO_DATE(month_, '%m')) AS month_name, 
    humidity, 
    RANK() OVER(PARTITION BY year_ ORDER BY humidity ASC) AS rnk 
	FROM rainfall
	GROUP BY 1, 2, 3) a
WHERE rnk = 1;

-- 8. Identify periods of high thermal discomfort in cities due to elevated temperatures (27°C or above) combined with high humidity (above 60%)?

SELECT 
	year_, 
    MONTHNAME(STR_TO_DATE(month_, '%m')) AS month_name, 
    city
FROM 
	rainfall
WHERE 
	temperature >= 27 AND humidity > 60
ORDER BY 1;

-- 9. Are there any cities with a significant increase in the frequency of heavy rainfall events?

WITH HeavyRainfallEvents AS(
SELECT city, year_, COUNT(*) AS heavy_rainfall_count
FROM rainfall
WHERE rainfall_mm > 50
GROUP BY 1, 2
)
SELECT city, year_, heavy_rainfall_count, prev_year_count, diff
FROM(
	SELECT city, year_, heavy_rainfall_count,
		LAG(heavy_rainfall_count, 1) OVER(PARTITION BY city ORDER BY year_) AS prev_year_count,
		heavy_rainfall_count - LAG(heavy_rainfall_count, 1) OVER(PARTITION BY city ORDER BY year_) AS diff
	FROM 
		HeavyRainfallEvents
) a
WHERE diff > 0
ORDER BY 1, 2;

-- 10. What is the correlation between temperature and humidity levels in different cities during summer months?

SELECT 
    city,
    ROUND((n * sum_xy - sum_x * sum_y) / 
    SQRT((n * sum_x2 - sum_x * sum_x) * (n * sum_y2 - sum_y * sum_y)), 2) AS temp_humidity_correlation
FROM (
    SELECT 
        city,
        COUNT(*) AS n,
        SUM(temperature) AS sum_x,
        SUM(humidity) AS sum_y,
        SUM(temperature * humidity) AS sum_xy,
        SUM(temperature * temperature) AS sum_x2,
        SUM(humidity * humidity) AS sum_y2
    FROM 
        rainfall
    WHERE 
        month_ IN (6, 7, 8)
    GROUP BY 
        1
) AS stats
ORDER BY 1;

-- 11. Which year had the most significant anomalies in temperature and rainfall across cities?

-- Calculate Long-term Averages
WITH LongTermAverages AS(
	SELECT
		AVG(temperature) AS overall_avg_temp,
        AVG(rainfall_mm) AS overall_avg_rain
	FROM
		rainfall
),
-- Calculate Yearly Averages and Anomalies
YearlyAnomalies AS(
	SELECT
		year_,
        AVG(temperature) AS yearly_avg_temp,
        AVG(rainfall_mm) AS yearly_avg_rain,
        ROUND(AVG(temperature) - (SELECT overall_avg_temp FROM LongTermAverages), 2) AS temp_anomaly,
        ROUND(AVG(rainfall_mm) - (SELECT overall_avg_rain FROM LongTermAverages), 2) AS rain_anomaly
	FROM
		rainfall
	GROUP BY
		1
)
-- Identify the year with the most significant anomalies
SELECT
	year_,
    temp_anomaly,
    rain_anomaly,
    ABS(temp_anomaly) + ABS(rain_anomaly) AS total_anomaly
FROM 
	YearlyAnomalies
ORDER BY
	4 DESC
LIMIT 1;


