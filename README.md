# Hyderabad Metro — MySQL Data Analytics Project

## 📌 Project Overview

The **Hyderabad Metro MySQL Data Analytics Project** is an end-to-end SQL project designed to transform Hyderabad Metro GTFS-style transit data into a structured relational database and use **MySQL** to perform data validation, network analysis, scheduled-service analysis, fare analysis, and business-oriented investigation.

The project uses **10 source datasets** covering agency information, service calendars, routes, trips, stations, stop timings, geographic shapes, and fare relationships. These datasets are transformed into a relational MySQL database and analyzed through progressively advanced SQL techniques.

The primary objective is to demonstrate how raw transportation data can be transformed into **validated, structured, queryable, and business-relevant insights using SQL**.

> **Project focus:** Scheduled metro service and network analysis.
> **Important limitation:** The available dataset does not contain passenger ridership, revenue, train capacity, delays, or real-time operational data. Therefore, the analysis focuses on scheduled service characteristics rather than actual passenger demand or operational performance.

---

## 🎯 Project Objectives

This project aims to:

* Build a structured MySQL database from raw GTFS-style datasets.
* Design relationships between 10 related transportation tables.
* Apply primary keys, foreign keys, constraints, and indexes.
* Load cleaned datasets into MySQL.
* Validate the quality and integrity of the loaded data.
* Analyze Hyderabad Metro routes, stations, trips, schedules, and fares.
* Practice SQL from basic queries to advanced analytical techniques.
* Create reusable SQL views for recurring analysis.
* Translate SQL results into meaningful findings and recommendations.
* Demonstrate an end-to-end data analytics workflow suitable for a SQL portfolio.

---

## 🗂️ Dataset

The project is based on the following 10 source files:

|  # | Source File           | MySQL Table       | Purpose                                           |
| -: | --------------------- | ----------------- | ------------------------------------------------- |
|  1 | `agency.txt`          | `agency`          | Metro agency/operator information                 |
|  2 | `calendar.txt`        | `calendar`        | Service availability and operating dates          |
|  3 | `fare_attributes.txt` | `fare_attributes` | Fare amounts and payment information              |
|  4 | `fare_rules.txt`      | `fare_rules`      | Origin-destination fare relationships             |
|  5 | `feed_info.txt`       | `feed_info`       | Dataset/feed metadata                             |
|  6 | `routes.txt`          | `routes`          | Metro route/line information                      |
|  7 | `shapes.txt`          | `shapes`          | Geographic route-path information                 |
|  8 | `stop_times.txt`      | `stop_times`      | Scheduled arrival and departure times             |
|  9 | `stops.txt`           | `stops`           | Station, platform, location, and zone information |
| 10 | `trips.txt`           | `trips`           | Individual scheduled trips                        |

These tables represent five major areas of the transportation dataset:

```text
Agency & Feed
    ├── agency
    └── feed_info

Service & Scheduling
    ├── calendar
    ├── trips
    └── stop_times

Network
    ├── routes
    ├── stops
    └── shapes

Fare
    ├── fare_attributes
    └── fare_rules
```

The project table dictionary documents these tables, their purposes, primary keys, and relationships.

---

## 🔄 Data-to-Insight Workflow

The complete project follows this analytical pipeline:

```text
RAW GTFS DATA
      ↓
DATA CLEANING & TRANSFORMATION
      ↓
PROCESSED DATA
      ↓
MYSQL DATABASE
      ↓
SCHEMA & RELATIONSHIPS
      ↓
DATA LOADING
      ↓
DATA VALIDATION
      ↓
SQL ANALYSIS
      ↓
BUSINESS ANALYSIS
      ↓
ANALYTICAL VIEWS
      ↓
FINDINGS
      ↓
RECOMMENDATIONS
      ↓
FINAL REPORT
```

---

## 🗄️ Database Architecture

The MySQL database contains 10 relational tables connected through primary-key and foreign-key relationships.

### Core Relationships

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

Important relationships include:

```text
routes → trips
trips → stop_times
stops → stop_times
calendar → trips
fare_attributes → fare_rules
```

The `stops` table also contains a station/platform hierarchy through the `parent_station` relationship.

---

## 🔑 Database Design

The project uses appropriate primary keys for the major entities.

| Table             | Primary Key                          |
| ----------------- | ------------------------------------ |
| `agency`          | `agency_id`                          |
| `calendar`        | `service_id`                         |
| `fare_attributes` | `fare_id`                            |
| `fare_rules`      | `origin_id, destination_id, fare_id` |
| `feed_info`       | No explicit source primary key       |
| `routes`          | `route_id`                           |
| `shapes`          | `shape_id, shape_pt_sequence`        |
| `stop_times`      | `trip_id, stop_sequence`             |
| `stops`           | `stop_id`                            |
| `trips`           | `trip_id`                            |

Recommended foreign-key relationships are documented in the project's database dictionary.

