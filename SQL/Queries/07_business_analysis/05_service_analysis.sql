--- QUERIES FOR MAKING SERVICE ANALYSIS

---How many trips operate under each service?
SELECT
    service_id,
    COUNT(*) AS trip_count
FROM trips
GROUP BY service_id
ORDER BY trip_count DESC;

---What are the service patterns by day of week?
SELECT
    monday,
    tuesday,
    wednesday,
    thursday,
    friday,
    saturday,
    sunday,
    COUNT(*) AS service_count
FROM calendar
GROUP BY
    monday,
    tuesday,
    wednesday,
    thursday,
    friday,
    saturday,
    sunday
ORDER BY service_count DESC;

---How many active services operate on each weekday?
SELECT
    SUM(monday) AS monday_services,
    SUM(tuesday) AS tuesday_services,
    SUM(wednesday) AS wednesday_services,
    SUM(thursday) AS thursday_services,
    SUM(friday) AS friday_services,
    SUM(saturday) AS saturday_services,
    SUM(sunday) AS sunday_services
FROM calendar;

---Which routes have weekday service?
SELECT
    r.route_id,
    r.route_short_name,
    COUNT(DISTINCT t.trip_id) AS weekday_trips
FROM routes r
JOIN trips t
    ON r.route_id = t.route_id
JOIN calendar c
    ON t.service_id = c.service_id
WHERE
    c.monday = 1
    OR c.tuesday = 1
    OR c.wednesday = 1
    OR c.thursday = 1
    OR c.friday = 1
GROUP BY
    r.route_id,
    r.route_short_name
ORDER BY weekday_trips DESC;

---Which routes have weekend service?
SELECT
    r.route_id,
    r.route_short_name,
    COUNT(DISTINCT t.trip_id) AS weekend_trips
FROM routes r
JOIN trips t
    ON r.route_id = t.route_id
JOIN calendar c
    ON t.service_id = c.service_id
WHERE
    c.saturday = 1
    OR c.sunday = 1
GROUP BY
    r.route_id,
    r.route_short_name
ORDER BY weekend_trips DESC;

