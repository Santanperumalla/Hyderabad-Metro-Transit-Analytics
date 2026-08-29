-- Agency Table
CREATE TABLE agency (
    agency_id VARCHAR(20) PRIMARY KEY,
    agency_name VARCHAR(100) NOT NULL,
    agency_url VARCHAR(255),
    agency_timezone VARCHAR(50),
    agency_lang VARCHAR(10),
    agency_fare_url VARCHAR(255),
    agency_email VARCHAR(150),
    agency_phone VARCHAR(30)
);

-- calendar Table
CREATE TABLE calendar (
    service_id VARCHAR(20) PRIMARY KEY,
    monday BOOLEAN NOT NULL,
    tuesday BOOLEAN NOT NULL,
    wednesday BOOLEAN NOT NULL,
    thursday BOOLEAN NOT NULL,
    friday BOOLEAN NOT NULL,
    saturday BOOLEAN NOT NULL,
    sunday BOOLEAN NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

--fare_attributes Table
CREATE TABLE fare_attributes (
    fare_id VARCHAR(20) PRIMARY KEY,
    price DECIMAL(10,2) NOT NULL,
    currency_type CHAR(3) NOT NULL,
    payment_method TINYINT,
    transfers TINYINT NULL,
    agency_id VARCHAR(20),
    
    CONSTRAINT fk_fare_agency
        FOREIGN KEY (agency_id)
        REFERENCES agency(agency_id)
);

-- fare_rules Table
CREATE TABLE fare_rules (
    origin_id VARCHAR(20) NOT NULL,
    destination_id VARCHAR(20) NOT NULL,
    fare_id VARCHAR(20) NOT NULL,

    PRIMARY KEY (origin_id, destination_id),

    CONSTRAINT fk_fare_rules_fare
        FOREIGN KEY (fare_id)
        REFERENCES fare_attributes(fare_id)
);

--feed_info Table
CREATE TABLE feed_info (
    feed_publisher_name VARCHAR(150) NOT NULL,
    feed_publisher_url VARCHAR(255),
    feed_lang VARCHAR(10),
    feed_contact_url VARCHAR(255),
    feed_start_date DATE,
    feed_end_date DATE
);

--routes Table
CREATE TABLE routes (
    route_id VARCHAR(20) PRIMARY KEY,
    agency_id VARCHAR(20) NOT NULL,
    route_short_name VARCHAR(30),
    route_long_name VARCHAR(150),
    route_type TINYINT,
    route_color CHAR(6),
    route_text_color CHAR(6),
    route_sort_order INT,

    CONSTRAINT fk_routes_agency
        FOREIGN KEY (agency_id)
        REFERENCES agency(agency_id)
);

--shapes Table
CREATE TABLE shapes (
    shape_id VARCHAR(20) NOT NULL,
    shape_pt_lat DECIMAL(10,7) NOT NULL,
    shape_pt_lon DECIMAL(10,7) NOT NULL,
    shape_pt_sequence INT NOT NULL,
    shape_dist_traveled DECIMAL(12,2),

    PRIMARY KEY (shape_id, shape_pt_sequence)
);

--stop_times Table
CREATE TABLE stop_times (
    trip_id VARCHAR(30) NOT NULL,
    stop_sequence INT NOT NULL,
    stop_id VARCHAR(20) NOT NULL,
    arrival_time TIME,
    departure_time TIME,
    timepoint BOOLEAN,
    shape_dist_traveled DECIMAL(12,2),

    PRIMARY KEY (trip_id, stop_sequence),

    CONSTRAINT fk_stop_times_trip
        FOREIGN KEY (trip_id)
        REFERENCES trips(trip_id),

    CONSTRAINT fk_stop_times_stop
        FOREIGN KEY (stop_id)
        REFERENCES stops(stop_id)
);

--stops Table
CREATE TABLE stops (
    stop_id VARCHAR(20) PRIMARY KEY,
    stop_name VARCHAR(100) NOT NULL,
    stop_lat DECIMAL(10,7),
    stop_lon DECIMAL(10,7),
    zone_id VARCHAR(20),
    location_type TINYINT,
    parent_station VARCHAR(20),
    platform_code VARCHAR(10),

    CONSTRAINT fk_stops_parent
        FOREIGN KEY (parent_station)
        REFERENCES stops(stop_id)
);

--trips Table
CREATE TABLE trips (
    service_id VARCHAR(20) NOT NULL,
    route_id VARCHAR(20) NOT NULL,
    trip_id VARCHAR(30) PRIMARY KEY,
    direction_id BOOLEAN,
    trip_headsign VARCHAR(100),
    block_id VARCHAR(30),
    shape_id VARCHAR(20),

    CONSTRAINT fk_trips_service
        FOREIGN KEY (service_id)
        REFERENCES calendar(service_id),

    CONSTRAINT fk_trips_route
        FOREIGN KEY (route_id)
        REFERENCES routes(route_id)
);

