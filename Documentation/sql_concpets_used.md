# Hyderabad Metro — SQL Concepts Used

## 1. Overview

The **SQL Concepts Used** document describes the SQL techniques applied throughout the Hyderabad Metro MySQL data-analysis project.

The project progresses from fundamental SQL operations to advanced analytical techniques, demonstrating how SQL can be used for **data validation, relational analysis, aggregation, advanced calculations, and business analysis**.

The overall progression is:

```text
Basic Queries
      ↓
Filtering & Sorting
      ↓
Joins
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
      ↓
Analytical Views
```

---

# 2. SQL Environment

The project uses **MySQL** as the relational database management system.

SQL is used for:

* Data inspection and validation
* Duplicate and NULL-value checks
* Relationship validation
* Multi-table analysis
* Aggregation and calculations
* Business-question analysis
* Analytical views

---

# 3. Basic SQL Queries

Fundamental SQL commands form the foundation of the project.

### SELECT

Used to retrieve data from tables.

```sql
SELECT
    route_id,
    route_short_name
FROM routes;
```

### WHERE

Used to filter records.

```sql
SELECT *
FROM routes
WHERE route_type = 1;
```

### DISTINCT

Used to identify unique values.

```sql
SELECT DISTINCT route_type
FROM routes;
```

### ORDER BY

Used to sort results.

```sql
SELECT *
FROM routes
ORDER BY route_short_name;
```

### LIMIT

Used during data inspection to retrieve a limited number of records.

```sql
SELECT *
FROM stops
LIMIT 10;
```

---

# 4. NULL and Data Validation

SQL is used to identify missing and potentially invalid data.

### NULL Handling

```sql
SELECT *
FROM stops
WHERE stop_name IS NULL;
```

### Duplicate Validation

`GROUP BY` and `HAVING` can be used to identify unexpected duplicate identifiers.

```sql
SELECT
    route_id,
    COUNT(*) AS record_count
FROM routes
GROUP BY route_id
HAVING COUNT(*) > 1;
```

These techniques form part of the project's six-step database validation process.

---

# 5. Aggregate Functions

Aggregate functions summarize multiple records.

The project uses:

```text
COUNT()
SUM()
AVG()
MIN()
MAX()
```

Example:

```sql
SELECT
    route_id,
    COUNT(*) AS trip_count
FROM trips
GROUP BY route_id;
```

These functions support route, station, trip, service, and fare analysis.

---

# 6. GROUP BY and HAVING

`GROUP BY` organizes records into groups for aggregation.

```sql
SELECT
    route_id,
    COUNT(*) AS trip_count
FROM trips
GROUP BY route_id;
```

`HAVING` filters the aggregated results.

```sql
SELECT
    route_id,
    COUNT(*) AS trip_count
FROM trips
GROUP BY route_id
HAVING COUNT(*) > 10;
```

---

# 7. JOINs

JOINs are essential because the project database contains multiple related tables.

### INNER JOIN

Returns records with matching values in both tables.

```sql
SELECT
    r.route_id,
    t.trip_id
FROM routes AS r
JOIN trips AS t
    ON r.route_id = t.route_id;
```

### LEFT JOIN

Returns all records from the left table and matching records from the right table.

It is particularly useful for relationship validation and identifying unmatched records.

```sql
SELECT
    t.trip_id,
    t.route_id
FROM trips AS t
LEFT JOIN routes AS r
    ON t.route_id = r.route_id
WHERE r.route_id IS NULL;
```

### Multi-Table JOINs

The project's main operational relationship can be analyzed through:

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

---

# 8. CASE Expressions

`CASE` provides conditional logic within SQL queries.

```sql
SELECT
    route_id,
    CASE
        WHEN route_type = 1 THEN 'Metro'
        ELSE 'Other'
    END AS route_category
FROM routes;
```

It can be used to create meaningful analytical categories.

---

# 9. Subqueries

Subqueries allow one query to be used inside another.

Example:

```sql
SELECT *
FROM fare_attributes
WHERE price > (
    SELECT AVG(price)
    FROM fare_attributes
);
```

Subqueries are useful when one analytical result is required to filter or compare another result.

---

# 10. Common Table Expressions — CTEs

CTEs use the `WITH` clause to divide complex queries into logical steps.

```sql
WITH route_trips AS (
    SELECT
        route_id,
        COUNT(*) AS trip_count
    FROM trips
    GROUP BY route_id
)
SELECT *
FROM route_trips
WHERE trip_count > 10;
```

CTEs improve readability and are useful for route, station, and service analysis.

---

# 11. Window Functions

Window functions perform calculations across related rows without collapsing them into a single result.

Important functions include:

