# Hyderabad Metro — Business Questions

## Overview

This document defines the key business questions for the Hyderabad Metro SQL analysis project.

The objective is to transform the available Hyderabad Metro GTFS data into meaningful business and operational insights using MySQL. The analysis focuses on the structure of the metro network, routes, stations, scheduled trips, service patterns, fares, and operational characteristics.

The business questions are organized into seven analytical areas:

1. Network Analysis
2. Route Performance
3. Station Analysis
4. Trip Analysis
5. Service Analysis
6. Fare Analysis
7. Operational Analysis

The SQL queries developed under `queries/07_business_analysis/` will answer these questions using joins, aggregations, subqueries, CTEs, window functions, and other SQL techniques.

---

## 1. Network Analysis

### Objective

Understand the overall structure and composition of the Hyderabad Metro network.

### Business Questions

* How many metro routes are available in the dataset?
* How many stations/stops are included in the network?
* How many trips are scheduled across the network?
* How many shapes and route patterns are represented?
* Which routes operate between the major origin and destination areas?
* How are routes distributed across the metro network?
* Which routes contain the highest number of stops?
* Which routes have the largest number of scheduled trips?

### Business Value

Network analysis provides a high-level view of the metro system and establishes the foundation for more detailed route, station, trip, and service analysis.

---

## 2. Route Performance Analysis

### Objective

Compare metro routes based on their scheduled service characteristics.

### Business Questions

* Which routes have the highest number of scheduled trips?
* Which routes serve the largest number of stops?
* Which routes have the longest scheduled journeys based on stop sequences?
* How many trips are associated with each route?
* Which routes have the highest service frequency?
* How does the number of stops vary between routes?
* Which routes have the greatest number of trip patterns?
* Which routes appear to have broader network coverage based on the available schedule data?

### Business Value

Route-level analysis helps identify differences in scheduled service coverage and operational structure across the metro network.

> **Important:** Scheduled trip volume should not be interpreted as actual passenger demand because the available GTFS dataset does not contain passenger ridership data.

---

## 3. Station Analysis

### Objective

Analyze station-level characteristics and identify important stations within the scheduled network.

### Business Questions

* How many stations are present in the network?
* Which stations are served by the highest number of trips?
* Which stations are associated with the largest number of routes?
* Which stations appear in the greatest number of trip schedules?
* Which stations function as common points between multiple routes?
* Which stations have the highest number of scheduled arrivals and departures?
* Which stations have the greatest connectivity within the available route structure?

### Business Value

Station analysis helps identify strategically important locations based on scheduled service coverage and network connectivity.

---

## 4. Trip Analysis

### Objective

Understand the characteristics and distribution of scheduled metro trips.

### Business Questions

* How many trips are scheduled for each route?
* How are trips distributed across different service patterns?
* Which routes have the highest number of trips?
* What are the earliest and latest scheduled trip times?
* How many stops are included in individual trips?
* Which trips contain the highest number of stops?
* How does scheduled trip structure differ between routes?
* Which trips represent the longest stop sequences?

### Business Value

Trip analysis provides insight into how scheduled services are organized throughout the network.

---

## 5. Service Analysis

### Objective

Analyze the relationship between scheduled trips and service-calendar information.

### Business Questions

* Which service IDs are associated with the greatest number of trips?
* On which days of the week is service scheduled?
* Which services operate across the widest range of days?
* Which routes are associated with particular service patterns?
* How many trips operate under each service pattern?
* Which services have the largest scheduled coverage?
* How does weekday service differ from weekend service based on the calendar data?

### Business Value

Service analysis helps understand how the metro timetable is structured across different operating days and service patterns.

---

## 6. Fare Analysis

### Objective

Analyze the fare structure and relationships defined in the available fare data.

### Business Questions

