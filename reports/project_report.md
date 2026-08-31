# Hyderabad Metro Transit Analytics — MySQL Data Analysis Project Report

## 1. Project Overview

The **Hyderabad Metro MySQL Data Analysis Project** is a relational database and SQL analytics project developed to organize, validate, and analyze Hyderabad Metro scheduled transportation data.

The project uses **GTFS (General Transit Feed Specification) data** containing information about the metro agency, service calendar, routes, trips, stops, stop sequences, route shapes, and fare relationships.

The objective is to transform raw transportation datasets into a structured **MySQL relational database** and use SQL to perform progressively advanced analysis.

The project follows a complete data-to-insight workflow:

```text
Raw GTFS Data
      ↓
Data Cleaning & Transformation
      ↓
Processed Datasets
      ↓
MySQL Database
      ↓
Data Validation
      ↓
SQL Analysis
      ↓
Business Analysis
      ↓
Analytical Views
      ↓
Findings
      ↓
Recommendations
      ↓
Final Project Report
```

The repository is structured to separate raw data, database construction, schema documentation, validation queries, analytical queries, views, findings, recommendations, screenshots, and final reporting.

---

# 2. Project Objectives

The primary objectives of this project are:

* Build a structured relational database using MySQL.
* Convert raw GTFS transportation files into usable datasets.
* Design relationships between transportation entities.
* Load the datasets into normalized relational tables.
* Validate the loaded data systematically.
* Apply SQL from basic to advanced levels.
* Analyze routes, stations, trips, services, fares, and network structure.
* Create reusable analytical SQL views.
* Identify meaningful patterns within scheduled metro services.
* Translate SQL results into data-informed findings and recommendations.
* Demonstrate practical SQL and relational database skills through a real-world transportation dataset.

---

# 3. Dataset Overview

The project is based on GTFS transportation data.

The dataset contains **10 primary source files**:

| File                  | Purpose                                                              |
| --------------------- | -------------------------------------------------------------------- |
| `agency.txt`          | Contains transportation agency information                           |
| `calendar.txt`        | Defines scheduled service operating days                             |
| `fare_attributes.txt` | Contains fare-related attributes                                     |
| `fare_rules.txt`      | Defines relationships between fare products and origins/destinations |
| `feed_info.txt`       | Provides information about the GTFS feed                             |
| `routes.txt`          | Contains route-level information                                     |
| `shapes.txt`          | Represents geographic route shapes                                   |
| `stop_times.txt`      | Contains scheduled arrival/departure times and stop sequences        |
| `stops.txt`           | Contains station/stop information                                    |
| `trips.txt`           | Defines individual scheduled trips                                   |

The agency dataset identifies the agency as **Hyderabad Metro Rail (HMRL)** and uses `Asia/Kolkata` as the agency timezone.

---

# 4. Data Architecture

The project separates the original source data from processed data.

```text
data/
│
├── raw/
│   ├── agency.txt
│   ├── calendar.txt
│   ├── fare_attributes.txt
│   ├── fare_rules.txt
│   ├── feed_info.txt
│   ├── routes.txt
│   ├── shapes.txt
│   ├── stop_times.txt
│   ├── stops.txt
│   └── trips.txt
│
└── processed/
    ├── agency_clean.csv
    ├── calendar_clean.csv
    ├── fare_attributes_clean.csv
    ├── fare_rules_clean.csv
    ├── feed_info_clean.csv
    ├── routes_clean.csv
    ├── shapes_clean.csv
    ├── stop_times_clean.csv
    ├── stops_clean.csv
    └── trips_clean.csv
```

The `raw` layer preserves the original source files, while the `processed` layer contains cleaned datasets prepared for database loading.

This separation improves reproducibility and makes it possible to distinguish between source data and transformed data.

---

# 5. Database Design

The project uses **MySQL** as the relational database management system.

The database is designed around the relationships between transportation agencies, routes, services, trips, stops, stop sequences, geographic shapes, and fares.

The primary conceptual relationships include:

```text
agency
   │
   └── routes
          │
          └── trips
                 │
                 └── stop_times
                        │
                        └── stops

calendar
   │
   └── trips

routes
   │
   └── shapes

fare_attributes
   │
   └── fare_rules
```

These relationships allow the project to move from individual tables to multi-table transportation analysis.

---

# 6. Database Construction Process

The database construction process follows a controlled sequence.

```text
Create Database
      ↓
Create Tables
      ↓
Add Constraints
      ↓
Create Indexes
      ↓
Load Data
```

