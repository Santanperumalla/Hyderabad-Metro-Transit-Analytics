--- SELECTING THE DATABASE 
USE hyderabadmetrotransitanalytics;


--- QUERIES WITH SORTING 

-- 01. Stops A-Z
SELECT stop_id, stop_name
FROM stops
ORDER BY stop_name ASC;

-- 02. Stops Z-A
SELECT stop_id, stop_name
FROM stops
ORDER BY stop_name DESC;


-- 03. Routes A-Z
SELECT route_id, route_short_name,
       route_long_name
FROM routes
ORDER BY route_short_name ASC;

-- 04. Routes by route type
SELECT route_id, route_short_name,
       route_type
FROM routes
ORDER BY route_type ASC;

-- 05. Fares lowest to highest
SELECT fare_id, price, currency_type
FROM fare_attributes
ORDER BY price ASC;

-- 06. Fares highest to lowest
SELECT fare_id, price, currency_type
FROM fare_attributes
ORDER BY price DESC;

-- 07. Stops by latitude
SELECT stop_id, stop_name, stop_lat
FROM stops
ORDER BY stop_lat ASC;

-- 08. Stops by longitude
SELECT stop_id, stop_name, stop_lon
FROM stops
ORDER BY stop_lon ASC;

-- 09. Stop sequence
SELECT trip_id, stop_id,
       arrival_time, departure_time,
       stop_sequence
FROM stop_times
ORDER BY stop_sequence ASC;

-- 10. Trips by route and service
SELECT trip_id, route_id, service_id
FROM trips
ORDER BY route_id ASC, service_id ASC;