---

## 🧪 Data Validation Framework

Before performing business analysis, the database goes through a six-stage validation process:

```text
01. Row Count Validation
          ↓
02. Table Structure Validation
          ↓
03. Data Inspection
          ↓
04. Duplicate Validation
          ↓
05. NULL Validation
          ↓
06. Relationship Validation
```

This ensures that the loaded data is structurally consistent and suitable for downstream SQL analysis.

The validation framework is intended to be repeatable whenever the source data is reloaded or updated.

---

## 📊 SQL Analysis Roadmap

The SQL analysis is organized from fundamental concepts to advanced analytical techniques.

### 1. Basic SQL

* `SELECT`
* `WHERE`
* `ORDER BY`
* Filtering
* Sorting

### 2. SQL Joins

* `INNER JOIN`
* `LEFT JOIN`
* Multi-table joins
* Self joins

### 3. Aggregation

* `COUNT()`
* `SUM()`
* `AVG()`
* `MIN()`
* `MAX()`
* `GROUP BY`
* `HAVING`

### 4. Subqueries

* Scalar subqueries
* Nested queries
* Correlated subqueries

### 5. Common Table Expressions

* Route analysis
* Station analysis
* Service analysis
* Multi-stage analytical queries

### 6. Window Functions

* Ranking
* Partitioning
* Route comparison
* Running totals
* Analytical calculations

---

## 🔎 Business Analysis

The project goes beyond SQL syntax practice by applying SQL to transportation-related business questions.

### Network Analysis

* How many routes operate in the network?
* How many stations are represented?
* Which stations are connected to multiple routes?
* How is the network structured?

### Route Analysis

* Which routes have the highest scheduled trip volume?
* How many stops are associated with each route?
* How does scheduled service vary between routes?
* Which routes require deeper analysis?

### Station Analysis

* Which stations have the highest scheduled service representation?
* Which stations are associated with multiple routes?
* How does station service coverage differ?

### Trip Analysis

* How are trips distributed across routes?
* What are the scheduled start and end times?
* Are there unusual trip patterns?
* How are stops sequenced within trips?

### Service Analysis

* Which days have scheduled service?
* How do weekday and weekend service patterns differ?
* How are service IDs connected to trips and routes?

### Fare Analysis

* What fare structures are represented?
* How are origin-destination relationships mapped to fares?
* Are there potential fare-rule coverage gaps?

### Operational Schedule Analysis

Suggested KPIs include:

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

These KPIs can be implemented through reusable MySQL views.

---

## 👁️ Analytical Views

The project includes reusable SQL views for frequently required analysis:

```text
vw_route_summary
vw_station_summary
vw_trip_summary
vw_service_summary
vw_fare_summary
```

Views provide a consistent analytical layer and reduce the need to repeatedly write complex SQL logic.

---

## 📁 Repository Structure

```text
hyderabad-metro-mysql/
│
├── README.md
│
├── data/
│   ├── raw/
│   └── processed/
│
├── database/
│   ├── 01_create_database.sql
│   ├── 02_create_tables.sql
│   └── 03_load_data.sql
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
├── analysis/
│   ├── business_questions.md
│   ├── findings.md
│   └── recommendations.md
│
├── documentation/
│   ├── project_overview.md
│   ├── data_cleaning.md
│   ├── database_design.md
│   ├── relationships.md
│   └── sql_concepts_used.md
│
├── screenshots/
│   ├── database.png
│   ├── er_diagram.png
│   ├── mysql_workbench/
│   └── query_results/
│
└── reports/
    ├── project_report.md
    └── executive_summary.md
```

The repository structure separates **data, database implementation, schema documentation, validation, SQL analysis, business analysis, and reporting**, making the project easier to understand and maintain.

---

## 🛠️ Technologies Used

* **MySQL**
* **SQL**
* **MySQL Workbench**
* **Git**
* **GitHub**
* GTFS-style transit datasets

### SQL Concepts

```text
DDL
DML
DQL
Primary Keys
Foreign Keys
Constraints
Indexes
Joins
Aggregations
Subqueries
CTEs
Window Functions
Views
Data Validation
Business Analysis
```

---

## 🚀 How to Run the Project

### Step 1 — Clone the Repository

```bash
git clone https://github.com/your-username/hyderabad-metro-mysql.git
```

### Step 2 — Open MySQL Workbench

Connect to your MySQL server.

### Step 3 — Create the Database

Run:

```text
database/01_create_database.sql
```

### Step 4 — Create Tables

Run:

```text
database/02_create_tables.sql
```

### Step 5 — Apply Constraints

Run:

```text
database/03_constraints.sql
```

### Step 6 — Create Indexes

Run:

```text
database/04_indexes.sql
```

### Step 7 — Load the Data

Run:

```text
database/05_load_data.sql
```

### Step 8 — Validate the Database

