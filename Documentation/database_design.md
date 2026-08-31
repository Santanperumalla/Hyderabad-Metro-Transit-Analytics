# Hyderabad Metro — Database Design

## 1. Overview

The **Database Design** stage converts the cleaned Hyderabad Metro GTFS datasets into a structured **relational MySQL database**.

The database is designed to represent the major components of the metro system and preserve the relationships between agencies, routes, services, trips, stations, stop timings, geographical shapes, and fares.

The design follows a structured relational approach so that the database can support:

* Data validation
* SQL querying
* Multi-table analysis
* Business analysis
* Reusable views
* Advanced SQL techniques
* Future reporting and visualization

The overall database-development process is:

```text
Cleaned Datasets
      ↓
Identify Entities
      ↓
Define Attributes
      ↓
Identify Primary Keys
      ↓
Identify Relationships
      ↓
Define Foreign Keys
      ↓
Create Tables
      ↓
Apply Constraints
      ↓
Create Indexes
      ↓
Load Data
      ↓
Validate Database
```

---

# 2. Database Objective

The primary objective of the database is to transform separate GTFS files into a connected relational data model.

Instead of analyzing ten independent files, the MySQL database allows the project to connect related information through identifiers.

For example:

```text
Route
  ↓
Trip
  ↓
Stop Time
  ↓
Stop
```

This makes it possible to answer analytical questions that require information from multiple datasets.

---

# 3. Database Entities

The project uses ten primary datasets, which are represented as database tables.

```text
agency
calendar
fare_attributes
fare_rules
feed_info
routes
shapes
stop_times
stops
trips
```

Each table represents a specific business or operational entity within the transit system.

---

# 4. Table Design

## 4.1 Agency Table

The `agency` table stores information about the transit agency responsible for the service.

```text
agency
├── agency_id
├── agency_name
├── agency_url
└── agency_timezone
```

### Purpose

The table provides the organization-level information associated with the transit feed.

The `agency_id` serves as the identifier used to connect agency information with other relevant records.

---

# 5. Calendar Table

The `calendar` table represents the operating schedule of transit services.

Typical attributes include:

```text
calendar
├── service_id
├── monday
├── tuesday
├── wednesday
├── thursday
├── friday
├── saturday
├── sunday
├── start_date
└── end_date
```

### Purpose

This table allows the project to determine which days a particular service operates and the period during which that service is active.

The `service_id` is particularly important because it connects service-calendar information with scheduled trips.

---

# 6. Fare Attributes Table

The `fare_attributes` table contains information about available fare products.

```text
fare_attributes
├── fare_id
├── price
├── currency_type
├── payment_method
└── ...
```

### Purpose

This table provides the attributes associated with a fare.

The `fare_id` identifies an individual fare definition.

Fare-related analysis can use this table together with `fare_rules`.

---

# 7. Fare Rules Table

The `fare_rules` table defines the conditions under which a fare applies.

The available structure includes origin and destination identifiers.

```text
fare_rules
├── fare_id
├── origin_id
└── destination_id
```

### Purpose

The table connects fare definitions with applicable origins and destinations.

An important design consideration is that this table does **not require a `route_id`** for the fare analysis in this project.

Therefore, fare analysis should be based on the actual fields available:

```text
fare_id
origin_id
destination_id
```

rather than assuming that fare rules are directly associated with routes.

---

# 8. Feed Info Table

The `feed_info` table contains metadata about the transit data feed.

```text
feed_info
├── feed_publisher_name
├── feed_publisher_url
├── feed_lang
├── feed_start_date
├── feed_end_date
└── ...
```

### Purpose

This table describes the source and validity information associated with the dataset.

Unlike transactional or operational tables, it primarily provides metadata about the feed itself.

---

# 9. Routes Table

The `routes` table represents the metro routes.

```text
routes
├── route_id
├── agency_id
├── route_short_name
├── route_long_name
├── route_type
└── ...
```

### Purpose

This table is one of the central entities in the database.

It connects agency information with scheduled trips and provides route-level information for network and operational analysis.

A major relationship is:

```text
agency
   │
   └── routes
```

---

# 10. Shapes Table

The `shapes` table represents the geographic path associated with a route or trip pattern.

Typical fields include:

```text
shapes
├── shape_id
├── shape_pt_lat
├── shape_pt_lon
├── shape_pt_sequence
└── ...
```

### Purpose

The table stores geographic points that can be used to reconstruct the physical path represented by a transit shape.

The sequence field determines the order of the geographic points.

Conceptually:

```text
Shape
  ↓
Point 1
  ↓
Point 2
  ↓
Point 3
  ↓
Point 4
```

---

# 11. Stops Table

The `stops` table represents stations or stops within the transit network.

Typical attributes include:

```text
stops
├── stop_id
├── stop_name
├── stop_lat
├── stop_lon
└── ...
```

