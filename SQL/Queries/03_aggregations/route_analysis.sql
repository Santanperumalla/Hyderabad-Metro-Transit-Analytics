--- USING THE REQUIRED DATABASE
USE hyderabadmetrotransitanalytics;

--- QUERIES WITH AGGREGATIONS FOR ROUTE ANALYSIS

---Number of trips by route
SELECT
    r.route_id,
    r.route_short_name,
    r.route_long_name,
    COUNT(t.trip_id) AS total_trips
FROM routes r
LEFT JOIN trips t
    ON r.route_id = t.route_id
GROUP BY
    r.route_id,
    r.route_short_name,
    r.route_long_name
ORDER BY total_trips DESC;

---Number of trips by route and service type
SELECT
    r.route_id,
    r.route_short_name,
    t.service_id,
    COUNT(t.trip_id) AS total_trips
FROM routes r
JOIN trips t
    ON r.route_id = t.route_id
GROUP BY
    r.route_id,
    r.route_short_name,
    t.service_id
ORDER BY
    r.route_id,
    total_trips DESC;

---Number of stops served by each route
SELECT
    r.route_id,
    r.route_short_name,
    COUNT(DISTINCT s.stop_id) AS stations_served
FROM routes AS r
INNER JOIN trips AS t
    ON t.route_id = r.route_id
INNER JOIN stop_times AS st
    ON st.trip_id = t.trip_id
INNER JOIN stops AS s
    ON s.stop_id = st.stop_id
WHERE s.location_type = 1
GROUP BY
    r.route_id,
    r.route_short_name
ORDER BY
    stations_served DESC;

---Route-wise average number of stops per trip
SELECT
    r.route_id,
    r.route_short_name,
    ROUND(AVG(trip_station_count), 2) AS avg_stations_per_trip
FROM routes r
JOIN trips t
    ON r.route_id = t.route_id
JOIN (
    SELECT
        st.trip_id,
        COUNT(DISTINCT st.stop_id) AS trip_station_count
    FROM stop_times st
    JOIN stops s
        ON st.stop_id = s.stop_id
    WHERE s.location_type = 1
    GROUP BY st.trip_id
) x
    ON t.trip_id = x.trip_id
GROUP BY
    r.route_id,
    r.route_short_name
ORDER BY avg_stations_per_trip DESC;

---Route-wise scheduled service distance
SELECT
    r.route_id,
    r.route_short_name,
    ROUND(AVG(x.max_distance), 2) AS avg_trip_distance
FROM routes r
JOIN trips t
    ON r.route_id = t.route_id
JOIN (
    SELECT
        trip_id,
        MAX(shape_dist_traveled) AS max_distance
    FROM stop_times
    WHERE shape_dist_traveled IS NOT NULL
    GROUP BY trip_id
) x
    ON t.trip_id = x.trip_id
GROUP BY
    r.route_id,
    r.route_short_name
ORDER BY avg_trip_distance DESC;