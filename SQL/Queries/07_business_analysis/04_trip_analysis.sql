--- QUERIES FOR MAKING TRIP ANALYSIS

---How many stops does each trip serve?
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
ORDER BY stop_count DESC;

---Which trips have the greatest number of stops?
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
ORDER BY stop_count DESC
LIMIT 10;

---What is the average number of stops per trip?
WITH trip_stops AS (
    SELECT
        trip_id,
        COUNT(stop_id) AS stop_count
    FROM stop_times
    GROUP BY trip_id
)
SELECT
    ROUND(AVG(stop_count), 2) AS average_stops_per_trip
FROM trip_stops;

---What are the first and last stops of each trip?
WITH ranked_stops AS (
    SELECT
        trip_id,
        stop_id,
        stop_sequence,
        ROW_NUMBER() OVER (
            PARTITION BY trip_id
            ORDER BY stop_sequence
        ) AS first_stop,
        ROW_NUMBER() OVER (
            PARTITION BY trip_id
            ORDER BY stop_sequence DESC
        ) AS last_stop
    FROM stop_times
)
SELECT
    trip_id,
    MAX(CASE WHEN first_stop = 1 THEN stop_id END) AS first_stop_id,
    MAX(CASE WHEN last_stop = 1 THEN stop_id END) AS last_stop_id
FROM ranked_stops
GROUP BY trip_id;

---What is the scheduled journey duration of each trip?
WITH trip_times AS (
    SELECT
        trip_id,
        MIN(arrival_time) AS first_arrival,
        MAX(arrival_time) AS last_arrival
    FROM stop_times
    GROUP BY trip_id
)
SELECT
    trip_id,
    TIMEDIFF(
        last_arrival,
        first_arrival
    ) AS scheduled_duration
FROM trip_times
ORDER BY scheduled_duration DESC;