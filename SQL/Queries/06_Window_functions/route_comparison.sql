--- USING THE REQUIRED DATABASE
USE hyderabadmetrotransitanalytics;


---QUERIES WITH WINDOW FUNCTIONS FOR ROUTE COMPARISON
---Route Trips vs Average Route Trips
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

    ROUND(
        AVG(scheduled_trips) OVER (),
        2
    ) AS network_avg_trips,

    scheduled_trips
        - AVG(scheduled_trips) OVER () AS difference_from_average

FROM route_trips

ORDER BY scheduled_trips DESC;

---Route Station Coverage vs Network Average
WITH route_stations AS (
    SELECT
        r.route_id,
        r.route_short_name,
        COUNT(DISTINCT s.stop_id) AS station_count

    FROM routes r
    JOIN trips t
        ON r.route_id = t.route_id
    JOIN stop_times st
        ON t.trip_id = st.trip_id
    JOIN stops s
        ON st.stop_id = s.stop_id

    WHERE s.location_type = 1

    GROUP BY
        r.route_id,
        r.route_short_name
)

SELECT
    route_id,
    route_short_name,
    station_count,

    ROUND(
        AVG(station_count) OVER (),
        2
    ) AS average_station_count,

    station_count
        - AVG(station_count) OVER () AS difference_from_average

FROM route_stations
ORDER BY station_count DESC;

---Route Trip Count Within Its Service Type
WITH route_service AS (
    SELECT
        r.route_id,
        r.route_short_name,
        c.service_id,
        COUNT(t.trip_id) AS trip_count

    FROM routes r
    JOIN trips t
        ON r.route_id = t.route_id
    JOIN calendar c
        ON t.service_id = c.service_id

    GROUP BY
        r.route_id,
        r.route_short_name,
        c.service_id
)

SELECT
    route_id,
    route_short_name,
    service_id,
    trip_count,

    ROUND(
        AVG(trip_count) OVER (
            PARTITION BY service_id
        ),
        2
    ) AS service_average,

    trip_count
        - AVG(trip_count) OVER (
            PARTITION BY service_id
        ) AS difference_from_service_average

FROM route_service

ORDER BY
    service_id,
    trip_count DESC;

---Route Distance vs Average Distance
WITH route_distance AS (
    SELECT
        r.route_id,
        r.route_short_name,
        MAX(sh.shape_dist_traveled) AS route_distance

    FROM routes r
    JOIN trips t
        ON r.route_id = t.route_id
    JOIN shapes sh
        ON t.shape_id = sh.shape_id

    GROUP BY
        r.route_id,
        r.route_short_name
)

SELECT
    route_id,
    route_short_name,
    route_distance,

    ROUND(
        AVG(route_distance) OVER (),
        2
    ) AS average_route_distance,

    ROUND(
        route_distance
        - AVG(route_distance) OVER (),
        2
    ) AS distance_difference

FROM route_distance

ORDER BY route_distance DESC;

---Route Trip Share of Total Network
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

    SUM(scheduled_trips) OVER () AS total_network_trips,

    ROUND(
        scheduled_trips * 100.0
        / SUM(scheduled_trips) OVER (),
        2
    ) AS network_trip_percentage

FROM route_trips

ORDER BY network_trip_percentage DESC;