The database folder contains separate SQL scripts for each stage:

```text
database/
├── 01_create_database.sql
├── 02_create_tables.sql
├── 03_constraints.sql
├── 04_indexes.sql
├── 05_load_data.sql
├── 06_views.sql
├── 07_stored_procedures.sql
├── 08_functions.sql
└── 09_triggers.sql
```

Separating these operations makes the database easier to reproduce, maintain, and troubleshoot.

---

# 7. Data Loading

After the database tables are created, the processed datasets are loaded into MySQL.

The loading stage is handled through:

```text
database/05_load_data.sql
```

The purpose of this stage is to transfer the prepared datasets into their corresponding relational tables.

Data loading should be treated separately from validation.

The logical workflow is:

```text
Processed CSV Files
       ↓
MySQL Tables
       ↓
Row Count Validation
       ↓
Structure Validation
       ↓
Data Inspection
       ↓
Duplicate Validation
       ↓
NULL Validation
       ↓
Relationship Validation
```

This separation ensures that successful loading is not automatically interpreted as successful data quality.

---

# 8. Data Validation Framework

Data validation is an essential stage of the project.

The repository uses a dedicated validation directory:

```text
queries/
└── 00_data_validation/
    ├── 01_row_count_validation.sql
    ├── 02_table_structure.sql
    ├── 03_data_inspection.sql
    ├── 04_duplicate_validation.sql
    ├── 05_null_validation.sql
    └── 06_relationship_validation.sql
```

The validation framework follows six stages.

---

## 8.1 Row Count Validation

The first validation step verifies whether the expected records were successfully loaded into the database.

```text
Source Dataset
      ↓
Expected Row Count
      ↓
MySQL Table
      ↓
Actual Row Count
      ↓
Compare
```

This establishes that the loading process did not unexpectedly omit or duplicate large portions of the source data.

---

## 8.2 Table Structure Validation

The second stage verifies the database structure.

The analysis checks:

* Table names
* Column names
* Data types
* Primary keys
* Foreign keys
* Nullable fields
* Structural consistency

The objective is to ensure that the database schema represents the intended dataset structure.

---

## 8.3 Data Inspection

The third stage examines actual records.

Typical checks include:

* Sample records
* Unexpected values
* Invalid formats
* Date fields
* Time fields
* Identifier values
* Geographic values
* Numeric values

This stage helps identify problems that cannot be detected simply by checking row counts.

---

## 8.4 Duplicate Validation

The fourth stage checks whether identifiers that are expected to be unique contain duplicate values.

Duplicate validation is particularly important for primary-key candidates and GTFS identifiers.

The purpose is to prevent duplicate records from producing incorrect analytical results.

---

## 8.5 NULL Validation

The fifth stage identifies missing values.

NULL analysis should focus particularly on fields required for:

* Identifying records
* Joining tables
* Calculating metrics
* Defining relationships
* Interpreting business logic

Not every NULL value is necessarily an error. The importance of a NULL depends on the role of the column.

---

## 8.6 Relationship Validation

The final validation stage checks relationships between tables.

Important relationships include:

```text
routes → trips
trips → stop_times
stops → stop_times
calendar → trips
fare_attributes → fare_rules
```

These relationships are essential for accurate multi-table SQL analysis.

---

# 9. SQL Analysis Framework

After data validation, the project progresses through multiple levels of SQL analysis.

```text
Basic Queries
      ↓
JOINs
      ↓
Aggregations
      ↓
Subqueries
      ↓
CTEs
      ↓
Window Functions
      ↓
Business Analysis
```

This progression demonstrates both SQL knowledge and practical analytical application.

---

# 10. Basic SQL Analysis

The basic SQL layer establishes fundamental querying capabilities.

Examples include:

* Selecting records
* Filtering data
* Sorting results
* Selecting specific columns
* Applying conditional logic

These queries provide the foundation for more complex analysis.

---

# 11. JOIN Analysis

The project uses relational JOINs to combine information distributed across multiple tables.

Important examples include:

```text
routes + trips
trips + stop_times
stop_times + stops
trips + calendar
fare_rules + fare_attributes
```

JOIN analysis allows the project to answer questions that cannot be answered from a single table.

For example:

> How many scheduled trips are associated with each route?

requires route and trip information to be connected.

---

# 12. Aggregation Analysis

Aggregate functions are used to summarize transportation data.

Common metrics include:

