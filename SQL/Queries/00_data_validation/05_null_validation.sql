-- Checking for null values in the records from every table in database

-- 1. Agency Table
SELECT
    COUNT(*) AS total_rows,
    SUM(agency_id IS NULL) AS agency_id_nulls,
    SUM(agency_name IS NULL) AS agency_name_nulls,
    SUM(agency_url IS NULL) AS agency_url_nulls,
    SUM(agency_timezone IS NULL) AS agency_timezone_nulls,
    SUM(agency_lang IS NULL) AS agency_lang_nulls,
    SUM(agency_phone IS NULL) AS agency_phone_nulls
FROM agency;

-- 2. Calendar Table
SELECT
    COUNT(*) AS total_rows,
    SUM(service_id IS NULL) AS service_id_nulls,
    SUM(monday IS NULL) AS monday_nulls,
    SUM(tuesday IS NULL) AS tuesday_nulls,
    SUM(wednesday IS NULL) AS wednesday_nulls,
    SUM(thursday IS NULL) AS thursday_nulls,
    SUM(friday IS NULL) AS friday_nulls,
    SUM(saturday IS NULL) AS saturday_nulls,
    SUM(sunday IS NULL) AS sunday_nulls,
    SUM(start_date IS NULL) AS start_date_nulls,
    SUM(end_date IS NULL) AS end_date_nulls
FROM calendar;

-- 3. Fare_attributes Table
SELECT
    COUNT(*) AS total_rows,
    SUM(fare_id IS NULL) AS fare_id_nulls,
    SUM(price IS NULL) AS price_nulls,
    SUM(currency_type IS NULL) AS currency_type_nulls,
    SUM(payment_method IS NULL) AS payment_method_nulls,
    SUM(transfers IS NULL) AS transfers_nulls,
    SUM(agency_id IS NULL) AS agency_id_nulls
FROM fare_attributes;

-- 4. Fare_rules Table
SELECT
    COUNT(*) AS total_rows,
    SUM(fare_id IS NULL) AS fare_id_nulls,
    SUM(origin_id IS NULL) AS origin_id_nulls,
    SUM(destination_id IS NULL) AS destination_id_nulls
FROM fare_rules;

-- 5. Feed_info Table
SELECT
    COUNT(*) AS total_rows,
    SUM(feed_publisher_name IS NULL) AS publisher_name_nulls,
    SUM(feed_publisher_url IS NULL) AS publisher_url_nulls,
    SUM(feed_lang IS NULL) AS feed_lang_nulls,
    SUM(feed_start_date IS NULL) AS feed_start_date_nulls,
    SUM(feed_end_date IS NULL) AS feed_end_date_nulls
FROM feed_info;

-- 6. Routes Table
SELECT
    COUNT(*) AS total_rows,
    SUM(route_id IS NULL) AS route_id_nulls,
    SUM(agency_id IS NULL) AS agency_id_nulls,
    SUM(route_short_name IS NULL) AS route_short_name_nulls,
    SUM(route_long_name IS NULL) AS route_long_name_nulls,
    SUM(route_type IS NULL) AS route_type_nulls
FROM routes;

--7. Shapes Table
SELECT
    COUNT(*) AS total_rows,
    SUM(shape_id IS NULL) AS shape_id_nulls,
    SUM(shape_pt_lat IS NULL) AS latitude_nulls,
    SUM(shape_pt_lon IS NULL) AS longitude_nulls,
    SUM(shape_pt_sequence IS NULL) AS sequence_nulls
FROM shapes;

-- 8. Stop_times Table
SELECT
    COUNT(*) AS total_rows,
    SUM(trip_id IS NULL) AS trip_id_nulls,
    SUM(arrival_time IS NULL) AS arrival_time_nulls,
    SUM(departure_time IS NULL) AS departure_time_nulls,
    SUM(stop_id IS NULL) AS stop_id_nulls,
    SUM(stop_sequence IS NULL) AS stop_sequence_nulls
FROM stop_times;

-- 9. Stops Table
SELECT
    COUNT(*) AS total_rows,
    SUM(stop_id IS NULL) AS stop_id_nulls,
    SUM(stop_name IS NULL) AS stop_name_nulls,
    SUM(stop_lat IS NULL) AS latitude_nulls,
    SUM(stop_lon IS NULL) AS longitude_nulls,
    SUM(zone_id IS NULL) AS zone_id_nulls,
    SUM(location_type IS NULL) AS location_type_nulls,
    SUM(parent_station IS NULL) AS parent_station_nulls
FROM stops;

-- 10. Trips Table
SELECT
    COUNT(*) AS total_rows,
    SUM(route_id IS NULL) AS route_id_nulls,
    SUM(service_id IS NULL) AS service_id_nulls,
    SUM(trip_id IS NULL) AS trip_id_nulls,
    SUM(trip_headsign IS NULL) AS headsign_nulls,
    SUM(direction_id IS NULL) AS direction_id_nulls,
    SUM(shape_id IS NULL) AS shape_id_nulls
FROM trips;