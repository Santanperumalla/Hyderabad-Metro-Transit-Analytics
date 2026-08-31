--- USING THE REQUIRED DATABASE
USE hyderabadmetrotransitanalytics;


--- QUERIES WITH WINDOW FUNCTIONS FOR RANKINGS

---Routes by Scheduled Trip Count
---Q. Which metro routes have the most scheduled trips?
SELECT
    r.route_id,
    r.route_short_name,
    COUNT(t.trip_id) AS scheduled_trips,

    RANK() OVER (
        ORDER BY COUNT(t.trip_id) DESC
    ) AS trip_rank

FROM routes r
JOIN trips t
    ON r.route_id = t.route_id

GROUP BY
    r.route_id,
    r.route_short_name

ORDER BY trip_rank;

---Routes by Number of Stations Served
---Q. Which routes serve the largest number of stations?
SELECT
    route_id,
    route_short_name,
    station_count,

    DENSE_RANK() OVER (
        ORDER BY station_count DESC
    ) AS station_coverage_rank

FROM (
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
) AS route_station_summary

ORDER BY station_coverage_rank;

---Trips by Number of Stops
---Q. Which scheduled trips contain the highest number of station stops?
SELECT
    t.trip_id,
    t.route_id,
    t.trip_headsign,
    COUNT(st.stop_id) AS station_stops,

    ROW_NUMBER() OVER (
        ORDER BY COUNT(st.stop_id) DESC
    ) AS trip_rank

FROM trips t
JOIN stop_times st
    ON t.trip_id = st.trip_id
JOIN stops s
    ON st.stop_id = s.stop_id

WHERE s.location_type = 1

GROUP BY
    t.trip_id,
    t.route_id,
    t.trip_headsign

ORDER BY trip_rank;

---Routes by Geographic Distance
---Using the maximum shape_dist_traveled for each shape.
SELECT
    r.route_id,
    r.route_short_name,
    MAX(sh.shape_dist_traveled) AS route_distance,

    RANK() OVER (
        ORDER BY MAX(sh.shape_dist_traveled) DESC
    ) AS distance_rank

FROM routes r
JOIN trips t
    ON r.route_id = t.route_id
JOIN shapes sh
    ON t.shape_id = sh.shape_id

GROUP BY
    r.route_id,
    r.route_short_name

ORDER BY distance_rank;

---Service Types by Number of Trips
SELECT
    c.service_id,

    CASE
        WHEN c.monday = 1
         AND c.tuesday = 1
         AND c.wednesday = 1
         AND c.thursday = 1
         AND c.friday = 1
        THEN 'Weekday'

        WHEN c.saturday = 1
        THEN 'Saturday'

        WHEN c.sunday = 1
        THEN 'Sunday'

        ELSE 'Other'
    END AS service_type,

    COUNT(t.trip_id) AS scheduled_trips,

    DENSE_RANK() OVER (
        ORDER BY COUNT(t.trip_id) DESC
    ) AS service_rank

FROM calendar c
JOIN trips t
    ON c.service_id = t.service_id

GROUP BY
    c.service_id,
    service_type

ORDER BY service_rank;
