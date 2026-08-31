--- USING THE REQUIRED DATABASE
USE hyderabadmetrotransitanalytics;


--- QUERIES WITH WINDOW FUNCTIONS FOR RUNNING TOTALS
--- Cumulative Stops Along a Trip
SELECT
    st.trip_id,
    st.stop_sequence,
    st.stop_id,

    COUNT(*) OVER (
        PARTITION BY st.trip_id
        ORDER BY st.stop_sequence
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS cumulative_stops

FROM stop_times st
JOIN stops s
    ON st.stop_id = s.stop_id

WHERE s.location_type = 1

ORDER BY
    st.trip_id,
    st.stop_sequence;

---Cumulative Distance Along Shape
SELECT
    shape_id,
    shape_pt_sequence,
    shape_dist_traveled,

    MAX(shape_dist_traveled) OVER (
        PARTITION BY shape_id
        ORDER BY shape_pt_sequence
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS cumulative_distance

FROM shapes

ORDER BY
    shape_id,
    shape_pt_sequence;

---Cumulative Scheduled Trips by Route
WITH route_trips AS (
    SELECT
        r.route_id,
        r.route_short_name,
        COUNT(t.trip_id) AS scheduled_trips

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
    scheduled_trips,

    SUM(scheduled_trips) OVER (
        ORDER BY scheduled_trips DESC
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS cumulative_network_trips

FROM route_trips

ORDER BY scheduled_trips DESC;

---Cumulative Station Stops Along Each Trip
SELECT
    st.trip_id,
    st.stop_sequence,
    s.stop_name,

    SUM(1) OVER (
        PARTITION BY st.trip_id
        ORDER BY st.stop_sequence
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS cumulative_station_visits

FROM stop_times st
JOIN stops s
    ON st.stop_id = s.stop_id

WHERE s.location_type = 1

ORDER BY
    st.trip_id,
    st.stop_sequence;

---Cumulative Routes by Trip Volume
WITH route_summary AS (
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

    SUM(trip_count) OVER (
        ORDER BY trip_count DESC
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS cumulative_trip_count,

    ROUND(
        SUM(trip_count) OVER (
            ORDER BY trip_count DESC
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ) * 100.0
        / SUM(trip_count) OVER (),
        2
    ) AS cumulative_percentage

FROM route_summary

ORDER BY trip_count DESC;