Run the validation scripts in order:

```text
queries/00_data_validation/

01_row_count_validation.sql
02_table_structure.sql
03_data_inspection.sql
04_duplicate_validation.sql
05_null_validation.sql
06_relationship_validation.sql
```

### Step 9 — Perform SQL Analysis

Continue through:

```text
01_basic_queries
        ↓
02_joins
        ↓
03_aggregations
        ↓
04_subqueries
        ↓
05_cte
        ↓
06_window_functions
        ↓
07_business_analysis
```

### Step 10 — Generate Findings

Document analytical results in:

```text
analysis/findings.md
```

### Step 11 — Develop Recommendations

Document data-informed recommendations in:

```text
analysis/recommendations.md
```

The project's recommendations are intended as **data-informed suggestions**, not definitive operational decisions.

---

## 📈 Key Analytical Principles

This project follows five important principles:

### 1. Evidence-Based

Recommendations should originate from measurable SQL findings.

### 2. Data-Aware

Conclusions should not exceed what the available dataset can support.

### 3. Operationally Relevant

Analysis should focus on network, routes, stations, schedules, trips, fares, and related transportation characteristics.

### 4. Clearly Qualified

The project distinguishes between:

```text
What the data proves
        ↓
What the data suggests
        ↓
What requires additional data
```

### 5. Reproducible

Major recommendations should be traceable through:

```text
Business Question
       ↓
SQL Query
       ↓
SQL Result
       ↓
Finding
       ↓
Recommendation
```

This traceability framework is part of the project's analytical methodology.

---

## ⚠️ Data Limitations

The current dataset primarily represents **scheduled transit service**.

It does not provide:

* Passenger ridership
* Passenger demand
* Train capacity
* Actual arrival/departure performance
* Delays
* Cancellations
* Ticket sales
* Revenue
* Passenger demographics
* Historical fare changes

Therefore:

```text
Scheduled Trips ≠ Passenger Demand
```

For example, a route with more scheduled trips cannot automatically be described as the route with the highest passenger demand.

Additional datasets would be required for demand, financial, capacity, and real-time operational analysis.

---

## 🔮 Future Enhancements

The project can be expanded by integrating additional datasets.

### Passenger Analytics

```text
Passenger Entries
Passenger Exits
Station Ridership
Peak-Hour Demand
```

### Operational Analytics

```text
Actual Arrival Times
Actual Departure Times
Delays
Cancellations
Headways
```

### Financial Analytics

```text
Ticket Sales
Revenue
Fare Collection
Revenue by Route
Revenue by Station
```

### Capacity Analytics

```text
Train Capacity
Number of Coaches
Train Frequency
Platform Capacity
```

This would allow the project to evolve from **scheduled network analysis** into a broader **metro demand, performance, and revenue analytics platform**.

---

## 📚 Project Learning Outcomes

This project demonstrates practical experience in:

* Relational database design
* MySQL database creation
* Data loading
* Data-quality validation
* Primary and foreign keys
* Constraints and indexes
* SQL joins
* Aggregation
* Subqueries
* CTEs
* Window functions
* Analytical views
* Transportation data analysis
* Business-question formulation
* Data-driven findings
* Data-informed recommendations
* GitHub project organization

---

## 👤 Author

**Santan Perumalla**

Aspiring Data Analyst

### Skills Demonstrated

```text
SQL
MySQL
Data Analysis
Database Design
Data Validation
Business Analysis
Git & GitHub
```

---

## ⭐ Project Objective in One Line

> **Transform Hyderabad Metro GTFS-style data into a structured MySQL database, validate its integrity, analyze scheduled network and service patterns, and translate SQL results into reproducible business insights.**

---

## 📌 Project Status

```text
Raw Data                    ✅ Completed
Data Processing             ✅ Completed
Database Creation           ✅ Completed
Table Creation              ✅ Completed
Data Loading                ✅ Completed
Schema Documentation        ✅ Completed
Data Validation             ✅ Completed
SQL Analysis                ✅ Completed
Business Analysis           ✅ Completed
Analytical Views            ✅ Completed
Findings                    ✅ Completed
Recommendations             ✅ Completed
Final Report                ✅ Completed
```

### 🏆 Status: Completed

The **Hyderabad Metro MySQL Data Analytics Project** has been successfully completed from **raw data preparation through database development, validation, advanced SQL analysis, business analysis, findings, recommendations, and final reporting**.

The completed project demonstrates an end-to-end SQL analytics workflow:

```text
Raw Data
    ↓
Data Cleaning & Transformation
    ↓
MySQL Database
    ↓
Schema & Relationships
    ↓
Data Validation
    ↓
SQL Analysis
    ↓
Advanced SQL
    ↓
Business Analysis
    ↓
Analytical Views
    ↓
Findings
    ↓
Recommendations
    ↓
Final Report
```

**Project Status: 🟢 COMPLETE**