* Number of routes
* Number of stations
* Number of trips
* Number of stops
* Trips per route
* Routes per station
* Operating days
* Fare ranges

Typical SQL functions include:

```text
COUNT()
SUM()
AVG()
MIN()
MAX()
GROUP BY
HAVING
```

---

# 13. Subquery Analysis

Subqueries are used when one query depends on the result of another query.

The project includes:

```text
Scalar Subqueries
Correlated Subqueries
Nested Queries
```

These techniques allow more advanced comparisons and filtering.

---

# 14. Common Table Expressions

CTEs provide a structured way to break complex analysis into logical stages.

The project includes CTE-based analysis for:

* Route analysis
* Station analysis
* Service analysis

CTEs improve readability and make complex analytical queries easier to understand and maintain.

---

# 15. Window Function Analysis

Window functions allow records to be compared within groups without collapsing the result set.

The project includes analysis for:

```text
Ranking
Route Comparison
Running Totals
Partition Analysis
```

Potential applications include ranking routes, comparing services within categories, and calculating sequential analytical metrics.

---

# 16. Business Analysis

The business-analysis layer is the primary analytical component of the project.

It contains:

```text
07_business_analysis/
│
├── 01_network_analysis.sql
├── 02_route_performance.sql
├── 03_station_analysis.sql
├── 04_trip_analysis.sql
├── 05_service_analysis.sql
├── 06_fare_analysis.sql
└── 07_operational_analysis.sql
```

These analyses transform SQL techniques into transportation-related business questions.

---

# 17. Network Analysis

Network analysis focuses on the overall structure of the metro network.

Potential analytical dimensions include:

* Number of routes
* Number of stations
* Routes associated with stations
* Network coverage
* Station connectivity
* Scheduled service distribution

Stations served by multiple routes can be examined as important connectivity points.

However, network structure alone does not provide passenger transfer volumes or passenger demand.

---

# 18. Route Analysis

Route analysis examines scheduled service characteristics at the route level.

Key metrics include:

| Metric              | Purpose                           |
| ------------------- | --------------------------------- |
| Scheduled Trips     | Compare planned service volume    |
| Stops per Route     | Understand route structure        |
| Operating Days      | Understand service calendar       |
| Scheduled Time Span | Understand timetable coverage     |
| Trip Patterns       | Identify unusual service patterns |

Routes with unusually high or low scheduled trip volumes can be selected for deeper investigation.

A high number of scheduled trips should **not** automatically be interpreted as high passenger demand because the current dataset describes scheduled service rather than actual ridership.

---

# 19. Station Analysis

Station analysis focuses on the stop/station structure of the network.

Potential measures include:

* Routes per station
* Scheduled trips associated with stations
* Station service coverage
* Route connectivity
* Stop sequence relationships

Stations associated with multiple routes can be prioritized for future connectivity and transfer analysis.

Additional passenger data would be required to measure actual passenger transfers, congestion, or demand.

---

# 20. Trip Analysis

Trip analysis examines individual scheduled services.

The analysis can investigate:

* Trip stop sequences
* Number of stops per trip
* Earliest scheduled service
* Latest scheduled service
* Different trip patterns
* Scheduled time coverage

The `stop_times` data is particularly useful for understanding the sequence and timing of stops within individual trips.

---

# 21. Service Calendar Analysis

The `calendar` table provides information about the days on which scheduled services operate.

The project can compare:

```text
Monday
Tuesday
Wednesday
Thursday
Friday
Saturday
Sunday
```

This allows analysis of weekday and weekend service patterns.

The relationship:

```text
Calendar
   ↓
Service ID
   ↓
Trip
   ↓
Route
```

is important for accurate timetable analysis.

---

# 22. Fare Analysis

Fare analysis uses the relationship between:

```text
fare_rules
      ↓
fare_attributes
```

The fare-rule structure can be examined using origin, destination, and fare identifiers.

Potential analysis includes:

* Fare relationships
* Origin-destination coverage
* Fare ranges
* Fare-rule consistency
* Fare coverage gaps

However, the available dataset does not contain sufficient information to determine passenger price sensitivity, commercial fare optimization, or revenue performance.

Those analyses would require additional datasets such as ticket sales, passenger journeys, revenue, fare usage, passenger demographics, and historical fare changes.

---

# 23. Operational Analysis

The operational analysis focuses on scheduled service characteristics.

Recommended KPIs include:

