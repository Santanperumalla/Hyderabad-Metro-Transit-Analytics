--- QUERIES FOR MAKING STATION ANALYSIS

---Which stops are served by the most trips?
SELECT
    s.stop_id,
    s.stop_name,
    COUNT(DISTINCT st.trip_id) AS trip_count
FROM stops s
JOIN stop_times st
    ON s.stop_id = st.stop_id
GROUP BY
    s.stop_id,
    s.stop_name
ORDER BY trip_count DESC;

--- Which stops are served by the most routes?
SELECT
    s.stop_id,
    s.stop_name,
    COUNT(DISTINCT t.route_id) AS route_count
FROM stops s
JOIN stop_times st
    ON s.stop_id = st.stop_id
JOIN trips t
    ON st.trip_id = t.trip_id
GROUP BY
    s.stop_id,
    s.stop_name
ORDER BY route_count DESC;

---Which stations have the broadest scheduled service coverage?
SELECT
    s.stop_id,
    s.stop_name,
    COUNT(DISTINCT t.route_id) AS routes_serving_station,
    COUNT(DISTINCT t.trip_id) AS trips_serving_station
FROM stops s
JOIN stop_times st
    ON s.stop_id = st.stop_id
JOIN trips t
    ON st.trip_id = t.trip_id
GROUP BY
    s.stop_id,
    s.stop_name
ORDER BY
    routes_serving_station DESC,
    trips_serving_station DESC;

---What is the average number of routes serving a stop?
WITH stop_routes AS (
    SELECT
        s.stop_id,
        COUNT(DISTINCT t.route_id) AS route_count
    FROM stops s
    LEFT JOIN stop_times st
        ON s.stop_id = st.stop_id
    LEFT JOIN trips t
        ON st.trip_id = t.trip_id
    GROUP BY s.stop_id
)
SELECT
    ROUND(AVG(route_count), 2) AS avg_routes_per_stop
FROM stop_routes;

---Which stops occur most frequently in scheduled trips?
SELECT
    s.stop_id,
    s.stop_name,
    COUNT(*) AS stop_time_records
FROM stops s
JOIN stop_times st
    ON s.stop_id = st.stop_id
GROUP BY
    s.stop_id,
    s.stop_name
ORDER BY stop_time_records DESC;

