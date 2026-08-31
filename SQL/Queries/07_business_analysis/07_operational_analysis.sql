--- QUERIES FOR MAKING OPERATIONAL ANALYSIS

---What is the scheduled service volume by route?
SELECT
    r.route_id,
    r.route_short_name,
    r.route_long_name,
    COUNT(DISTINCT t.trip_id) AS scheduled_trips,
    COUNT(DISTINCT st.stop_id) AS stops_served
FROM routes r
LEFT JOIN trips t
    ON r.route_id = t.route_id
LEFT JOIN stop_times st
    ON t.trip_id = st.trip_id
GROUP BY
    r.route_id,
    r.route_short_name,
    r.route_long_name
ORDER BY scheduled_trips DESC;

---Which routes have the highest service-to-stop ratio?
WITH route_metrics AS (
    SELECT
        r.route_id,
        r.route_short_name,
        COUNT(DISTINCT t.trip_id) AS trip_count,
        COUNT(DISTINCT st.stop_id) AS stop_count
    FROM routes r
    LEFT JOIN trips t
        ON r.route_id = t.route_id
    LEFT JOIN stop_times st
        ON t.trip_id = st.trip_id
    GROUP BY
        r.route_id,
        r.route_short_name
)
SELECT
    route_id,
    route_short_name,
    trip_count,
    stop_count,
    ROUND(
        trip_count / NULLIF(stop_count, 0),
        2
    ) AS trips_per_stop
FROM route_metrics
ORDER BY trips_per_stop DESC;

---Which routes have the longest scheduled trips?
WITH trip_duration AS (
    SELECT
        t.trip_id,
        t.route_id,
        TIMEDIFF(
            MAX(st.arrival_time),
            MIN(st.arrival_time)
        ) AS duration
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
    ROUND(
        AVG(TIME_TO_SEC(td.duration)) / 60,
        2
    ) AS avg_duration_minutes
FROM trip_duration td
JOIN routes r
    ON td.route_id = r.route_id
GROUP BY
    r.route_id,
    r.route_short_name
ORDER BY avg_duration_minutes DESC;

---Rank routes by scheduled service volume
WITH route_service AS (
    SELECT
        r.route_id,
        r.route_short_name,
        COUNT(t.trip_id) AS trip_count
    FROM routes r
    LEFT JOIN trips t
        ON r.route_id = t.route_id
    GROUP BY
        r.route_id,
        r.route_short_name
)
SELECT
    route_id,
    route_short_name,
    trip_count,
    DENSE_RANK() OVER (
        ORDER BY trip_count DESC
    ) AS service_rank
FROM route_service
ORDER BY service_rank;

---What percentage of all scheduled trips belongs to each route?
WITH route_trips AS (
    SELECT
        r.route_id,
        r.route_short_name,
        COUNT(t.trip_id) AS trip_count
    FROM routes r
    LEFT JOIN trips t
        ON r.route_id = t.route_id
    GROUP BY
        r.route_id,
        r.route_short_name
)
SELECT
    route_id,
    route_short_name,
    trip_count,
    ROUND(
        100.0 * trip_count /
        SUM(trip_count) OVER (),
        2
    ) AS percentage_of_total_trips
FROM route_trips
ORDER BY percentage_of_total_trips DESC; 