| KPI                | Purpose                        |
| ------------------ | ------------------------------ |
| Scheduled Trips    | Compare planned service volume |
| Stops per Route    | Compare route structure        |
| Trips per Route    | Compare service allocation     |
| Routes per Station | Measure network connectivity   |
| Operating Days     | Understand service calendar    |
| Earliest Service   | Identify timetable start       |
| Latest Service     | Identify timetable end         |
| Fare Range         | Understand fare variation      |

These KPIs can be implemented using reusable SQL views.

---

# 24. Analytical Views

The project includes a dedicated `views/` layer.

Recommended views are:

```text
vw_route_summary
vw_station_summary
vw_trip_summary
vw_service_summary
vw_fare_summary
```

Views provide reusable analytical datasets and reduce the need to repeatedly write complex JOIN and aggregation logic.

The views also create a consistent analytical layer for future reporting.

---

# 25. Findings

The project findings should be based strictly on the results produced by the validated SQL queries.

The findings should cover:

### Network

* Network coverage
* Route distribution
* Station connectivity

### Routes

* Scheduled service differences
* Route structure
* Unusual route patterns

### Stations

* Highly connected stations
* Service coverage differences

### Trips

* Stop-sequence patterns
* Scheduled service times
* Early and late services

### Service

* Weekday patterns
* Weekend patterns
* Operating-day differences

### Fares

* Fare relationships
* Fare coverage
* Fare ranges

Findings should distinguish clearly between **observed scheduled-service patterns** and conclusions that would require passenger or operational data.

---

# 26. Recommendations

The recommendations generated from this project are data-informed suggestions rather than definitive operational decisions.

Key recommendation areas include:

## Network

* Review routes and stations with relatively low scheduled service representation.
* Monitor highly connected stations.
* Examine route intersections and transfer opportunities.

## Routes

* Regularly compare scheduled trip volumes.
* Investigate routes with unusually high or low scheduled service.
* Combine schedule information with passenger demand and capacity data in future analysis.

## Stations

* Prioritize multi-route stations for connectivity analysis.
* Compare station-level service coverage.
* Incorporate passenger data for congestion and transfer analysis.

## Trips

* Investigate unusual trip stop sequences.
* Perform detailed time-of-day analysis.
* Compare scheduled coverage across different periods.

## Service Calendar

* Compare weekday and weekend schedules.
* Validate service IDs against trips and calendar definitions.

## Fares

* Review origin-destination fare relationships.
* Investigate potential fare-rule coverage gaps.
* Combine fare information with transaction and revenue data for commercial analysis.

These recommendations align with the project's documented recommendation framework.

---

# 27. Data Quality Recommendations

A repeatable validation process should be maintained whenever source data is reloaded or updated.

The recommended workflow is:

```text
Row Count Validation
        ↓
Structure Validation
        ↓
Data Inspection
        ↓
Duplicate Validation
        ↓
NULL Validation
        ↓
Relationship Validation
```

Reliable business analysis depends on reliable underlying data.

Primary and foreign-key relationships should also be maintained wherever supported by the database model.

---

# 28. Project Limitations

The current dataset primarily describes **scheduled transportation network and service characteristics**.

Therefore, this project cannot independently determine:

* Actual passenger demand
* Passenger satisfaction
* Passenger congestion
* Actual train delays
* Cancellations
* Actual train arrival/departure performance
* Revenue performance
* Fare profitability
* Passenger price sensitivity
* Train capacity utilization

These limitations are important because scheduled service data should not be presented as actual operational or passenger-performance data.

---

# 29. Future Scope

The project can be expanded by integrating additional datasets.

## Passenger Data

Future integration could include:

* Passenger entries
* Passenger exits
* Station-level ridership
* Peak-hour demand

## Operational Data

Additional operational data could include:

* Actual arrival times
* Actual departure times
* Delays
* Cancellations
* Headways

## Financial Data

Future financial analysis could incorporate:

* Ticket sales
* Revenue
* Fare collection
* Revenue by route or station

## Capacity Data

Future analysis could include:

* Train capacity
* Number of coaches
* Train frequency
* Platform capacity

This would allow the project to progress from **scheduled network analysis** toward **demand, performance, capacity, and revenue analysis**.

---

# 30. Recommended Analytical Roadmap

The project can be extended progressively:

```text
GTFS Network Analysis
        ↓
Scheduled Service Analysis
        ↓
Route & Station Analysis
        ↓
Fare Analysis
        ↓
Operational Schedule Analysis
        ↓
Passenger Data Integration
        ↓
Demand Analysis
        ↓
Real-Time Operational Data
        ↓
Performance Analysis
        ↓
Financial Data Integration
        ↓
Revenue Analysis
```

