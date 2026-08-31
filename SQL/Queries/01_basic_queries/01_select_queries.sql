--- USING THE DATABASE

USE hyderabadmetrotransitanalytics;


--- QUERIES USING SELECT

--- DISPLAY ALL AGENCIES
select * 
from agency;

--- DISPLAY AGENCY NAMES & URL
select agency_name, agency_url 
from agency;

--- DISPLAY ALL ROUTES
select * 
from routes;

--- DISPLAY ROUTES NAMES & ROUTE TYPES
select route_short_name, route_long_name, route_type 
from routes;

--- DISPLAY ALL METRO STOPS
select * 
from stops;

--- DISPLAY STOP NAMES & LOCATIONS
select stop_id, stop_name, stop_lat, stop_lon
from stops;

--- DISPLAY ALL TRIPS
select *
from trips;

--- DISPLAY TRIP & ROUTE INFORMATION
select route_id, service_id, trip_id
from trips;

--- DISPLAY STOP-TIME INFORMATION
select trip_id, arrival_time, departure_time, stop_id, stop_sequence
from stop_times;

--- DISPLAY FARE INFORMATION 
select fare_id, price, currency_type, payment_method
from fare_attributes;