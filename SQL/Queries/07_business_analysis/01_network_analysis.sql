--- QUERIES FOR MAKING NETWORK ANALYSIS

--- How many agencies are in the dataset?
SELECT 
    COUNT(*) AS total_agencies
FROM agency;

--- How many routes are available?
SELECT 
    COUNT(*) AS total_routes
FROM routes;

--- How many stops/stations are available?
SELECT 
    COUNT(*) AS total_stops
FROM stops;

--- How many trips are scheduled?
SELECT 
    COUNT(*) AS total_trips
FROM trips;

--- How many unique services are scheduled?
SELECT 
    COUNT(DISTINCT service_id) AS total_services
FROM trips;

--- How many stops are associated with each route?
SELECT
    r.route_id,
    r.route_short_name,
    r.route_long_name,
    COUNT(DISTINCT st.stop_id) AS total_stops
FROM routes r
JOIN trips t
    ON r.route_id = t.route_id
JOIN stop_times st
    ON t.trip_id = st.trip_id
GROUP BY
    r.route_id,
    r.route_short_name,
    r.route_long_name
ORDER BY total_stops DESC;

--- How many trips operate on each route?
SELECT
    r.route_id,
    r.route_short_name,
    r.route_long_name,
    COUNT(t.trip_id) AS total_trips
FROM routes r
JOIN trips t
    ON r.route_id = t.route_id
GROUP BY
    r.route_id,
    r.route_short_name,
    r.route_long_name
ORDER BY total_trips DESC;

--- What route types exist in the network?
SELECT
    route_type,
    COUNT(*) AS route_count
FROM routes
GROUP BY route_type
ORDER BY route_count DESC;