* What fare products are available in the dataset?
* What are the different fare attributes and prices?
* Which origin-destination combinations have fare rules defined?
* What are the minimum and maximum fares represented in the dataset?
* How do fares vary across defined origin-destination combinations?
* Which origin-destination combinations have the highest fare?
* Which origin-destination combinations have the lowest fare?
* How many origin-destination combinations are associated with each fare?
* Are there origin or destination areas with multiple fare-rule relationships?

### Business Value

Fare analysis helps understand the pricing structure represented in the GTFS fare data and the relationships between fare products and origin-destination combinations.

> **Data constraint:** The `fare_rules` table in this project contains origin and destination identifiers along with the fare identifier. Therefore, fare analysis should be based on these available relationships rather than assuming the presence of a `route_id` in `fare_rules`.

---

## 7. Operational Analysis

### Objective

Evaluate the scheduled operational characteristics of the metro network.

### Business Questions

* Which routes have the highest scheduled service volume?
* Which routes operate across the largest number of stops?
* Which stations have the greatest scheduled service coverage?
* What are the earliest and latest scheduled services?
* How many trips are scheduled for each operating day?
* Which service patterns cover the greatest number of routes?
* Which routes have the greatest variation in scheduled trip patterns?
* What operational patterns can be identified from the available schedule data?

### Business Value

Operational analysis combines information from routes, trips, stops, stop times, and calendar data to provide a broader view of the scheduled metro operation.

---

# Analytical Approach

The business questions will be answered progressively using SQL.

The analysis will make use of:

* `SELECT`
* `WHERE`
* `GROUP BY`
* `HAVING`
* `ORDER BY`
* Aggregate functions
* `INNER JOIN`
* `LEFT JOIN`
* Multi-table joins
* Subqueries
* Common Table Expressions (CTEs)
* Window functions
* Conditional expressions
* Date and time functions

The purpose is not only to obtain results but also to demonstrate practical SQL problem-solving skills.

---

# Data Sources

The analysis is based on the following GTFS tables:

| Table             | Primary Analytical Purpose                                |
| ----------------- | --------------------------------------------------------- |
| `agency`          | Metro agency information                                  |
| `calendar`        | Service operating days and dates                          |
| `fare_attributes` | Fare product and pricing information                      |
| `fare_rules`      | Origin-destination fare relationships                     |
| `feed_info`       | Dataset/feed metadata                                     |
| `routes`          | Route information                                         |
| `shapes`          | Geographic route shapes                                   |
| `stop_times`      | Scheduled arrival/departure and stop sequence information |
| `stops`           | Station/stop information                                  |
| `trips`           | Scheduled trip information                                |

---

# Important Analytical Limitations

The analysis must remain within the scope of the available data.

The dataset primarily represents **GTFS schedule and network information**. Therefore, the project can analyze scheduled operations and network structure but cannot directly measure:

* Actual passenger demand
* Passenger volume
* Revenue generated
* Actual train occupancy
* Customer satisfaction
* Delays or punctuality
* Real-time train performance

unless additional datasets containing those metrics are introduced.

Consequently, terms such as **"performance," "service volume," and "coverage"** refer to characteristics observable from the available scheduled data and should not be interpreted as actual passenger or financial performance.

---

# Expected Outcome

The final business analysis should convert raw GTFS data into a collection of measurable insights about the Hyderabad Metro network.

The analytical flow is:

```text
GTFS Data
    ↓
Validated MySQL Database
    ↓
SQL Analysis
    ↓
Business Questions
    ↓
Quantitative Results
    ↓
Business Findings
    ↓
Recommendations
```

The results generated from these business questions will be documented in:

* `analysis/findings.md`
* `analysis/recommendations.md`

The corresponding SQL implementations will be stored in:

```text
queries/
└── 07_business_analysis/
    ├── 01_network_analysis.sql
    ├── 02_route_performance.sql
    ├── 03_station_analysis.sql
    ├── 04_trip_analysis.sql
    ├── 05_service_analysis.sql
    ├── 06_fare_analysis.sql
    └── 07_operational_analysis.sql
```

This separation keeps the project structured:

**Business question → SQL query → Result → Finding → Recommendation**
