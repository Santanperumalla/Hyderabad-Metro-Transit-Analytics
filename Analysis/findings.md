# Hyderabad Metro Transit Analytics — Findings

## Overview

This document presents the key findings identified from the Hyderabad Metro SQL business analysis.

The findings are derived from the validated MySQL database and the business-analysis queries stored in:

```text
queries/07_business_analysis/
```

The purpose of this document is to translate SQL query results into clear, business-oriented observations about the metro network, routes, stations, trips, services, fares, and scheduled operations.

Each finding should be supported by an actual SQL result and should distinguish clearly between:

* **Observed result** — what the data directly shows
* **Interpretation** — what the result may indicate
* **Business significance** — why the finding matters

---

# 1. Network Analysis Findings

## 1.1 Network Size

**SQL Question:**
How many routes, stations, trips, and other network elements are represented in the dataset?

**Finding:**
The analysis identifies the overall size and composition of the Hyderabad Metro network represented by the available GTFS data.

**Observed Result:**

* Total routes: `[INSERT RESULT]`
* Total stations/stops: `[INSERT RESULT]`
* Total trips: `[INSERT RESULT]`
* Total shapes: `[INSERT RESULT]`

**Interpretation:**
These values provide a high-level understanding of the network represented in the dataset.

**Business Significance:**
This establishes the baseline against which route, station, trip, service, and operational characteristics can be compared.

---

## 1.2 Route Distribution

**Finding:**
The routes table provides the structural definition of the metro network, while associated trips and stops provide information about how scheduled services are distributed across those routes.

**Observed Result:**

> `[INSERT SQL RESULT / SUMMARY]`

**Interpretation:**
Routes with larger numbers of associated scheduled trips or stops have greater representation within the available timetable structure.

---

# 2. Route Performance Findings

## 2.1 Routes With the Highest Scheduled Trip Volume

**SQL Question:**
Which routes have the highest number of scheduled trips?

**Finding:**
The analysis identifies the routes with the greatest number of scheduled trips.

**Observed Result:**

| Rank | Route     | Scheduled Trips |
| ---: | --------- | --------------: |
|    1 | `[Route]` |       `[Value]` |
|    2 | `[Route]` |       `[Value]` |
|    3 | `[Route]` |       `[Value]` |

**Interpretation:**
A higher scheduled-trip count indicates greater representation of that route in the available timetable.

**Business Significance:**
This can help compare the planned service allocation across different routes.

> **Caution:** Scheduled trips should not be treated as passenger demand because the dataset does not contain actual ridership information.

---

## 2.2 Routes With the Largest Stop Coverage

**Finding:**
The analysis identifies routes associated with the greatest number of stops.

**Observed Result:**

> `[INSERT SQL RESULT]`

**Interpretation:**
Routes with more stops represent longer or more extensive stop sequences within the available schedule structure.

---

# 3. Station Analysis Findings

## 3.1 Most Frequently Served Stations

**SQL Question:**
Which stations are associated with the highest number of scheduled trips?

**Finding:**
The station analysis identifies stations that occur across a larger number of scheduled services.

**Observed Result:**

| Rank | Station     | Scheduled Services |
| ---: | ----------- | -----------------: |
|    1 | `[Station]` |          `[Value]` |
|    2 | `[Station]` |          `[Value]` |
|    3 | `[Station]` |          `[Value]` |

**Interpretation:**
Stations appearing across many scheduled services have greater scheduled service coverage.

**Business Significance:**
These stations may represent important points within the scheduled network structure.

---

## 3.2 Stations Served by Multiple Routes

**Finding:**
Some stations are associated with multiple routes.

**Observed Result:**

> `[INSERT SQL RESULT]`

**Interpretation:**
Stations served by multiple routes have greater connectivity within the network represented by the dataset.

**Business Significance:**
Such stations can be important when evaluating route connectivity and potential transfer points.

---

# 4. Trip Analysis Findings

## 4.1 Trip Distribution by Route

**Finding:**
Scheduled trips are not necessarily distributed evenly across all routes.

**Observed Result:**

> `[INSERT SQL RESULT]`

**Interpretation:**
Differences in trip counts indicate differences in scheduled service allocation.

---

## 4.2 Trip Stop Sequence

**Finding:**
The `stop_times` data allows individual trips to be examined based on their stop sequences.

**Observed Result:**

> `[INSERT SQL RESULT]`

**Interpretation:**
Trips with larger stop sequences represent services that pass through more scheduled stops.

**Business Significance:**
This provides a way to compare the structural characteristics of individual scheduled trips.

---

## 4.3 Earliest and Latest Scheduled Services

**Finding:**
The analysis identifies the earliest and latest scheduled arrival/departure times represented in the dataset.

**Observed Result:**

* Earliest scheduled time: `[INSERT TIME]`
* Latest scheduled time: `[INSERT TIME]`

**Interpretation:**
These values provide an indication of the timetable's scheduled operating span.

---

# 5. Service Analysis Findings

## 5.1 Service Distribution

**Finding:**
The `calendar` and `trips` tables reveal how scheduled trips are associated with different service patterns.

**Observed Result:**

> `[INSERT SQL RESULT]`

**Interpretation:**
Different service IDs may represent different operating-day configurations.

---

## 5.2 Weekday vs Weekend Service

**Finding:**
The calendar data can be used to compare the presence of scheduled service across weekdays and weekends.

**Observed Result:**

| Day       | Scheduled Trips |
| --------- | --------------: |
| Monday    |       `[Value]` |
| Tuesday   |       `[Value]` |
| Wednesday |       `[Value]` |
| Thursday  |       `[Value]` |
| Friday    |       `[Value]` |
| Saturday  |       `[Value]` |
| Sunday    |       `[Value]` |

