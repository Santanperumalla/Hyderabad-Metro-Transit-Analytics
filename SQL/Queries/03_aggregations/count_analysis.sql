--- USING THE REQUIRED DATABASE
USE hyderabadmetrotransitanalytics;


--- QUERIES WITH AGGREGATION FOR COUNT ANALYSIS

---Total number of metro routes
SELECT COUNT(*) AS total_routes
FROM routes;

---Total number of stations
SELECT COUNT(*) AS total_stations
FROM stops
WHERE location_type = 1;

---Total number of scheduled trips
SELECT COUNT(*) AS total_trips
FROM trips;

--- Total scheduled stop-time records
SELECT COUNT(*) AS total_stop_times
FROM stop_times;

---Total number of fare definitions
SELECT COUNT(*) AS total_fares
FROM fare_attributes;

---Count routes by route type
SELECT
    route_type,
    COUNT(*) AS total_routes
FROM routes
GROUP BY route_type
ORDER BY total_routes DESC;

---Count scheduled trips by service ID
SELECT
    service_id,
    COUNT(*) AS total_trips
FROM trips
GROUP BY service_id
ORDER BY total_trips DESC;

---Count station records by parent_station
SELECT
    parent_station,
    COUNT(*) AS station_count
FROM stops
WHERE location_type = 1
GROUP BY parent_station
ORDER BY station_count DESC;

---Count records by location type
SELECT
    location_type,
    COUNT(*) AS total_records
FROM stops
GROUP BY location_type
ORDER BY location_type;

---Count unique shapes used by scheduled trips
SELECT
    COUNT(DISTINCT shape_id) AS total_unique_shapes
FROM trips
WHERE shape_id IS NOT NULL;