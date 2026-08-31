--- USING THE REQUIRED DATABASE
USE hyderabadmetrotransitanalytics;


--- QUERIES WITH AGGREGATIONS FOR STATION ANALYSIS

---List all stations
SELECT
    stop_id,
    stop_name,
    stop_lat,
    stop_lon,
    zone_id
FROM stops
WHERE location_type = 1
ORDER BY stop_name;

---Stations by fare zone
SELECT
    zone_id,
    COUNT(*) AS station_count
FROM stops
WHERE location_type = 1
GROUP BY zone_id
ORDER BY station_count DESC;

---Number of scheduled trips serving each station
SELECT
    s.stop_id,
    s.stop_name,
    COUNT(DISTINCT st.trip_id) AS scheduled_trips
FROM stops s
JOIN stop_times st
    ON s.stop_id = st.stop_id
WHERE s.location_type = 1
GROUP BY
    s.stop_id,
    s.stop_name
ORDER BY scheduled_trips DESC;

---Number of routes serving each station
SELECT
    s.stop_id,
    s.stop_name,
    COUNT(DISTINCT t.route_id) AS route_count
FROM stops s
JOIN stop_times st
    ON s.stop_id = st.stop_id
JOIN trips t
    ON st.trip_id = t.trip_id
WHERE s.location_type = 1
GROUP BY
    s.stop_id,
    s.stop_name
ORDER BY route_count DESC;

---Station-wise first and last scheduled service
SELECT
    s.stop_id,
    s.stop_name,
    MIN(st.arrival_time) AS first_arrival,
    MAX(st.arrival_time) AS last_arrival
FROM stops s
JOIN stop_times st
    ON s.stop_id = st.stop_id
WHERE s.location_type = 1
GROUP BY
    s.stop_id,
    s.stop_name
ORDER BY first_arrival;

