# Hyderabad Metro — Data Cleaning & Transformation

## 1. Overview

Data cleaning is the stage between the **raw Hyderabad Metro GTFS files** and the **processed datasets loaded into MySQL**.

The purpose of this stage is to make the source data consistent, structured, and suitable for relational database analysis while preserving the original information.

The overall process is:

```text
Raw GTFS Files
      ↓
Data Inspection
      ↓
Column & Data-Type Analysis
      ↓
Missing-Value Handling
      ↓
Duplicate Checking
      ↓
Format Standardization
      ↓
Identifier Validation
      ↓
Relationship Validation
      ↓
Processed Datasets
      ↓
MySQL Data Loading
```

The cleaned datasets are then used as the source for the MySQL database.

---

# 2. Source Data

The project contains ten GTFS-based source files:

```text
agency.txt
calendar.txt
fare_attributes.txt
fare_rules.txt
feed_info.txt
routes.txt
shapes.txt
stop_times.txt
stops.txt
trips.txt
```

Each file represents a different component of the transit system.

| File                  | Main Purpose                               |
| --------------------- | ------------------------------------------ |
| `agency.txt`          | Transit agency information                 |
| `calendar.txt`        | Service-day and service-period information |
| `fare_attributes.txt` | Fare information                           |
| `fare_rules.txt`      | Fare applicability rules                   |
| `feed_info.txt`       | Metadata about the transit feed            |
| `routes.txt`          | Route information                          |
| `shapes.txt`          | Geographic route shapes                    |
| `stop_times.txt`      | Arrival and departure times                |
| `stops.txt`           | Station/stop information                   |
| `trips.txt`           | Scheduled trip information                 |

The files are first treated as **raw source data** and are not directly modified during the cleaning process.

---

# 3. Raw Data Preservation

The original files are stored separately from the processed datasets.

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

Keeping raw and processed data separate provides two important advantages:

1. The original source data remains unchanged.
2. The cleaning process can be repeated without losing the original dataset.

---

# 4. Data Inspection

Before making any transformation, each file is inspected to understand its structure.

The inspection focuses on:

* Column names
* Number of records
* Data types
* Unique identifiers
* Missing values
* Duplicate records
* Date formats
* Time formats
* Numeric fields
* Text fields
* Relationships between identifiers

The objective is to understand the dataset before deciding what transformations are necessary.

---

# 5. Column Structure Analysis

Each source file is analyzed to determine the appropriate database column structure.

For example, identifiers such as:

```text
agency_id
route_id
service_id
trip_id
stop_id
shape_id
```

are treated as identifiers rather than ordinary descriptive text.

Similarly, fields containing:

```text
latitude
longitude
fare values
stop sequences
arrival times
departure times
```

are identified according to their analytical purpose and expected data type.

This information is later used when creating the MySQL tables.

---

# 6. Data-Type Preparation

Raw text files do not inherently provide the same database-level data typing that MySQL tables require.

Therefore, fields are reviewed and prepared according to their intended use.

Typical categories include:

### Identifier fields

Examples:

```text
agency_id
route_id
service_id
trip_id
stop_id
shape_id
```

These are used to connect records between tables.

### Numeric fields

Examples include:

```text
latitude
longitude
fare values
stop sequence
shape sequence
```

These need to be suitable for numerical analysis.

### Date fields

Service-calendar fields are checked for consistent date representation.

### Time fields

Arrival and departure fields are checked for consistent time formatting.

### Text fields

Names, descriptions, URLs, and other descriptive attributes are standardized where necessary.

---

# 7. Missing-Value Handling

Missing values are identified during the cleaning process.

However, a missing value is not automatically treated as an error.

The first question is:

> Is the value genuinely required for the table's purpose?

Some fields may legitimately contain missing values depending on the source data.

The cleaning process therefore distinguishes between:

```text
Expected NULL
      vs.
Unexpected NULL
```

Important identifiers and relationship fields require particular attention because missing identifiers can prevent tables from being joined correctly.

The final database validation stage also includes a dedicated NULL-value check.

---

# 8. Duplicate Checking

Duplicate records are examined before the data is loaded into MySQL.

The objective is to determine whether:

* Complete rows are duplicated.
* Identifier values that should be unique are duplicated.
* Repeated records are legitimate or erroneous.

Duplicate checking is especially important for key fields because unexpected duplicates can cause problems when establishing primary keys or relationships.

The cleaning stage identifies potential duplicates, while the formal database validation stage verifies them using SQL.

---

# 9. Identifier Consistency

GTFS tables are connected using identifiers.

Examples include relationships such as:

```text
agency_id
route_id
service_id
trip_id
stop_id
shape_id
```

These identifiers must remain consistent during cleaning.

For example:

```text
routes.route_id
       ↓
trips.route_id
```

and:

```text
trips.trip_id
       ↓
stop_times.trip_id
```

If an identifier is accidentally changed during transformation, the corresponding relationships may no longer work.

Therefore, identifiers should be preserved exactly unless a documented transformation is required.

---

# 10. Date Standardization

The service calendar contains date-related fields.

These values are checked for consistency before database loading.

The cleaning process ensures that date values follow a consistent representation so that MySQL can correctly interpret them as dates.

The prepared data should support analysis such as:

* Service start dates
* Service end dates
* Service periods
* Operating-day patterns

---

# 11. Time Standardization

The `stop_times` dataset contains arrival and departure information.

