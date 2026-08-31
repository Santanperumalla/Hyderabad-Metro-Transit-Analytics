--- USING THE REQUIRED DATABASE
USE hyderabadmetrotransitanalytics;


--- QUERIES WITH CTE FOR ROUTE ANALYSIS

---Number of trips per route
---Q. How many scheduled trips operate on each metro route?
WITH route_trips AS (
    SELECT
        route_id,
        COUNT(*) AS total_trips
    FROM trips
    GROUP BY route_id
)
SELECT
    r.route_id,
    r.route_short_name,
    r.route_long_name,
    rt.total_trips
FROM routes r
JOIN route_trips rt
    ON r.route_id = rt.route_id
ORDER BY rt.total_trips DESC;

---Route-wise station coverage
---Q. How many stations are served by each route?
WITH route_stations AS (
    SELECT
        t.route_id,
        COUNT(DISTINCT s.parent_station) AS station_count
    FROM trips t
    JOIN stop_times st
        ON t.trip_id = st.trip_id
    JOIN stops s
        ON st.stop_id = s.stop_id
    WHERE s.location_type = 0
      AND s.parent_station IS NOT NULL
    GROUP BY t.route_id
)
SELECT
    r.route_id,
    r.route_short_name,
    r.route_long_name,
    rs.station_count
FROM routes r
JOIN route_stations rs
    ON r.route_id = rs.route_id
ORDER BY rs.station_count DESC;

---Route-wise scheduled distance
---Q. What is the approximate scheduled route distance?
WITH route_distance AS (
    SELECT
        t.route_id,
        MAX(st.shape_dist_traveled) AS route_distance
    FROM trips t
    JOIN stop_times st
        ON t.trip_id = st.trip_id
    WHERE st.shape_dist_traveled IS NOT NULL
    GROUP BY t.route_id, t.trip_id
),
route_summary AS (
    SELECT
        route_id,
        MAX(route_distance) AS max_route_distance
    FROM route_distance
    GROUP BY route_id
)
SELECT
    r.route_id,
    r.route_short_name,
    rs.max_route_distance
FROM routes r
JOIN route_summary rs
    ON r.route_id = rs.route_id
ORDER BY rs.max_route_distance DESC;

---Route-wise directional trip analysis
---Q. How are trips distributed between the two directions of each route?
WITH direction_summary AS (
    SELECT
        route_id,
        direction_id,
        COUNT(*) AS trip_count
    FROM trips
    GROUP BY route_id, direction_id
)
SELECT
    r.route_id,
    r.route_short_name,
    ds.direction_id,
    ds.trip_count
FROM routes r
JOIN direction_summary ds
    ON r.route_id = ds.route_id
ORDER BY
    r.route_id,
    ds.direction_id;

---Rank routes by scheduled service
---Q. Which routes have the highest scheduled service?
WITH route_trip_counts AS (
    SELECT
        route_id,
        COUNT(*) AS total_trips
    FROM trips
    GROUP BY route_id
),
ranked_routes AS (
    SELECT
        route_id,
        total_trips,
        DENSE_RANK() OVER (
            ORDER BY total_trips DESC
        ) AS route_rank
    FROM route_trip_counts
)
SELECT
    r.route_id,
    r.route_short_name,
    rr.total_trips,
    rr.route_rank
FROM ranked_routes rr
JOIN routes r
    ON rr.route_id = r.route_id
ORDER BY rr.route_rank;

