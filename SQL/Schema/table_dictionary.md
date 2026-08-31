# Hyderabad Metro — MySQL Table Dictionary

> **Purpose:** Data dictionary for the Hyderabad Metro MySQL database.
>
> **Source:** GTFS-style datasets supplied for this project.
>
> **Source files:** `agency.txt`, `calendar.txt`, `fare_attributes.txt`, `fare_rules.txt`, `feed_info.txt`, `routes.txt`, `shapes.txt`, `stop_times.txt`, `stops.txt`, and `trips.txt`.
>
> **Repository location:** `schema/table_dictionary.md`

---

## Database Overview

The Hyderabad Metro database represents five major areas of the transit system:

| Area                 | Tables                            |
| -------------------- | --------------------------------- |
| Agency & Feed        | `agency`, `feed_info`             |
| Service & Scheduling | `calendar`, `trips`, `stop_times` |
| Network              | `routes`, `stops`, `shapes`       |
| Fare                 | `fare_attributes`, `fare_rules`   |

### Overall Data Flow

```text
agency
   │
   ├──────────────► routes
   │                  │
   │                  ▼
   │                trips ◄──────── calendar
   │                  │
   │                  ▼
   │              stop_times ─────► stops
   │                  │
   │                  ▼
   │                shapes
   │
   └──────────────► fare_attributes
                         ▲
                         │
                    fare_rules
```

---

# Table Summary

|  # | Table             | Source File           | Purpose                                                  | Primary Key                          |
| -: | ----------------- | --------------------- | -------------------------------------------------------- | ------------------------------------ |
|  1 | `agency`          | `agency.txt`          | Stores metro agency/operator information                 | `agency_id`                          |
|  2 | `calendar`        | `calendar.txt`        | Defines service availability by day and date range       | `service_id`                         |
|  3 | `fare_attributes` | `fare_attributes.txt` | Stores fare amounts and payment-related attributes       | `fare_id`                            |
|  4 | `fare_rules`      | `fare_rules.txt`      | Maps origin/destination combinations to fares            | `origin_id, destination_id, fare_id` |
|  5 | `feed_info`       | `feed_info.txt`       | Stores metadata about the published data feed            | No natural key supplied              |
|  6 | `routes`          | `routes.txt`          | Stores metro route/line information                      | `route_id`                           |
|  7 | `shapes`          | `shapes.txt`          | Stores geographic points used to represent route paths   | `shape_id, shape_pt_sequence`        |
|  8 | `stop_times`      | `stop_times.txt`      | Stores scheduled arrival/departure information for trips | `trip_id, stop_sequence`             |
|  9 | `stops`           | `stops.txt`           | Stores stations, platforms, locations and zones          | `stop_id`                            |
| 10 | `trips`           | `trips.txt`           | Defines individual scheduled trips                       | `trip_id`                            |

---

# `agency`

**Source file:** `agency.txt`

### Purpose

Stores information about the organization operating the transit service.

The supplied source contains the Hyderabad Metro Rail agency with agency identifier `HMRL`.

### Columns

| Column            | MySQL Type     | Key | Nullable | Description                              |
| ----------------- | -------------- | --- | -------- | ---------------------------------------- |
| `agency_id`       | `VARCHAR(20)`  | PK  | No       | Unique identifier for the transit agency |
| `agency_name`     | `VARCHAR(150)` | —   | No       | Official name of the transit agency      |
| `agency_url`      | `VARCHAR(255)` | —   | No       | Agency website URL                       |
| `agency_timezone` | `VARCHAR(50)`  | —   | No       | Time zone used by the agency             |
| `agency_lang`     | `VARCHAR(10)`  | —   | No       | Primary language code                    |
| `agency_fare_url` | `VARCHAR(255)` | —   | Yes      | URL containing fare information          |
| `agency_email`    | `VARCHAR(150)` | —   | Yes      | Customer/service email                   |
| `agency_phone`    | `VARCHAR(30)`  | —   | Yes      | Customer/service telephone number        |

### Relationships

