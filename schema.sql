CREATE DATABASE germany_rainfall;

USE germany_rainfall;

CREATE TABLE rainfall
(
city VARCHAR(12),
latit DOUBLE,
longit DOUBLE,
month_ INT,
year_ INT,
rainfall_mm DOUBLE,
elevation_m INT,
climate_type VARCHAR(12),
temperature DOUBLE,
humidity INT
);

SELECT *
FROM rainfall;

