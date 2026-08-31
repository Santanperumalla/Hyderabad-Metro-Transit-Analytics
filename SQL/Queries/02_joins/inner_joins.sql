--- USING THE REQUIRED DATABASE
USE hyderabadmetrotransitanalytics;

--- QUERIES WITH INNER JOIN

--- Which routes are operated by each agency?
SELECT
    a.agency_id,
    a.agency_name,
    r.route_id,
    r.route_short_name,
    r.route_long_name
FROM agency AS a
INNER JOIN routes AS r
    ON a.agency_id = r.agency_id;

---Which trips operate on each metro route?
SELECT
    r.route_id,
    r.route_short_name,
    t.trip_id,
    t.trip_headsign,
    t.direction_id
FROM routes AS r
INNER JOIN trips AS t
    ON r.route_id = t.route_id;

---Which trips belong to each service schedule?
SELECT
    c.service_id,
    c.monday,
    c.tuesday,
    c.wednesday,
    c.thursday,
    c.friday,
    t.trip_id,
    t.route_id
FROM calendar AS c
INNER JOIN trips AS t
    ON c.service_id = t.service_id;

---Which scheduled stops belong to each trip?
SELECT
    t.trip_id,
    t.route_id,
    t.trip_headsign,
    st.stop_sequence,
    st.stop_id,
    st.arrival_time,
    st.departure_time
FROM trips AS t
INNER JOIN stop_times AS st
    ON t.trip_id = st.trip_id;

---Which station is associated with each scheduled stop?

SELECT
    st.trip_id,
    st.stop_sequence,
    st.arrival_time,
    st.departure_time,
    s.stop_id,
    s.stop_name  
FROM stop_times AS st
INNER JOIN stops AS s
    ON st.stop_id = s.stop_id;

---Which geographic shape is used by each trip?
SELECT
    t.trip_id,
    t.route_id,
    t.trip_headsign,
    t.shape_id,
    sh.shape_pt_sequence,
    sh.shape_pt_lat,
    sh.shape_pt_lon
FROM trips AS t
INNER JOIN shapes AS sh
    ON t.shape_id = sh.shape_id;

---Which fares are associated with the metro agency?
SELECT
    a.agency_id,
    a.agency_name,
    f.fare_id,
    f.price,
    f.currency_type,
    f.payment_method
FROM agency AS a
INNER JOIN fare_attributes AS f
    ON a.agency_id = f.agency_id;

---Which fare rules use each fare?
SELECT
    f.fare_id,
    f.price,
    f.currency_type,
    fr.origin_id,
    fr.destination_id
FROM fare_attributes AS f
INNER JOIN fare_rules AS fr
    ON f.fare_id = fr.fare_id;

---What are the trip headsigns and directions for each route?
SELECT
    r.route_id,
    r.route_short_name,
    r.route_long_name,
    t.trip_id,
    t.direction_id,
    t.trip_headsign
FROM routes AS r
INNER JOIN trips AS t
    ON r.route_id = t.route_id
WHERE t.direction_id IN (0, 1);

---What is the complete scheduled stop sequence for trips?
SELECT
    t.trip_id,
    t.route_id,
    t.trip_headsign,
    st.stop_sequence,
    s.stop_name,
    st.arrival_time,
    st.departure_time
FROM trips AS t
INNER JOIN stop_times AS st
    ON t.trip_id = st.trip_id
INNER JOIN stops AS s
    ON st.stop_id = s.stop_id
ORDER BY t.trip_id, st.stop_sequence;