```text
agency.agency_id
       │
       ├──────────► routes.agency_id
       │
       └──────────► fare_attributes.agency_id
```

---

# `calendar`

**Source file:** `calendar.txt`

### Purpose

Defines the days of the week on which a particular service operates and the date range during which that service is valid.

The supplied data contains `WK`, `SA`, and `SU` service identifiers representing weekday, Saturday and Sunday schedules.

### Columns

| Column       | MySQL Type    | Key | Nullable | Description                                  |
| ------------ | ------------- | --- | -------- | -------------------------------------------- |
| `service_id` | `VARCHAR(20)` | PK  | No       | Unique identifier for a service calendar     |
| `monday`     | `TINYINT(1)`  | —   | No       | Indicates whether service operates Monday    |
| `tuesday`    | `TINYINT(1)`  | —   | No       | Indicates whether service operates Tuesday   |
| `wednesday`  | `TINYINT(1)`  | —   | No       | Indicates whether service operates Wednesday |
| `thursday`   | `TINYINT(1)`  | —   | No       | Indicates whether service operates Thursday  |
| `friday`     | `TINYINT(1)`  | —   | No       | Indicates whether service operates Friday    |
| `saturday`   | `TINYINT(1)`  | —   | No       | Indicates whether service operates Saturday  |
| `sunday`     | `TINYINT(1)`  | —   | No       | Indicates whether service operates Sunday    |
| `start_date` | `DATE`        | —   | No       | First date on which the service is valid     |
| `end_date`   | `DATE`        | —   | No       | Last date on which the service is valid      |

### Day Flag Convention

```text
1 = Service operates
0 = Service does not operate
```

### Relationship

```text
calendar.service_id
        │
        ▼
trips.service_id
```

---

# `fare_attributes`

**Source file:** `fare_attributes.txt`

### Purpose

Stores fare amounts and fare-payment attributes.

The supplied data contains fare identifiers such as `F_12`, `F_18`, `F_30`, etc., with currency `INR` and agency identifier `HMRL`.

### Columns

| Column           | MySQL Type      | Key | Nullable | Description                                              |
| ---------------- | --------------- | --- | -------- | -------------------------------------------------------- |
| `fare_id`        | `VARCHAR(20)`   | PK  | No       | Unique identifier for the fare                           |
| `price`          | `DECIMAL(10,2)` | —   | No       | Fare amount                                              |
| `currency_type`  | `CHAR(3)`       | —   | No       | Currency code                                            |
| `payment_method` | `TINYINT`       | —   | No       | Payment-method code supplied by the dataset              |
| `transfers`      | `TINYINT`       | —   | Yes      | Transfer-related value; blank values exist in the source |
| `agency_id`      | `VARCHAR(20)`   | FK  | No       | Agency associated with the fare                          |

### Relationship

```text
agency.agency_id
       │
       ▼
fare_attributes.agency_id

fare_attributes.fare_id
       │
       ▼
fare_rules.fare_id
```

---

# `fare_rules`

**Source file:** `fare_rules.txt`

### Purpose

Maps an origin and destination fare-location combination to a specific fare.

The source contains `origin_id`, `destination_id`, and `fare_id`.

### Columns

| Column           | MySQL Type    | Key    | Nullable | Description                                         |
| ---------------- | ------------- | ------ | -------- | --------------------------------------------------- |
| `origin_id`      | `VARCHAR(20)` | PK*    | No       | Origin fare-location identifier                     |
| `destination_id` | `VARCHAR(20)` | PK*    | No       | Destination fare-location identifier                |
| `fare_id`        | `VARCHAR(20)` | PK*/FK | No       | Fare assigned to the origin-destination combination |

`*` Recommended composite primary key:

```text
origin_id + destination_id + fare_id
```

### Relationship

```text
fare_attributes.fare_id
          │
          ▼
fare_rules.fare_id
```

### Important Note

The `origin_id` and `destination_id` values represent fare-location identifiers such as `NAG`, `UPL`, `MYP`, etc.