### Purpose

The table provides the master information for individual stops.

The `stop_id` is an important identifier because it is referenced by `stop_times`.

The table can therefore support station-level analysis.

---

# 12. Stop Times Table

The `stop_times` table represents the scheduled arrival and departure of trips at individual stops.

Typical fields include:

```text
stop_times
├── trip_id
├── arrival_time
├── departure_time
├── stop_id
├── stop_sequence
└── ...
```

### Purpose

This is one of the most important operational tables because it connects:

```text
Trip
  ↓
Stop Time
  ↓
Stop
```

The table allows analysis of scheduled movement through the station network.

The `stop_sequence` field provides the order in which stops are visited during a trip.

---

# 13. Trips Table

The `trips` table represents individual scheduled trips.

Typical fields include:

```text
trips
├── route_id
├── service_id
├── trip_id
├── trip_headsign
├── direction_id
├── block_id
├── shape_id
└── ...
```

### Purpose

The table connects routes, services, trips, and geographic shapes.

Important relationships include:

```text
routes
   ↓
trips
```

```text
calendar
   ↓
trips
```

```text
shapes
   ↓
trips
```

The `trip_id` then connects each trip to its scheduled stop timings.

---

# 14. Core Database Relationships

The major relationships in the database can be represented as:

```text
                         ┌──────────────┐
                         │    AGENCY    │
                         └──────┬───────┘
                                │
                                │ agency_id
                                ▼
                         ┌──────────────┐
                         │    ROUTES    │
                         └──────┬───────┘
                                │
                                │ route_id
                                ▼
                         ┌──────────────┐
                         │    TRIPS     │
                         └──────┬───────┘
                                │
                 ┌──────────────┼──────────────┐
                 │              │              │
                 │ trip_id      │ service_id   │ shape_id
                 ▼              ▼              ▼
          ┌────────────┐ ┌────────────┐ ┌────────────┐
          │ STOP_TIMES │ │  CALENDAR  │ │   SHAPES   │
          └──────┬─────┘ └────────────┘ └────────────┘
                 │
                 │ stop_id
                 ▼
          ┌────────────┐
          │   STOPS    │
          └────────────┘
```

The fare system operates as a separate but related analytical area:

```text
┌─────────────────────┐
│ FARE_ATTRIBUTES     │
│                     │
│ fare_id             │
│ price               │
│ currency_type       │
│ ...                 │
└──────────┬──────────┘
           │
           │ fare_id
           ▼
┌─────────────────────┐
│ FARE_RULES          │
│                     │
│ fare_id             │
│ origin_id           │
│ destination_id      │
└─────────────────────┘
```

---

# 15. Primary Keys

Primary keys uniquely identify records within a table.

Important identifiers include:

| Table             | Main Identifier                                |
| ----------------- | ---------------------------------------------- |
| `agency`          | `agency_id`                                    |
| `calendar`        | `service_id`                                   |
| `fare_attributes` | `fare_id`                                      |
| `fare_rules`      | Based on the available fare-rule key structure |
| `feed_info`       | Feed-level metadata                            |
| `routes`          | `route_id`                                     |
| `shapes`          | Composite/sequence-based shape records         |
| `stops`           | `stop_id`                                      |
| `trips`           | `trip_id`                                      |
| `stop_times`      | Trip/stop sequence combination                 |

The exact primary-key definition should follow the actual cleaned dataset structure and the uniqueness characteristics identified during validation.

---

# 16. Foreign Keys

Foreign keys establish relationships between tables.

Important relationships include:

```text
routes.agency_id
       ↓
agency.agency_id
```

```text
trips.route_id
       ↓
routes.route_id
```

```text
trips.service_id
       ↓
calendar.service_id
```

```text
trips.shape_id
       ↓
shapes.shape_id
```

```text
stop_times.trip_id
       ↓
trips.trip_id
```

```text
stop_times.stop_id
       ↓
stops.stop_id
```

```text
fare_rules.fare_id
       ↓
fare_attributes.fare_id
```

These relationships allow SQL joins to combine information from different parts of the database.

---

# 17. Referential Integrity

Referential integrity ensures that relationship identifiers remain valid.

For example, a `stop_times.trip_id` should correspond to an existing `trips.trip_id`.

Conceptually:

```text
Parent Table
     │
     │ Primary Key
     ▼
Child Table
     │
     │ Foreign Key
     ▼
Valid Relationship
```

Relationship validation is therefore performed after data loading.

This helps identify orphan records and invalid relationships before business analysis begins.

---

# 18. Constraints

Database constraints are used to protect data quality.

The database can use constraints such as:

### PRIMARY KEY

Ensures that records have a unique identifier.

### FOREIGN KEY

Maintains relationships between tables.

### NOT NULL

Used for fields that are required for correct operation or analysis.

### UNIQUE

Used where a value must remain unique.

