---SELECTING THE DATABASE

USE hyderabadmetroanalytics;


--- SHOWING THE DATABASE SCHEMA REPRESENTING WITH EACH TABLE

--- 1. AGENCY
CREATE TABLE agency (
    agency_id VARCHAR(20) NOT NULL,
    agency_name VARCHAR(150) NOT NULL,
    agency_url VARCHAR(255) NOT NULL,
    agency_timezone VARCHAR(50) NOT NULL,
    agency_lang VARCHAR(10) NOT NULL,
    agency_fare_url VARCHAR(255),
    agency_email VARCHAR(150),
    agency_phone VARCHAR(30),

    CONSTRAINT pk_agency
        PRIMARY KEY (agency_id)
);

--- 2. CALENDAR
CREATE TABLE calendar (
    service_id VARCHAR(20) NOT NULL,
    monday TINYINT(1) NOT NULL,
    tuesday TINYINT(1) NOT NULL,
    wednesday TINYINT(1) NOT NULL,
    thursday TINYINT(1) NOT NULL,
    friday TINYINT(1) NOT NULL,
    saturday TINYINT(1) NOT NULL,
    sunday TINYINT(1) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,

    CONSTRAINT pk_calendar
        PRIMARY KEY (service_id),

    CONSTRAINT chk_calendar_dates
        CHECK (start_date <= end_date)
);

--- 3. FARE ATTRIBUTES
CREATE TABLE fare_attributes (
    fare_id VARCHAR(20) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    currency_type CHAR(3) NOT NULL,
    payment_method TINYINT NOT NULL,
    transfers TINYINT,
    agency_id VARCHAR(20) NOT NULL,

    CONSTRAINT pk_fare_attributes
        PRIMARY KEY (fare_id),

    CONSTRAINT fk_fare_attributes_agency
        FOREIGN KEY (agency_id)
        REFERENCES agency (agency_id)
);

--- 4. FARE RULES
CREATE TABLE fare_rules (
    origin_id VARCHAR(20) NOT NULL,
    destination_id VARCHAR(20) NOT NULL,
    fare_id VARCHAR(20) NOT NULL,

    CONSTRAINT pk_fare_rules
        PRIMARY KEY (origin_id, destination_id, fare_id),

    CONSTRAINT fk_fare_rules_fare
        FOREIGN KEY (fare_id)
        REFERENCES fare_attributes (fare_id)
);

--- 5. FEED INFO
CREATE TABLE feed_info (
    feed_publisher_name VARCHAR(150) NOT NULL,
    feed_publisher_url VARCHAR(255) NOT NULL,
    feed_lang VARCHAR(10) NOT NULL,
    feed_contact_url VARCHAR(255),
    feed_start_date DATE NOT NULL,
    feed_end_date DATE NOT NULL,

    CONSTRAINT chk_feed_dates
        CHECK (feed_start_date <= feed_end_date)
);

-- 6. ROUTES
CREATE TABLE routes (
    route_id VARCHAR(20) NOT NULL,
    agency_id VARCHAR(20) NOT NULL,
    route_short_name VARCHAR(50) NOT NULL,
    route_long_name VARCHAR(255) NOT NULL,
    route_type TINYINT NOT NULL,
    route_color CHAR(6),
    route_text_color CHAR(6),
    route_sort_order INT,

    CONSTRAINT pk_routes
        PRIMARY KEY (route_id),

    CONSTRAINT fk_routes_agency
        FOREIGN KEY (agency_id)
        REFERENCES agency (agency_id)
);

--- 7. SHAPES
CREATE TABLE shapes (
    shape_id VARCHAR(30) NOT NULL,
    shape_pt_lat DECIMAL(10,7) NOT NULL,
    shape_pt_lon DECIMAL(10,7) NOT NULL,
    shape_pt_sequence INT NOT NULL,
    shape_dist_traveled DECIMAL(12,2),

    CONSTRAINT pk_shapes
        PRIMARY KEY (shape_id, shape_pt_sequence)
);

--- 8. STOP TIMES
CREATE TABLE stop_times (
    trip_id VARCHAR(40) NOT NULL,
    stop_sequence INT NOT NULL,
    stop_id VARCHAR(30) NOT NULL,
    arrival_time TIME NOT NULL,
    departure_time TIME NOT NULL,
    timepoint TINYINT(1),
    shape_dist_traveled DECIMAL(12,2),

    CONSTRAINT pk_stop_times
        PRIMARY KEY (trip_id, stop_sequence),

    CONSTRAINT fk_stop_times_trip
        FOREIGN KEY (trip_id)
        REFERENCES trips (trip_id),

    CONSTRAINT fk_stop_times_stop
        FOREIGN KEY (stop_id)
        REFERENCES stops (stop_id)
);

--- 9. STOPS
CREATE TABLE stops (
    stop_id VARCHAR(30) NOT NULL,
    stop_name VARCHAR(150) NOT NULL,
    stop_lat DECIMAL(10,7) NOT NULL,
    stop_lon DECIMAL(10,7) NOT NULL,
    zone_id VARCHAR(30),
    location_type TINYINT NOT NULL,
    parent_station VARCHAR(30),
    platform_code VARCHAR(20),

    CONSTRAINT pk_stops
        PRIMARY KEY (stop_id),

    CONSTRAINT fk_stops_parent
        FOREIGN KEY (parent_station)
        REFERENCES stops (stop_id)
);

--- 10. TRIPS
CREATE TABLE trips (
    service_id VARCHAR(20) NOT NULL,
    route_id VARCHAR(20) NOT NULL,
    trip_id VARCHAR(40) NOT NULL,
    direction_id TINYINT,
    trip_headsign VARCHAR(150),
    block_id VARCHAR(40),
    shape_id VARCHAR(30),

    CONSTRAINT pk_trips
        PRIMARY KEY (trip_id),

    CONSTRAINT fk_trips_service
        FOREIGN KEY (service_id)
        REFERENCES calendar (service_id),

    CONSTRAINT fk_trips_route
        FOREIGN KEY (route_id)
        REFERENCES routes (route_id),

    CONSTRAINT fk_trips_shape
        FOREIGN KEY (shape_id)
        REFERENCES shapes (shape_id)
);