They should **not automatically be treated as foreign keys to `stops.stop_id`**, because the `stops` dataset contains both station and platform identifiers. The fare-location relationship should therefore remain logically documented unless a separate explicit mapping is implemented.

---

# `feed_info`

**Source file:** `feed_info.txt`

### Purpose

Stores metadata describing the published transit data feed.

The supplied feed identifies Open Data Telangana as the publisher and provides feed language, contact URL and validity dates.

### Columns

| Column                | MySQL Type     | Key | Nullable | Description                           |
| --------------------- | -------------- | --- | -------- | ------------------------------------- |
| `feed_publisher_name` | `VARCHAR(150)` | —   | No       | Organization publishing the data feed |
| `feed_publisher_url`  | `VARCHAR(255)` | —   | No       | Publisher website                     |
| `feed_lang`           | `VARCHAR(10)`  | —   | No       | Language used by the feed             |
| `feed_contact_url`    | `VARCHAR(255)` | —   | Yes      | Contact page for the feed             |
| `feed_start_date`     | `DATE`         | —   | No       | Start date represented by the feed    |
| `feed_end_date`       | `DATE`         | —   | No       | End date represented by the feed      |

### Relationship

`feed_info` is a **metadata table**.

The supplied source does not provide a `feed_id`, so it should not be artificially connected to the operational tables through a foreign key.

---

# `routes`

**Source file:** `routes.txt`

### Purpose

Stores information about the metro routes/lines operated by the agency.

The supplied dataset contains route identifiers including `RED`, `GREEN`, and `BLUE`.

### Columns

| Column             | MySQL Type     | Key | Nullable | Description                             |
| ------------------ | -------------- | --- | -------- | --------------------------------------- |
| `route_id`         | `VARCHAR(20)`  | PK  | No       | Unique identifier for the route/line    |
| `agency_id`        | `VARCHAR(20)`  | FK  | No       | Agency operating the route              |
| `route_short_name` | `VARCHAR(50)`  | —   | No       | Short public-facing route name          |
| `route_long_name`  | `VARCHAR(255)` | —   | No       | Full route description                  |
| `route_type`       | `TINYINT`      | —   | No       | Route type code supplied by the dataset |
| `route_color`      | `CHAR(6)`      | —   | Yes      | Route display color in hexadecimal form |
| `route_text_color` | `CHAR(6)`      | —   | Yes      | Text color in hexadecimal form          |
| `route_sort_order` | `INT`          | —   | Yes      | Display/order sequence of the route     |

### Relationships

```text
agency.agency_id
       │
       ▼
routes.agency_id
       │
       ▼
trips.route_id
```

---

# `shapes`

**Source file:** `shapes.txt`

### Purpose

Stores geographic points that collectively represent the physical path followed by a route/trip.

The dataset contains a shape identifier, latitude, longitude, point sequence and cumulative distance.

### Columns

| Column                | MySQL Type      | Key | Nullable | Description                                                  |
| --------------------- | --------------- | --- | -------- | ------------------------------------------------------------ |
| `shape_id`            | `VARCHAR(30)`   | PK* | No       | Identifier for a geographic shape                            |
| `shape_pt_lat`        | `DECIMAL(10,7)` | —   | No       | Latitude of the shape point                                  |
| `shape_pt_lon`        | `DECIMAL(10,7)` | —   | No       | Longitude of the shape point                                 |
| `shape_pt_sequence`   | `INT`           | PK* | No       | Order of the point within the shape                          |
| `shape_dist_traveled` | `DECIMAL(12,2)` | —   | Yes      | Cumulative distance traveled from the beginning of the shape |

`*` Recommended composite primary key:

```text
shape_id + shape_pt_sequence
```

### Relationship

```text
shapes.shape_id
       ▲
       │
trips.shape_id
```

### Concept

One shape consists of many ordered geographic points:

```text
Shape
  │
  ├── Point 1
  ├── Point 2
  ├── Point 3
  ├── Point 4
  └── ...
```

---

# `stop_times`

**Source file:** `stop_times.txt`

### Purpose

Stores the scheduled movement of each trip through its sequence of stops.

