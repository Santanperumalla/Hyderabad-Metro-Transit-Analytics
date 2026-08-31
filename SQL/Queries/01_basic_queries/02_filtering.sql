--- SELECTING THE DATABASE
USE hyderabadmetroanalytics;


--- FILTERING QUERIES

---FIND A SPECIFIC AGENCY
SELECT *
FROM agency
WHERE agency_id = 'HMRL';

--- FIND ROUTES WITH A SPECIFIC ROUTE_TYPE
SELECT route_id, route_short_name, route_long_name, route_type
FROM routes
WHERE route_type = 1;

--- FIND STOPS CONTAINING "METRO"
SELECT stop_id, stop_name
FROM stops
WHERE stop_name LIKE '%Metro%';

--- FIND STOPS WITH A LATITUDE GREATER THAN A VALUE
SELECT stop_id, stop_name, stop_lat, stop_lon
FROM stops
WHERE stop_lat > 17.40;

--- FIND TRIPS BELONG TO A PARTICULAR ZONE
SELECT trip_id, route_id, service_id
FROM trips
WHERE route_id = 'BLUE';

--- FIND STOP TIMES FOR A PARTICULAR TRIP
SELECT trip_id, arrival_time, departure_time, stop_id, stop_sequence
FROM stop_times
WHERE trip_id = 'SA_113485';

--- FIND FARE ABOVE A PARTICULAR PRICE
SELECT fare_id, price, currency_type
FROM fare_attributes
WHERE price > 25;

--- FIND FARES WITHIN A PRICE RANGE
SELECT fare_id, price, currency_type
FROM fare_attributes
WHERE price BETWEEN 10 AND 50;

--- FIND SERVICE DAYS WHERE MONDAY IS AVAILABLE
SELECT service_id, monday, tuesday, wednesday,
       thursday, friday, saturday, sunday
FROM calendar
WHERE monday = 1;

--- FIND TRIPS FOR MULTIPLE DIRECTIONS
SELECT trip_id, route_id, service_id
FROM trips
WHERE direction_id IN ('0','1');