--- USING THE REQUIRED DATABASE
USE hyderabadmetrotransitanalytics;


--- QUERIES WITH LEFT JOIN

---All Agencies and Their Routes
SELECT
    a.agency_id,
    a.agency_name,
    r.route_id,
    r.route_short_name
FROM agency AS a
LEFT JOIN routes AS r
    ON a.agency_id = r.agency_id;

---All Routes and Their Trips
SELECT
    r.route_id,
    r.route_short_name,
    r.route_long_name,
    t.trip_id,
    t.trip_headsign
FROM routes AS r
LEFT JOIN trips AS t
    ON r.route_id = t.route_id;

---Find Routes Without Trips
SELECT
    r.route_id,
    r.route_short_name,
    r.route_long_name
FROM routes AS r
LEFT JOIN trips AS t
    ON r.route_id = t.route_id
WHERE t.trip_id IS NULL;

---All Calendar Services and Their Trips
SELECT
    c.service_id,
    c.start_date,
    c.end_date,
    t.trip_id,
    t.route_id
FROM calendar AS c
LEFT JOIN trips AS t
    ON c.service_id = t.service_id;

---Find Services Without Trips
SELECT
    c.service_id,
    c.start_date,
    c.end_date
FROM calendar AS c
LEFT JOIN trips AS t
    ON c.service_id = t.service_id
WHERE t.trip_id IS NULL;

---All Trips and Their Stop Times
SELECT
    t.trip_id,
    t.route_id,
    t.trip_headsign,
    st.stop_sequence,
    st.arrival_time
FROM trips AS t
LEFT JOIN stop_times AS st
    ON t.trip_id = st.trip_id;

---Find Trips Without Stop Times
SELECT
    t.trip_id,
    t.route_id,
    t.trip_headsign
FROM trips AS t
LEFT JOIN stop_times AS st
    ON t.trip_id = st.trip_id
WHERE st.trip_id IS NULL;

---All Stops and Their Scheduled Usage
SELECT
    s.stop_id,
    s.stop_name,
    s.location_type,
    st.trip_id,
    st.stop_sequence
FROM stops AS s
LEFT JOIN stop_times AS st
    ON s.stop_id = st.stop_id;

---Find Stops Not Used in Any Trip
SELECT
    s.stop_id,
    s.stop_name,
    s.location_type
FROM stops AS s
LEFT JOIN stop_times AS st
    ON s.stop_id = st.stop_id
WHERE st.stop_id IS NULL;

---All Trips and Their Shapes
SELECT
    t.trip_id,
    t.route_id,
    t.trip_headsign,
    t.shape_id,
    sh.shape_pt_sequence
FROM trips AS t
LEFT JOIN shapes AS sh
    ON t.shape_id = sh.shape_id;