It connects a trip with the stops it visits and records scheduled arrival/departure times and distance information.

### Columns

| Column                | MySQL Type      | Key    | Nullable | Description                                        |
| --------------------- | --------------- | ------ | -------- | -------------------------------------------------- |
| `trip_id`             | `VARCHAR(40)`   | PK*/FK | No       | Trip associated with the stop-time record          |
| `stop_sequence`       | `INT`           | PK*    | No       | Order in which the stop is visited during the trip |
| `stop_id`             | `VARCHAR(30)`   | FK     | No       | Stop/station/platform identifier                   |
| `arrival_time`        | `TIME`          | —      | No       | Scheduled arrival time                             |
| `departure_time`      | `TIME`          | —      | No       | Scheduled departure time                           |
| `timepoint`           | `TINYINT(1)`    | —      | Yes      | Timepoint indicator supplied by the dataset        |
| `shape_dist_traveled` | `DECIMAL(12,2)` | —      | Yes      | Distance traveled along the associated shape       |

`*` Recommended composite primary key:

```text
trip_id + stop_sequence
```

### Relationships

```text
trips.trip_id
     │
     ▼
stop_times.trip_id

stops.stop_id
     │
     ▼
stop_times.stop_id
```

### Operational Flow

```text
Trip
 │
 ├── Stop 1 → Arrival → Departure
 ├── Stop 2 → Arrival → Departure
 ├── Stop 3 → Arrival → Departure
 └── ...
```

---

# `stops`

**Source file:** `stops.txt`

### Purpose

Stores metro station and platform information together with geographic coordinates, fare-zone information and station hierarchy.

The supplied dataset contains station-level records (`location_type = 1`) and platform-level records (`location_type = 0`). For example, `MYP` represents Miyapur station while `MYP1` and `MYP2` represent its platforms.

### Columns

| Column           | MySQL Type      | Key | Nullable | Description                                                     |
| ---------------- | --------------- | --- | -------- | --------------------------------------------------------------- |
| `stop_id`        | `VARCHAR(30)`   | PK  | No       | Unique station/platform identifier                              |
| `stop_name`      | `VARCHAR(150)`  | —   | No       | Public name of the station or stop                              |
| `stop_lat`       | `DECIMAL(10,7)` | —   | No       | Latitude of the location                                        |
| `stop_lon`       | `DECIMAL(10,7)` | —   | No       | Longitude of the location                                       |
| `zone_id`        | `VARCHAR(30)`   | —   | Yes      | Fare zone/location grouping identifier                          |
| `location_type`  | `TINYINT`       | —   | No       | Location type; source uses `1` for station and `0` for platform |
| `parent_station` | `VARCHAR(30)`   | FK* | Yes      | Parent station identifier for a platform                        |

`*` `parent_station` is a self-referencing foreign key to `stops.stop_id`.

### Relationships

```text
stops.stop_id
   │
   ├──────────► stop_times.stop_id
   │
   └──────────► stops.parent_station
                  (self-reference)
```

---

# `trips`

**Source file:** `trips.txt`

### Purpose

Defines individual scheduled trips operated on a particular route under a specific service calendar.

The source contains service, route, trip, direction, headsign, block and shape identifiers.

### Columns

| Column          | MySQL Type     | Key | Nullable | Description                                      |
| --------------- | -------------- | --- | -------- | ------------------------------------------------ |
| `service_id`    | `VARCHAR(20)`  | FK  | No       | Service calendar used by the trip                |
| `route_id`      | `VARCHAR(20)`  | FK  | No       | Route operated by the trip                       |
| `trip_id`       | `VARCHAR(40)`  | PK  | No       | Unique identifier for the scheduled trip         |
| `direction_id`  | `TINYINT`      | —   | Yes      | Direction indicator                              |
| `trip_headsign` | `VARCHAR(150)` | —   | Yes      | Destination/headsign displayed for the trip      |
| `block_id`      | `VARCHAR(40)`  | —   | Yes      | Block identifier grouping scheduled vehicle work |
| `shape_id`      | `VARCHAR(30)`  | FK  | Yes      | Geographic shape followed by the trip            |

