--- USING THE REQUIRED DATABASE
USE hyderabadmetrotransitanalytics;


---QUERIES WITH WINDOW FUNCTIONS FOR PARTITION ANALYSIS
---Trips Within Each Route
SELECT
    t.route_id,
    t.trip_id,
    t.trip_headsign,

    COUNT(*) OVER (
        PARTITION BY t.route_id
    ) AS total_trips_on_route

FROM trips t

ORDER BY
    t.route_id,
    t.trip_id;

---Trip Rank Within Each Route
WITH trip_stop_counts AS (
    SELECT
        t.route_id,
        t.trip_id,
        t.trip_headsign,
        COUNT(st.stop_id) AS station_count

    FROM trips t
    JOIN stop_times st
        ON t.trip_id = st.trip_id
    JOIN stops s
        ON st.stop_id = s.stop_id

    WHERE s.location_type = 1

    GROUP BY
        t.route_id,
        t.trip_id,
        t.trip_headsign
)

SELECT
    route_id,
    trip_id,
    trip_headsign,
    station_count,

    RANK() OVER (
        PARTITION BY route_id
        ORDER BY station_count DESC
    ) AS trip_rank_within_route

FROM trip_stop_counts

ORDER BY
    route_id,
    trip_rank_within_route;

---Service-Day Trip Analysis
SELECT
    c.service_id,
    t.route_id,
    COUNT(t.trip_id) AS route_service_trips,

    SUM(COUNT(t.trip_id)) OVER (
        PARTITION BY c.service_id
    ) AS total_service_trips

FROM calendar c
JOIN trips t
    ON c.service_id = t.service_id

GROUP BY
    c.service_id,
    t.route_id

ORDER BY
    c.service_id,
    route_service_trips DESC;

---Direction Analysis Within Each Route
SELECT
    route_id,
    direction_id,
    COUNT(*) AS trip_count,

    SUM(COUNT(*)) OVER (
        PARTITION BY route_id
    ) AS total_route_trips,

    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (
            PARTITION BY route_id
        ),
        2
    ) AS direction_percentage

FROM trips

GROUP BY
    route_id,
    direction_id

ORDER BY
    route_id,
    direction_id;

---Station Stop Sequence Analysis
SELECT
    st.trip_id,
    s.stop_id,
    s.stop_name,
    st.stop_sequence,

    MIN(st.stop_sequence) OVER (
        PARTITION BY st.trip_id
    ) AS first_stop_sequence,

    MAX(st.stop_sequence) OVER (
        PARTITION BY st.trip_id
    ) AS last_stop_sequence,

    MAX(st.stop_sequence) OVER (
        PARTITION BY st.trip_id
    )
    - MIN(st.stop_sequence) OVER (
        PARTITION BY st.trip_id
    ) + 1 AS total_stop_positions

FROM stop_times st
JOIN stops s
    ON st.stop_id = s.stop_id

WHERE s.location_type = 1

ORDER BY
    st.trip_id,
    st.stop_sequence;