This roadmap allows additional analytical capabilities to be added without replacing the existing relational database foundation.

---

# 31. Repository Structure

The final repository separates each component of the project:

```text
hyderabad-metro-mysql/
│
├── README.md
├── LICENSE
├── .gitignore
│
├── data/
│   ├── raw/
│   └── processed/
│
├── database/
│   ├── 01_create_database.sql
│   ├── 02_create_tables.sql
│   ├── 03_constraints.sql
│   ├── 04_indexes.sql
│   ├── 05_load_data.sql
│   ├── 06_views.sql
│   ├── 07_stored_procedures.sql
│   ├── 08_functions.sql
│   └── 09_triggers.sql
│
├── schema/
│   ├── database_schema.sql
│   ├── er_diagram.png
│   └── table_dictionary.md
│
├── queries/
│   ├── 00_data_validation/
│   ├── 01_basic_queries/
│   ├── 02_joins/
│   ├── 03_aggregations/
│   ├── 04_subqueries/
│   ├── 05_cte/
│   ├── 06_window_functions/
│   └── 07_business_analysis/
│
├── views/
├── analysis/
├── documentation/
├── screenshots/
│
└── reports/
    ├── project_report.md
    └── executive_summary.md
```

This structure separates **data, database engineering, validation, SQL analysis, documentation, and reporting**, making the project easier to understand and reproduce.

---

# 32. SQL Concepts Demonstrated

The project demonstrates a progression from relational database fundamentals to advanced SQL analytics.

### Database Development

* Database creation
* Table creation
* Primary keys
* Foreign keys
* Constraints
* Indexes
* Data loading

### Querying

* SELECT
* WHERE
* ORDER BY
* GROUP BY
* HAVING

### Relational Analysis

* INNER JOIN
* LEFT JOIN
* Multi-table JOINs
* Self JOINs

### Advanced SQL

* Aggregate functions
* Subqueries
* Correlated subqueries
* Common Table Expressions
* Window functions
* Views

### Data Quality

* Row-count validation
* Structure validation
* Duplicate detection
* NULL analysis
* Relationship validation

---

# 33. Key Project Outcome

The main outcome of this project is a structured **MySQL-based analytical environment for Hyderabad Metro GTFS data**.

The project demonstrates the complete process of:

```text
Raw Data
   ↓
Data Preparation
   ↓
Relational Database Design
   ↓
Data Loading
   ↓
Data Validation
   ↓
SQL Querying
   ↓
Advanced SQL Analysis
   ↓
Business Questions
   ↓
Findings
   ↓
Recommendations
```

Rather than treating SQL as a collection of isolated queries, the project demonstrates how SQL can be used as an end-to-end analytical tool.

---

# 34. Conclusion

The Hyderabad Metro MySQL project provides a structured approach to analyzing scheduled transportation data using relational database technologies.

The project establishes a foundation for:

* Reliable data storage
* Structured relational modeling
* Data-quality validation
* Multi-table analysis
* Advanced SQL querying
* Reusable analytical views
* Transportation network analysis
* Scheduled service analysis
* Fare analysis
* Data-informed recommendations

The current project should be interpreted primarily as a **GTFS-based scheduled network and service analysis project**.

The addition of passenger, operational, financial, and capacity datasets would enable the project to evolve into a broader transportation analytics platform capable of analyzing actual demand, operational performance, capacity utilization, and revenue.

---

## Project Status

| Component                | Status                |
| ------------------------ | --------------------- |
| Raw GTFS Data            | Completed             |
| Processed Datasets       | Completed             |
| MySQL Database           | Completed             |
| Table Creation           | Completed             |
| Data Loading             | Completed             |
| Row Count Validation     | Pending / In Progress |
| Structure Validation     | Pending               |
| Data Inspection          | Pending               |
| Duplicate Validation     | Pending               |
| NULL Validation          | Pending               |
| Relationship Validation  | Pending               |
| Basic SQL Analysis       | Pending               |
| JOIN Analysis            | Pending               |
| Aggregation Analysis     | Pending               |
| Subquery Analysis        | Pending               |
| CTE Analysis             | Pending               |
| Window Function Analysis | Pending               |
| Business Analysis        | Pending               |
| Analytical Views         | Pending               |
| Findings                 | Pending               |
| Recommendations          | Pending               |
| Final Report             | In Progress           |