Time values are checked for:

* Consistent formatting
* Missing values
* Invalid values
* Correct separation between arrival and departure
* Compatibility with the target MySQL data type

The objective is to ensure that the fields can be used reliably for schedule analysis.

For example:

```text
arrival_time
departure_time
```

can later support analysis of scheduled stop timing and trip duration patterns.

---

# 12. Geographic Data Preparation

The project contains geographical information through fields such as:

```text
stop_lat
stop_lon
shape_pt_lat
shape_pt_lon
```

These values are checked to ensure they are stored as numeric geographic coordinates.

The geographical data supports analysis of:

* Station locations
* Route shapes
* Network structure
* Geographic relationships between stops and routes

The cleaning process should preserve the original coordinate values rather than altering them without a documented reason.

---

# 13. Fare Data Preparation

Fare-related information is contained primarily within:

```text
fare_attributes.txt
fare_rules.txt
```

The two datasets serve different purposes.

```text
fare_attributes
       ↓
Defines fare information

fare_rules
       ↓
Defines where/how fare information applies
```

The fare rules contain origin and destination identifiers rather than relying on a `route_id` field.

Therefore, fare analysis should use the available origin and destination fields when connecting fare rules with the appropriate station/stop information.

This distinction is important when designing the database and writing fare-analysis queries.

---

# 14. Processed Dataset Creation

After cleaning and transformation, the prepared files are stored in:

```text
data/processed/
```

The naming convention makes the purpose clear:

```text
agency_clean.csv
calendar_clean.csv
fare_attributes_clean.csv
fare_rules_clean.csv
feed_info_clean.csv
routes_clean.csv
shapes_clean.csv
stop_times_clean.csv
stops_clean.csv
trips_clean.csv
```

These processed files become the input for the MySQL data-loading stage.

---

# 15. Data Cleaning Principles

The project follows several principles during data preparation.

### Principle 1 — Preserve Source Information

Cleaning should improve consistency without unnecessarily changing the meaning of the source data.

### Principle 2 — Do Not Invent Data

Missing information should not be fabricated simply to make the dataset appear complete.

### Principle 3 — Preserve Identifiers

Keys and relationship identifiers should remain consistent across datasets.

### Principle 4 — Separate Cleaning from Analysis

The cleaning stage prepares the data.

The SQL analysis stage interprets the data.

```text
Cleaning
   ↓
Reliable Data
   ↓
Analysis
```

### Principle 5 — Document Transformations

Any meaningful modification to the source data should be documented so that the transformation is reproducible.

---

# 16. Quality Checks Before MySQL Loading

Before loading the processed datasets into MySQL, the following checks should be completed:

```text
✓ Correct column structure
✓ Correct column names
✓ Consistent identifiers
✓ Appropriate data types
✓ Duplicate review
✓ NULL-value review
✓ Date-format review
✓ Time-format review
✓ Numeric-value review
✓ Geographic-coordinate review
✓ Relationship-key review
```

Once these checks are completed, the processed files are ready for database loading.

---

# 17. Relationship Preparation

The cleaned datasets must preserve the relationships required by the relational database.

The primary relationships include:

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

Additional relationships include:

```text
Calendar
   ↓
Trips

Routes
   ↓
Shapes

Fare Attributes
   ↓
Fare Rules
```

These relationships form the foundation of the MySQL database design.

---

# 18. Cleaning → Loading → Validation

Data cleaning is not the final quality-control stage.

The complete process is:

```text
RAW DATA
   ↓
DATA CLEANING
   ↓
PROCESSED DATA
   ↓
MYSQL DATA LOADING
   ↓
ROW COUNT VALIDATION
   ↓
TABLE STRUCTURE VALIDATION
   ↓
DATA INSPECTION
   ↓
DUPLICATE VALIDATION
   ↓
NULL VALIDATION
   ↓
RELATIONSHIP VALIDATION
   ↓
VALIDATED DATABASE
```

This separation is important.

**Cleaning prepares the data; validation verifies the loaded database.**

---

# 19. Data Cleaning Limitations

The cleaning process is limited by the information contained in the original datasets.

The available data primarily represents transit network and scheduling information.

It does not automatically provide:

* Actual passenger counts
* Passenger demand
* Ticket transactions
* Revenue
* Real-time delays
* Vehicle occupancy
* Passenger waiting times
* Customer satisfaction

Therefore, cleaning cannot create these missing business dimensions.

Any conclusions requiring such information would require additional datasets.

---

# 20. Final Output

The final output of the cleaning stage is a collection of structured processed datasets that can be safely loaded into MySQL.

```text
Raw GTFS Files
      ↓
Inspected Data
      ↓
Cleaned & Standardized Data
      ↓
Processed CSV Files
      ↓
MySQL Tables
```

The processed datasets provide the foundation for the next stages of the project:

**Database Creation → Data Validation → SQL Analysis → Business Analysis → Findings → Recommendations.**

---

## 21. Summary

The data-cleaning stage establishes the foundation for the entire Hyderabad Metro SQL project.

Its primary purpose is not to alter the data unnecessarily, but to ensure that the source files are:

* Structured
* Consistent
* Relationally compatible
* Suitable for MySQL
* Ready for validation
* Ready for analytical queries

A reliable analytical project begins with reliable data preparation. Therefore, this stage serves as the bridge between the **raw GTFS source files** and the **validated MySQL database** used for business analysis.