```text
ROW_NUMBER()
RANK()
DENSE_RANK()
LAG()
LEAD()
SUM() OVER()
AVG() OVER()
```

### Example

```sql
SELECT
    route_id,
    trip_id,
    ROW_NUMBER() OVER (
        PARTITION BY route_id
        ORDER BY trip_id
    ) AS trip_number
FROM trips;
```

Window functions support ranking, comparison, partition-based analysis, and running calculations.

---

# 12. COUNT(DISTINCT)

`COUNT(DISTINCT ...)` is important when joins create multiple rows for the same logical entity.

For example, one trip can have many stop-time records:

```text
Trip
 ↓
Many Stop Times
```

Therefore, when counting unique trips:

```sql
COUNT(DISTINCT trip_id)
```

may be more appropriate than:

```sql
COUNT(trip_id)
```

This helps prevent incorrect analytical results caused by one-to-many relationships.

---

# 13. SQL Views

Views provide reusable analytical queries.

Examples used in the project include:

```text
vw_route_summary
vw_station_summary
vw_trip_summary
vw_service_summary
vw_fare_summary
```

A view can simplify repeated analysis:

```sql
SELECT *
FROM vw_route_summary;
```

Conceptually:

```text
Normalized Database
        ↓
SQL Joins & Calculations
        ↓
Analytical View
        ↓
Business Analysis
```

---

# 14. SQL for Business Analysis

The SQL concepts are combined to answer practical questions about the Hyderabad Metro dataset.

The analytical workflow is:

```text
Business Question
       ↓
Identify Required Tables
       ↓
Understand Relationships
       ↓
JOIN Tables
       ↓
Filter & Aggregate
       ↓
Apply Advanced SQL
       ↓
Interpret Results
       ↓
Generate Finding
```

Analysis areas include:

* Network analysis
* Route performance
* Station analysis
* Trip analysis
* Service analysis
* Fare analysis
* Operational analysis

---

# 15. SQL Concepts by Project Stage

| Project Stage        | Main SQL Concepts                        |
| -------------------- | ---------------------------------------- |
| Data Inspection      | `SELECT`, `LIMIT`, `DISTINCT`            |
| Filtering            | `WHERE`, comparison operators            |
| Validation           | `COUNT`, `GROUP BY`, `HAVING`, `IS NULL` |
| Relationship Checks  | `JOIN`, `LEFT JOIN`                      |
| Analysis             | Aggregations, `CASE`                     |
| Advanced Analysis    | Subqueries, CTEs                         |
| Ranking & Comparison | Window functions                         |
| Reporting            | SQL Views                                |
| Business Analysis    | Combination of all relevant techniques   |

---

# 16. SQL Best Practices

The project follows several important SQL practices:

* Use meaningful table and column aliases.
* Select only the columns required for analysis.
* Use explicit `JOIN` conditions.
* Validate relationships before performing analysis.
* Use `COUNT(DISTINCT ...)` when required by relationship cardinality.
* Use CTEs to improve complex query readability.
* Validate analytical results before interpreting them.

---

# 17. Data Interpretation Consideration

SQL results must always be interpreted according to the meaning and limitations of the underlying data.

The Hyderabad Metro datasets primarily contain **scheduled transit, network, geographic, service-calendar, and fare information**.

Therefore:

```text
Scheduled Trips
      ≠
Actual Passenger Demand
```

and:

```text
Scheduled Stop Times
      ≠
Actual Travel Performance
```

Passenger demand, revenue, delays, occupancy, and similar measures would require additional datasets.

---

# 18. Final SQL Workflow

The complete SQL workflow can be summarized as:

```text
Database
   ↓
Inspect
   ↓
Validate
   ↓
Understand Relationships
   ↓
Basic SQL
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
Views
   ↓
Business Analysis
   ↓
Findings & Recommendations
```

---

# 19. Summary

The Hyderabad Metro MySQL project uses SQL as both a **database validation tool** and an **analytical language**.

The major concepts covered are:

```text
SELECT
WHERE
DISTINCT
ORDER BY
LIMIT
NULL Handling
Aggregate Functions
GROUP BY
HAVING
JOINs
CASE
Subqueries
CTEs
Window Functions
COUNT(DISTINCT)
Views
```

These concepts are progressively combined to transform the validated database into meaningful analytical results.

The overall objective is to demonstrate a complete SQL workflow:

```text
Reliable Data
      ↓
Correct Relationships
      ↓
Effective SQL
      ↓
Accurate Analysis
      ↓
Business Insights
      ↓
Evidence-Based Recommendations
```

This demonstrates practical SQL proficiency while connecting database knowledge with real-world transportation data analysis.
