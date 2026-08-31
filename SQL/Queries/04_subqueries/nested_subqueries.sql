--- USING THE REQUIRED DATABASE
USE hyderabadmetrotransitanalytics;


--- NESTED SUBQUERIES

---Routes having more trips than the average route
---Q. Which routes have a number of trips greater than the average number of trips per route?
SELECT
    r.route_id,
    r.route_short_name,
    r.route_long_name,
    COUNT(t.trip_id) AS trip_count
FROM routes r
JOIN trips t
    ON r.route_id = t.route_id
GROUP BY
    r.route_id,
    r.route_short_name,
    r.route_long_name
HAVING COUNT(t.trip_id) >
(
    SELECT AVG(route_trip_count)
    FROM
    (
        SELECT
            route_id,
            COUNT(trip_id) AS route_trip_count
        FROM trips
        GROUP BY route_id
    ) AS route_counts
)
ORDER BY trip_count DESC;

---Find the route with the maximum number of trips
---Which route operates the highest number of scheduled trips?
SELECT
    r.route_id,
    r.route_short_name,
    r.route_long_name,
    COUNT(t.trip_id) AS total_trips
FROM routes r
JOIN trips t
    ON r.route_id = t.route_id
GROUP BY
    r.route_id,
    r.route_short_name,
    r.route_long_name
HAVING COUNT(t.trip_id) =
(
    SELECT MAX(total_trips)
    FROM
    (
        SELECT
            route_id,
            COUNT(trip_id) AS total_trips
        FROM trips
        GROUP BY route_id
    ) AS route_trip_summary
);

---Finding stops belonging to routes with above-average trip activity
---Q. Which stops are served by routes whose scheduled trip count is above the average route trip count?
SELECT DISTINCT
    s.stop_id,
    s.stop_name
FROM stops s
JOIN stop_times st
    ON s.stop_id = st.stop_id
JOIN trips t
    ON st.trip_id = t.trip_id
WHERE t.route_id IN
(
    SELECT route_id
    FROM trips
    GROUP BY route_id
    HAVING COUNT(trip_id) >
    (
        SELECT AVG(route_trip_count)
        FROM
        (
            SELECT
                route_id,
                COUNT(trip_id) AS route_trip_count
            FROM trips
            GROUP BY route_id
        ) AS route_summary
    )
)
ORDER BY s.stop_name;

---Find trips whose number of stops is greater than the average trip
---Q. Which trips make more stops than the average trip?
SELECT
    t.trip_id,
    t.route_id,
    t.service_id,
    COUNT(st.stop_id) AS stop_count
FROM trips t
JOIN stop_times st
    ON t.trip_id = st.trip_id
GROUP BY
    t.trip_id,
    t.route_id,
    t.service_id
HAVING COUNT(st.stop_id) >
(
    SELECT AVG(trip_stop_count)
    FROM
    (
        SELECT
            trip_id,
            COUNT(stop_id) AS trip_stop_count
        FROM stop_times
        GROUP BY trip_id
    ) AS trip_summary
)
ORDER BY stop_count DESC;

---Find the stop with the highest number of scheduled stop-time records
---Q. Which station/stop appears in the greatest number of scheduled stop-time records?
SELECT
    s.stop_id,
    s.stop_name,
    COUNT(st.trip_id) AS scheduled_trip_records
FROM stops s
JOIN stop_times st
    ON s.stop_id = st.stop_id
GROUP BY
    s.stop_id,
    s.stop_name
HAVING COUNT(st.trip_id) =
(
    SELECT MAX(stop_trip_count)
    FROM
    (
        SELECT
            stop_id,
            COUNT(trip_id) AS stop_trip_count
        FROM stop_times
        GROUP BY stop_id
    ) AS stop_summary
)
ORDER BY s.stop_name;
