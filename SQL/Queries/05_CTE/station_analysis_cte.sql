--- USING THE REQUIRED DATABASE
USE hyderabadmetrotransitanalytics;


---QUERIES WITH CTE FOR STATION ANALYSIS

---Number of trips serving each station
---Q. Which stations are served by the greatest number of scheduled trips?
WITH station_trips AS (
    SELECT
        s.stop_id AS station_id,
        s.stop_name,
        COUNT(DISTINCT st.trip_id) AS total_trips
    FROM stops s
    JOIN stops p
        ON p.parent_station = s.stop_id
    JOIN stop_times st
        ON st.stop_id = p.stop_id
    WHERE s.location_type = 1
    GROUP BY
        s.stop_id,
        s.stop_name
)
SELECT
    station_id,
    stop_name,
    total_trips
FROM station_trips
ORDER BY total_trips DESC;

---Station service coverage by route
---Q. How many different routes serve each station?
WITH station_routes AS (
    SELECT
        s.stop_id AS station_id,
        s.stop_name,
        COUNT(DISTINCT t.route_id) AS route_count
    FROM stops s
    JOIN stops p
        ON p.parent_station = s.stop_id
    JOIN stop_times st
        ON st.stop_id = p.stop_id
    JOIN trips t
        ON t.trip_id = st.trip_id
    WHERE s.location_type = 1
    GROUP BY
        s.stop_id,
        s.stop_name
)
SELECT
    station_id,
    stop_name,
    route_count
FROM station_routes
ORDER BY route_count DESC;

---First and last scheduled service
---Q. What are the earliest and latest scheduled services at each station?
WITH station_service_times AS (
    SELECT
        s.stop_id AS station_id,
        s.stop_name,
        MIN(st.arrival_time) AS first_service,
        MAX(st.arrival_time) AS last_service
    FROM stops s
    JOIN stops p
        ON p.parent_station = s.stop_id
    JOIN stop_times st
        ON st.stop_id = p.stop_id
    WHERE s.location_type = 1
    GROUP BY
        s.stop_id,
        s.stop_name
)
SELECT
    station_id,
    stop_name,
    first_service,
    last_service
FROM station_service_times
ORDER BY first_service;

---Station-wise route and trip intensity
---Q. Which stations have both broad route coverage and high scheduled service?
WITH station_metrics AS (
    SELECT
        s.stop_id AS station_id,
        s.stop_name,
        COUNT(DISTINCT t.route_id) AS route_count,
        COUNT(DISTINCT st.trip_id) AS trip_count
    FROM stops s
    JOIN stops p
        ON p.parent_station = s.stop_id
    JOIN stop_times st
        ON st.stop_id = p.stop_id
    JOIN trips t
        ON t.trip_id = st.trip_id
    WHERE s.location_type = 1
    GROUP BY
        s.stop_id,
        s.stop_name
)
SELECT
    station_id,
    stop_name,
    route_count,
    trip_count,
    CASE
        WHEN route_count >= 2 AND trip_count >= 1000
            THEN 'High Service Hub'
        WHEN route_count >= 2
            THEN 'Multi-Route Station'
        ELSE 'Single-Route Station'
    END AS station_category
FROM station_metrics
ORDER BY trip_count DESC;

---Rank stations by scheduled service
---Q. Which stations rank highest based on scheduled trip coverage?
WITH station_trip_counts AS (
    SELECT
        s.stop_id AS station_id,
        s.stop_name,
        COUNT(DISTINCT st.trip_id) AS total_trips
    FROM stops s
    JOIN stops p
        ON p.parent_station = s.stop_id
    JOIN stop_times st
        ON st.stop_id = p.stop_id
    WHERE s.location_type = 1
    GROUP BY
        s.stop_id,
        s.stop_name
),
ranked_stations AS (
    SELECT
        station_id,
        stop_name,
        total_trips,
        DENSE_RANK() OVER (
            ORDER BY total_trips DESC
        ) AS station_rank
    FROM station_trip_counts
)
SELECT
    station_id,
    stop_name,
    total_trips,
    station_rank
FROM ranked_stations
ORDER BY station_rank;