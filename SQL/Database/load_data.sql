-- 1. AGENCY

LOAD DATA LOCAL INFILE 'C:/Users/SANTAN/Downloads/HMRL Dataset/agency.txt'
INTO TABLE agency
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 2. Calendar
LOAD DATA LOCAL INFILE 'C:/Users/SANTAN/Downloads/HMRL Dataset/calendar.txt'
INTO TABLE calendar
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 3. Fare Attributes
LOAD DATA LOCAL INFILE 'C:/Users/SANTAN/Downloads/HMRL Dataset/fare_attributes.txt'
INTO TABLE fare_attributes
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 4. Fare Rules
LOAD DATA LOCAL INFILE 'C:/Users/SANTAN/Downloads/HMRL Dataset/fare_rules.txt'
INTO TABLE fare_rules
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

--5. Feed Info
LOAD DATA LOCAL INFILE 'C:/Users/SANTAN/Downloads/HMRL Dataset/feed_info.txt'
INTO TABLE feed_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

--6. Routes
LOAD DATA LOCAL INFILE 'C:/Users/SANTAN/Downloads/HMRL Dataset/routes.txt'
INTO TABLE routes
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

--7. Shapes
LOAD DATA LOCAL INFILE 'C:/Users/SANTAN/Downloads/HMRL Dataset/shapes.txt'
INTO TABLE shapes
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; 

--8. Stop Times
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/stop_times.txt'
INTO TABLE stop_times
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    trip_id,
    stop_sequence,
    stop_id,
    arrival_time,
    departure_time,
    timepoint,
    shape_dist_traveled
);

--9. Stops
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/stops.txt'
INTO TABLE stops
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    stop_id,
    stop_name,
    stop_lat,
    stop_lon,
    zone_id,
    location_type,
    parent_station,
    platform_code
);

--10. Trips
LOAD DATA LOCAL INFILE 'C:/Users/SANTAN/Downloads/HMRL Dataset/trips.txt'
INTO TABLE trips
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
;
