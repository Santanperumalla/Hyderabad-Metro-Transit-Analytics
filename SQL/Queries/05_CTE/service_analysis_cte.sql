--- USING THE REQUIRED DATABASE
USE hyderabadmetrotransitanalytics;


---QUERIES WITH CTE FOR SERVICE ANALYSIS

---Trips by service type
---Q. How many trips are scheduled under each service calendar?
WITH service_trips AS (
    SELECT
        service_id,
        COUNT(*) AS total_trips
    FROM trips
    GROUP BY service_id
)
SELECT
    c.service_id,
    c.monday,
    c.tuesday,
    c.wednesday,
    c.thursday,
    c.friday,
    c.saturday,
    c.sunday,
    st.total_trips
FROM calendar c
JOIN service_trips st
    ON c.service_id = st.service_id
ORDER BY st.total_trips DESC;

---Service type classification
---Q. Is each service calendar a weekday, Saturday, or Sunday service?
WITH service_days AS (
    SELECT
        service_id,
        monday + tuesday + wednesday +
        thursday + friday + saturday + sunday AS operating_days
    FROM calendar
)
SELECT
    service_id,
    operating_days,
    CASE
        WHEN operating_days = 5 THEN 'Weekday Service'
        WHEN operating_days = 1
             AND saturday = 1 THEN 'Saturday Service'
        WHEN operating_days = 1
             AND sunday = 1 THEN 'Sunday Service'
        ELSE 'Other Service'
    END AS service_type
FROM calendar
JOIN service_days
    USING (service_id);

---Route-wise service availability
---Q. Which routes operate under each service calendar?
WITH route_service AS (
    SELECT
        service_id,
        route_id,
        COUNT(*) AS scheduled_trips
    FROM trips
    GROUP BY
        service_id,
        route_id
)
SELECT
    rs.service_id,
    c.start_date,
    c.end_date,
    r.route_id,
    r.route_short_name,
    rs.scheduled_trips
FROM route_service rs
JOIN calendar c
    ON rs.service_id = c.service_id
JOIN routes r
    ON rs.route_id = r.route_id
ORDER BY
    rs.service_id,
    rs.scheduled_trips DESC;

---Service-level direction balance
---Q. How balanced are scheduled trips between directions for each service?
WITH service_direction AS (
    SELECT
        service_id,
        direction_id,
        COUNT(*) AS trip_count
    FROM trips
    GROUP BY
        service_id,
        direction_id
)
SELECT
    service_id,
    SUM(
        CASE
            WHEN direction_id = 0 THEN trip_count
            ELSE 0
        END
    ) AS direction_0_trips,
    SUM(
        CASE
            WHEN direction_id = 1 THEN trip_count
            ELSE 0
        END
    ) AS direction_1_trips
FROM service_direction
GROUP BY service_id
ORDER BY service_id;

---Rank service calendars by scheduled trips
---Q. Which service calendar provides the greatest scheduled service?
WITH service_trip_counts AS (
    SELECT
        service_id,
        COUNT(*) AS total_trips
    FROM trips
    GROUP BY service_id
),
ranked_services AS (
    SELECT
        service_id,
        total_trips,
        DENSE_RANK() OVER (
            ORDER BY total_trips DESC
        ) AS service_rank
    FROM service_trip_counts
)
SELECT
    rs.service_id,
    rs.total_trips,
    rs.service_rank,
    c.start_date,
    c.end_date
FROM ranked_services rs
JOIN calendar c
    ON rs.service_id = c.service_id
ORDER BY rs.service_rank;