**Interpretation:**
Differences between days indicate variations in the scheduled service calendar.

---

# 6. Fare Analysis Findings

## 6.1 Fare Structure

**Finding:**
The `fare_attributes` table identifies the fare products and associated pricing information represented in the dataset.

**Observed Result:**

> `[INSERT SQL RESULT]`

**Interpretation:**
The dataset contains multiple fare attributes that can be examined based on their defined prices and characteristics.

---

## 6.2 Origin-Destination Fare Relationships

**Finding:**
The `fare_rules` table defines relationships between origin IDs, destination IDs, and fare IDs.

**Observed Result:**

| Origin ID  | Destination ID  | Fare ID  |
| ---------- | --------------- | -------- |
| `[Origin]` | `[Destination]` | `[Fare]` |
| `[Origin]` | `[Destination]` | `[Fare]` |

**Interpretation:**
These relationships allow fares to be analyzed based on defined origin-destination combinations.

**Important Data Constraint:**

The `fare_rules` table does **not** contain `route_id` in this project.

Therefore, fare findings should be based on:

```text
Origin ID
     +
Destination ID
     +
Fare ID
     ↓
Fare Attributes
```

The analysis should not claim that a particular fare belongs to a specific route unless that relationship can be established through the available tables.

---

## 6.3 Highest and Lowest Fares

**Finding:**
The analysis identifies the minimum and maximum fare values represented in the fare data.

**Observed Result:**

* Minimum fare: `[INSERT VALUE]`
* Maximum fare: `[INSERT VALUE]`

**Interpretation:**
The difference between these values represents the range of fare prices available within the dataset.

---

# 7. Operational Analysis Findings

## 7.1 Scheduled Service Coverage

**Finding:**
The combined analysis of routes, trips, stops, stop times, and calendar information provides a view of scheduled operational coverage.

**Observed Result:**

> `[INSERT SQL RESULT]`

**Interpretation:**
The results identify where scheduled service is concentrated and how it varies across routes and stations.

---

## 7.2 Operating Time Span

**Finding:**
The scheduled arrival and departure times provide an indication of the operating time span represented in the timetable.

**Observed Result:**

> `[INSERT SQL RESULT]`

**Interpretation:**
The difference between the earliest and latest scheduled services provides a basic measure of the timetable's scheduled operating window.

---

# 8. Cross-Analysis Findings

The most valuable insights may emerge when multiple tables are analyzed together.

Examples include:

### Route + Trip

Determines how scheduled trip volume varies across routes.

### Route + Stops

Determines the number of stations associated with different routes.

### Station + Trips

Identifies stations with greater scheduled service coverage.

### Trips + Calendar

Shows how scheduled trips relate to operating-day patterns.

### Fare Rules + Fare Attributes

Connects origin-destination relationships with their corresponding fare products.

### Routes + Trips + Stop Times

Provides a combined view of route-level scheduled service and stop sequences.

---

# 9. Key Findings Summary

The most important findings should be summarized here after all business-analysis queries have been executed.

| Area       | Key Finding | Evidence      |
| ---------- | ----------- | ------------- |
| Network    | `[Finding]` | `[SQL Query]` |
| Routes     | `[Finding]` | `[SQL Query]` |
| Stations   | `[Finding]` | `[SQL Query]` |
| Trips      | `[Finding]` | `[SQL Query]` |
| Service    | `[Finding]` | `[SQL Query]` |
| Fares      | `[Finding]` | `[SQL Query]` |
| Operations | `[Finding]` | `[SQL Query]` |

---

# 10. Evidence-Based Interpretation

The findings in this document should remain strictly grounded in the available data.

The project primarily contains **GTFS schedule, network, stop, trip, geographic, calendar, and fare information**.

Therefore, the findings can support statements about:

* Scheduled service
* Route structure
* Station coverage
* Trip patterns
* Operating-day patterns
* Scheduled time ranges
* Fare relationships
* Network connectivity
* Stop sequences

However, the findings should **not** claim information about:

* Actual passenger demand
* Passenger volume
* Revenue
* Train occupancy
* Customer satisfaction
* Actual delays
* Punctuality
* Real-time operations

unless such data is added to the project.

---

# 11. Findings-to-Recommendations Flow

The findings document should remain separate from the recommendations document.

The analytical workflow is:

```text
Business Question
       ↓
SQL Query
       ↓
SQL Result
       ↓
Finding
       ↓
Interpretation
       ↓
Business Significance
       ↓
Recommendation
```

For example:

```text
Business Question
↓
Which routes have the highest scheduled trip volume?
↓
SQL Analysis
↓
Route A has the highest scheduled trip count.
↓
Finding
↓
Route A has the highest scheduled service representation.
↓
Interpretation
↓
The timetable allocates more scheduled services to Route A.
↓
Recommendation
↓
Investigate whether the scheduled allocation aligns with
operational requirements and available demand data.
```

---

# 12. Final Purpose

The purpose of `findings.md` is to demonstrate the ability to move beyond writing SQL queries and convert database results into meaningful analytical observations.

The final document should answer:

> **What did the data tell us?**

while `business_questions.md` answers:

> **What did we want to know?**

and `recommendations.md` answers:

> **What could be done based on those findings?**

Together, these three documents form the project's analytical narrative:

```text
business_questions.md
        ↓
"What do we want to know?"
        ↓
SQL Business Analysis
        ↓
findings.md
"What does the data show?"
        ↓
recommendations.md
"What could this mean for action?"
```
