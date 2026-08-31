--- USING THE REQUIRED DATABASE
USE hyderabadmetrotransitanalytics;

--- QUERIES WITH SELF JOIN

---Compare Stations in the Same Fare Zone
SELECT
    s1.stop_name AS station_1,
    s2.stop_name AS station_2,
    s1.zone_id
FROM stops AS s1
INNER JOIN stops AS s2
    ON s1.zone_id = s2.zone_id
   AND s1.stop_id < s2.stop_id
WHERE s1.location_type = 1
  AND s2.location_type = 1;

---Find Stations With the Same Zone
SELECT
    s1.stop_id AS station_1_id,
    s1.stop_name AS station_1_name,
    s2.stop_id AS station_2_id,
    s2.stop_name AS station_2_name,
    s1.zone_id
FROM stops AS s1
INNER JOIN stops AS s2
    ON s1.zone_id = s2.zone_id
   AND s1.stop_id <> s2.stop_id
WHERE s1.location_type = 1
  AND s2.location_type = 1;

---Compare Stations With Similar Names
SELECT
    s1.stop_name AS station_1,
    s2.stop_name AS station_2
FROM stops AS s1
INNER JOIN stops AS s2
    ON s1.stop_name = s2.stop_name
   AND s1.stop_id < s2.stop_id
WHERE s1.location_type = 1
  AND s2.location_type = 1;

---Find Stations With Identical Latitude
SELECT
    s1.stop_name AS station_1,
    s2.stop_name AS station_2,
    s1.stop_lat
FROM stops AS s1
INNER JOIN stops AS s2
    ON s1.stop_lat = s2.stop_lat
   AND s1.stop_id < s2.stop_id
WHERE s1.location_type = 1
  AND s2.location_type = 1;

---Find Stations With Identical Longitude
SELECT
    s1.stop_name AS station_1,
    s2.stop_name AS station_2,
    s1.stop_lon
FROM stops AS s1
INNER JOIN stops AS s2
    ON s1.stop_lon = s2.stop_lon
   AND s1.stop_id < s2.stop_id
WHERE s1.location_type = 1
  AND s2.location_type = 1;

---Find Stations With the Same Latitude and Longitude
SELECT
    s1.stop_id AS station_1_id,
    s1.stop_name AS station_1_name,
    s2.stop_id AS station_2_id,
    s2.stop_name AS station_2_name,
    s1.stop_lat,
    s1.stop_lon
FROM stops AS s1
INNER JOIN stops AS s2
    ON s1.stop_lat = s2.stop_lat
   AND s1.stop_lon = s2.stop_lon
   AND s1.stop_id < s2.stop_id
WHERE s1.location_type = 1
  AND s2.location_type = 1;

---Compare Stations Within a Latitude Range
SELECT
    s1.stop_name AS station_1,
    s2.stop_name AS station_2,
    s1.stop_lat AS latitude_1,
    s2.stop_lat AS latitude_2
FROM stops AS s1
INNER JOIN stops AS s2
    ON ABS(s1.stop_lat - s2.stop_lat) < 0.01
   AND s1.stop_id < s2.stop_id
WHERE s1.location_type = 1
  AND s2.location_type = 1;

---Compare Stations Within a Longitude Range
SELECT
    s1.stop_name AS station_1,
    s2.stop_name AS station_2,
    s1.stop_lon AS longitude_1,
    s2.stop_lon AS longitude_2
FROM stops AS s1
INNER JOIN stops AS s2
    ON ABS(s1.stop_lon - s2.stop_lon) < 0.01
   AND s1.stop_id < s2.stop_id
WHERE s1.location_type = 1
  AND s2.location_type = 1;

---Find Stations With Different Fare Zones
SELECT
    s1.stop_name AS station_1,
    s1.zone_id AS zone_1,
    s2.stop_name AS station_2,
    s2.zone_id AS zone_2
FROM stops AS s1
INNER JOIN stops AS s2
    ON s1.zone_id <> s2.zone_id
   AND s1.stop_id < s2.stop_id
WHERE s1.location_type = 1
  AND s2.location_type = 1
  AND s1.zone_id IS NOT NULL
  AND s2.zone_id IS NOT NULL;

---Find Station Pairs With Different Names in the Same Zone
SELECT
    s1.stop_name AS station_1,
    s2.stop_name AS station_2,
    s1.zone_id
FROM stops AS s1
INNER JOIN stops AS s2
    ON s1.zone_id = s2.zone_id
   AND s1.stop_name <> s2.stop_name
   AND s1.stop_id < s2.stop_id
WHERE s1.location_type = 1
  AND s2.location_type = 1
  AND s1.zone_id IS NOT NULL;

---