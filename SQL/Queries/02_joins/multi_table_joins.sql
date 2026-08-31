--- USING THE REQUIRED DATABASE
USE hyderabadmetrotransitanalytics;


--- QUERIES WITH MULTI_TABLE_JOINS

---Which agency operates which routes and trips?
SELECT
    a.agency_name,
    r.route_short_name,
    r.route_long_name,
    t.trip_id,
    t.trip_headsign
FROM agency AS a
INNER JOIN routes AS r
    ON a.agency_id = r.agency_id
INNER JOIN trips AS t
    ON r.route_id = t.route_id;

---Show every route's scheduled trip stops.
SELECT
    r.route_short_name,
    t.trip_id,
    t.trip_headsign,
    st.stop_sequence,
    st.stop_id,
    st.arrival_time,
    st.departure_time
FROM routes AS r
INNER JOIN trips AS t
    ON r.route_id = t.route_id
INNER JOIN stop_times AS st
    ON t.trip_id = st.trip_id
ORDER BY r.route_id, t.trip_id, st.stop_sequence;

---Show trip schedules with station names.
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

---Which service schedule operates each route?
SELECT
    c.service_id,
    c.start_date,
    c.end_date,
    r.route_short_name,
    r.route_long_name,
    t.trip_id,
    t.trip_headsign
FROM calendar AS c
INNER JOIN trips AS t
    ON c.service_id = t.service_id
INNER JOIN routes AS r
    ON t.route_id = r.route_id;

---What fares and fare rules are provided by the agency?
SELECT
    a.agency_name,
    f.fare_id,
    f.price,
    f.currency_type,
    fr.origin_id,
    fr.destination_id
FROM agency AS a
INNER JOIN fare_attributes AS f
    ON a.agency_id = f.agency_id
INNER JOIN fare_rules AS fr
    ON f.fare_id = fr.fare_id;

---Which geographic shape is used by trips on each route?
SELECT
    r.route_short_name,
    t.trip_id,
    t.trip_headsign,
    t.shape_id,
    sh.shape_pt_sequence,
    sh.shape_pt_lat,
    sh.shape_pt_lon
FROM routes AS r
INNER JOIN trips AS t
    ON r.route_id = t.route_id
INNER JOIN shapes AS sh
    ON t.shape_id = sh.shape_id
ORDER BY r.route_id, t.trip_id, sh.shape_pt_sequence;

---Build a complete route → trip → station schedule.
SELECT
    r.route_short_name,
    r.route_long_name,
    t.trip_id,
    t.trip_headsign,
    st.stop_sequence,
    s.stop_name,
    st.arrival_time,
    st.departure_time
FROM routes AS r
INNER JOIN trips AS t
    ON r.route_id = t.route_id
INNER JOIN stop_times AS st
    ON t.trip_id = st.trip_id
INNER JOIN stops AS s
    ON st.stop_id = s.stop_id
ORDER BY r.route_id, t.trip_id, st.stop_sequence;

---Which stations are served under each service schedule?
SELECT
    c.service_id,
    t.trip_id,
    t.route_id,
    s.stop_name,
    st.stop_sequence,
    st.arrival_time
FROM calendar AS c
INNER JOIN trips AS t
    ON c.service_id = t.service_id
INNER JOIN stop_times AS st
    ON t.trip_id = st.trip_id
INNER JOIN stops AS s
    ON st.stop_id = s.stop_id
ORDER BY c.service_id, t.trip_id, st.stop_sequence;

---Show the complete agency-to-station service chain.
SELECT
    a.agency_name,
    r.route_short_name,
    t.trip_id,
    t.trip_headsign,
    s.stop_name
FROM agency AS a
INNER JOIN routes AS r
    ON a.agency_id = r.agency_id
INNER JOIN trips AS t
    ON r.route_id = t.route_id
INNER JOIN stop_times AS st
    ON t.trip_id = st.trip_id
INNER JOIN stops AS s
    ON st.stop_id = s.stop_id;

---Combine operational and geographic information.
SELECT
    r.route_short_name,
    t.trip_id,
    s.stop_name,
    st.stop_sequence,
    sh.shape_pt_sequence,
    sh.shape_pt_lat,
    sh.shape_pt_lon
FROM routes AS r
INNER JOIN trips AS t
    ON r.route_id = t.route_id
INNER JOIN stop_times AS st
    ON t.trip_id = st.trip_id
INNER JOIN stops AS s
    ON st.stop_id = s.stop_id
INNER JOIN shapes AS sh
    ON t.shape_id = sh.shape_id
   AND st.shape_dist_traveled = sh.shape_dist_traveled
ORDER BY
    r.route_id,
    t.trip_id,
    st.stop_sequence;