### CHECK

Can be used where appropriate to enforce valid value conditions.

Constraints should be applied according to the actual characteristics of the source data rather than being added arbitrarily.

---

# 19. Indexing Strategy

Indexes are used to improve query performance.

The most important candidates are fields frequently used for:

* Joins
* Filtering
* Grouping
* Sorting
* Foreign-key relationships

Examples include:

```text
route_id
trip_id
stop_id
service_id
shape_id
fare_id
origin_id
destination_id
```

Indexing should be balanced against storage and write overhead.

The purpose is to improve performance for the analytical queries used by the project.

---

# 20. Normalization Approach

The database follows a relational structure in which different types of information are stored in separate tables.

For example:

```text
Agency Information
       ≠
Route Information
       ≠
Trip Information
       ≠
Stop Information
```

Rather than repeating agency or station information across thousands of trip records, identifiers are used to connect the entities.

This reduces unnecessary duplication and makes the database easier to maintain.

---

# 21. Database Creation Sequence

The database should be constructed in a controlled order.

```text
01_create_database.sql
          ↓
02_create_tables.sql
          ↓
03_constraints.sql
          ↓
04_indexes.sql
          ↓
05_load_data.sql
```

This sequence ensures that the database structure exists before data is loaded and that relationships and performance structures can be applied systematically.

---

# 22. Relationship Validation After Loading

Creating foreign keys does not replace data validation.

After loading the data, the project performs relationship checks.

The validation process examines relationships such as:

```text
Routes → Trips
Calendar → Trips
Trips → Stop Times
Stops → Stop Times
Trips → Shapes
Fare Attributes → Fare Rules
```

The purpose is to confirm that the loaded database reflects the expected relationships.

---

# 23. Database Design for Analysis

The database is designed specifically to support analytical queries.

For example, a route-level analysis may require:

```text
routes
   ↓
trips
   ↓
stop_times
   ↓
stops
```

A service-level analysis may require:

```text
calendar
   ↓
trips
   ↓
routes
```

A fare analysis may require:

```text
fare_attributes
   ↓
fare_rules
   ↓
origin / destination information
```

This relational structure makes complex multi-table analysis possible using SQL.

---

# 24. Analytical Layer

After the core database has been validated, analytical views can be created.

Examples include:

```text
vw_route_summary
vw_station_summary
vw_trip_summary
vw_service_summary
vw_fare_summary
```

These views provide simplified analytical structures on top of the normalized database.

Conceptually:

```text
Normalized Database
        ↓
Complex SQL Joins
        ↓
Aggregations
        ↓
Analytical Views
        ↓
Business Analysis
```

---

# 25. Design Considerations

Several design decisions are important for this project.

### GTFS identifiers are preserved

Identifiers such as `route_id`, `trip_id`, `stop_id`, and `service_id` are retained because they form the relationships between datasets.

### Fare rules are modeled according to available fields

The fare-rule table uses the available origin and destination identifiers rather than assuming the existence of a `route_id`.

### Schedule data is treated as schedule data

Scheduled trips and stop times should not automatically be interpreted as actual passenger usage.

### Source limitations are preserved

The database represents what is available in the source datasets. Missing business dimensions cannot be generated through database design alone.

---

# 26. Database Design Workflow

The complete design process can be summarized as:

```text
GTFS Files
    ↓
Identify Entities
    ↓
Define Tables
    ↓
Define Columns
    ↓
Identify Primary Keys
    ↓
Identify Foreign Keys
    ↓
Normalize Structure
    ↓
Apply Constraints
    ↓
Create Indexes
    ↓
Load Data
    ↓
Validate Relationships
    ↓
Create Analytical Views
    ↓
Perform SQL Analysis
```

---

# 27. Expected Database Outcome

The final MySQL database should provide:

* Clearly separated relational tables
* Consistent identifiers
* Appropriate primary keys
* Appropriate foreign keys
* Referential integrity
* Suitable indexes
* Structured transit data
* Reliable relationships for SQL joins
* A foundation for advanced analytical queries

The database becomes the central foundation for the entire Hyderabad Metro analysis project.

---

# 28. Summary

The Hyderabad Metro database design transforms the cleaned GTFS datasets into a structured relational model.

The design separates major transit entities while connecting them through identifiers and relationships:

```text
Agency
  ↓
Routes
  ↓
Trips
  ↓
Stop Times
  ↓
Stops
```

alongside:

```text
Calendar
  ↓
Trips
```

```text
Trips
  ↓
Shapes
```

and:

```text
Fare Attributes
  ↓
Fare Rules
```

This structure enables the project to move from raw transportation data to a validated relational database and ultimately to SQL-based business analysis.

The database is therefore not simply a collection of imported tables. It is the **central analytical foundation** connecting data preparation, validation, SQL querying, business questions, findings, recommendations, and final reporting.
