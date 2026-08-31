--- QUERIES WITH CALCULATING ROUTE PERFORMANCE

---Which routes have the most scheduled trips?
SELECT
    r.route_id,
    r.route_short_name,
    r.route_long_name,
    COUNT(t.trip_id) AS scheduled_trips
FROM routes r
JOIN trips t
    ON r.route_id = t.route_id
GROUP BY
    r.route_id,
    r.route_short_name,
    r.route_long_name
ORDER BY scheduled_trips DESC;

---Which routes serve the greatest number of stops?
SELECT
    r.route_id,
    r.route_short_name,
    COUNT(DISTINCT st.stop_id) AS stop_count
FROM routes r
JOIN trips t
    ON r.route_id = t.route_id
JOIN stop_times st
    ON t.trip_id = st.trip_id
GROUP BY
    r.route_id,
    r.route_short_name
ORDER BY stop_count DESC;

---What is the average number of stops per route?
WITH route_stops AS (
    SELECT
        r.route_id,
        COUNT(DISTINCT st.stop_id) AS stop_count
    FROM routes r
    JOIN trips t
        ON r.route_id = t.route_id
    JOIN stop_times st
        ON t.trip_id = st.trip_id
    GROUP BY r.route_id
)
SELECT
    ROUND(AVG(stop_count), 2) AS avg_stops_per_route
FROM route_stops;

---Which routes have the most trips per service?
SELECT
    r.route_id,
    r.route_short_name,
    COUNT(t.trip_id) AS total_trips,
    COUNT(DISTINCT t.service_id) AS service_count,
    ROUND(
        COUNT(t.trip_id) / NULLIF(COUNT(DISTINCT t.service_id), 0),
        2
    ) AS trips_per_service
FROM routes r
JOIN trips t
    ON r.route_id = t.route_id
GROUP BY
    r.route_id,
    r.route_short_name
ORDER BY trips_per_service DESC;

---What is the average number of stops per trip for each route?
WITH trip_stop_counts AS (
    SELECT
        t.trip_id,
        t.route_id,
        COUNT(st.stop_id) AS stop_count
    FROM trips t
    JOIN stop_times st
        ON t.trip_id = st.trip_id
    GROUP BY
        t.trip_id,
        t.route_id
)
SELECT
    r.route_id,
    r.route_short_name,
    ROUND(AVG(tsc.stop_count), 2) AS avg_stops_per_trip
FROM trip_stop_counts tsc
JOIN routes r
    ON tsc.route_id = r.route_id
GROUP BY
    r.route_id,
    r.route_short_name
ORDER BY avg_stops_per_trip DESC;

---Rank routes by scheduled trip volume
WITH route_trip_counts AS (
    SELECT
        r.route_id,
        r.route_short_name,
        COUNT(t.trip_id) AS trip_count
    FROM routes r
    JOIN trips t
        ON r.route_id = t.route_id
    GROUP BY
        r.route_id,
        r.route_short_name
)
SELECT
    route_id,
    route_short_name,
    trip_count,
    RANK() OVER (
        ORDER BY trip_count DESC
    ) AS route_rank
FROM route_trip_counts;