### Relationships

```text
calendar.service_id
       │
       ▼
trips.service_id

routes.route_id
       │
       ▼
trips.route_id

shapes.shape_id
       │
       ▼
trips.shape_id

trips.trip_id
       │
       ▼
stop_times.trip_id
```

---

# 13. Relationship Map

## Core Operational Relationships

```text
                         ┌──────────────┐
                         │    agency    │
                         │ PK agency_id │
                         └───────┬──────┘
                                 │
                    ┌────────────┴────────────┐
                    │                         │
                    ▼                         ▼
              ┌────────────┐         ┌─────────────────┐
              │   routes   │         │ fare_attributes │
              │ PK route_id│         │ PK fare_id      │
              └─────┬──────┘         └────────┬────────┘
                    │                         │
                    │                         ▼
                    │                  ┌────────────┐
                    │                  │ fare_rules │
                    │                  └────────────┘
                    ▼
              ┌────────────┐
              │   trips    │
              │ PK trip_id │
              └─────┬──────┘
                    │
             ┌──────┴───────┐
             │              │
             ▼              ▼
       ┌────────────┐   ┌──────────┐
       │ stop_times │   │  shapes  │
       └─────┬──────┘   └──────────┘
             │
             ▼
        ┌──────────┐
        │  stops   │
        │PK stop_id│
        └────┬─────┘
             │
             └──────► parent_station
                       (self-reference)

calendar.service_id
        │
        ▼
   trips.service_id
```

---

# 14. Primary Key Strategy

| Table             | Primary Key                          |
| ----------------- | ------------------------------------ |
| `agency`          | `agency_id`                          |
| `calendar`        | `service_id`                         |
| `fare_attributes` | `fare_id`                            |
| `fare_rules`      | `origin_id, destination_id, fare_id` |
| `feed_info`       | No natural key supplied              |
| `routes`          | `route_id`                           |
| `shapes`          | `shape_id, shape_pt_sequence`        |
| `stop_times`      | `trip_id, stop_sequence`             |
| `stops`           | `stop_id`                            |
| `trips`           | `trip_id`                            |

---

# 15. Foreign Key Strategy

| Child Table       | Child Column     | Parent Table      | Parent Column |
| ----------------- | ---------------- | ----------------- | ------------- |
| `routes`          | `agency_id`      | `agency`          | `agency_id`   |
| `fare_attributes` | `agency_id`      | `agency`          | `agency_id`   |
| `fare_rules`      | `fare_id`        | `fare_attributes` | `fare_id`     |
| `trips`           | `service_id`     | `calendar`        | `service_id`  |
| `trips`           | `route_id`       | `routes`          | `route_id`    |
| `trips`           | `shape_id`       | `shapes`          | `shape_id`    |
| `stop_times`      | `trip_id`        | `trips`           | `trip_id`     |
| `stop_times`      | `stop_id`        | `stops`           | `stop_id`     |
| `stops`           | `parent_station` | `stops`           | `stop_id`     |

### Fare Relationship

```text
fare_attributes.fare_id
          │
          ▼
fare_rules.fare_id
```

`origin_id` and `destination_id` are treated as logical fare-location identifiers rather than automatically being linked to `stops.stop_id`.

---

**Total tables: 10**

```text
1. agency
2. calendar
3. fare_attributes
4. fare_rules
5. feed_info
6. routes
7. shapes
8. stop_times
9. stops
10. trips
```

---

## Dictionary Status

| Component                             | Status |
| ------------------------------------- | ------ |
| 10 source tables documented           | ✅      |
| Source files identified               | ✅      |
| Columns documented                    | ✅      |
| Recommended MySQL types               | ✅      |
| Primary keys documented               | ✅      |
| Foreign keys documented               | ✅      |
| Table relationships documented        | ✅      |
| Station/platform hierarchy documented | ✅      |
| Fare relationship documented          | ✅      |
| Data-model limitations documented     | ✅      |
| Repository placement documented       | ✅      |
