# 🏡 Airbnb Data Engineering Project

An end-to-end Analytics Engineering project built using AWS S3, Snowflake, and dbt.

This project demonstrates a modern ELT workflow starting from cloud object storage ingestion all the way to analytics-ready dimensional models using a layered dbt architecture.

<img width="1307" height="500" alt="image" src="https://github.com/user-attachments/assets/7f098c82-1613-4c6d-804f-fd39d5ea1ce8" />

---

# 🚀 Project Overview

The pipeline follows a layered architecture:

AWS S3 → Snowflake → RAW → STAGING → MART → Orchestrated by Airflow

The project includes:
- Cloud data ingestion using AWS S3
- Snowflake external stages
- Incremental dbt models
- Data cleaning and transformation
- Star schema dimensional modeling
- Slowly Changing Dimensions (SCD Type 2)
- Custom generic testing
- dbt documentation generation
- Workflow orchestration with Apache Airflow (via Cosmos)
- Fully containerized local environment with Docker

---

# 🛠️ Tech Stack

- dbt
- Snowflake
- AWS S3
- Apache Airflow
- Astronomer Cosmos
- Docker
- SQL

---

# ☁️ Data Ingestion with AWS S3 & Snowflake

The raw Airbnb datasets were uploaded to an AWS S3 bucket and then loaded into Snowflake using stages and the `COPY INTO` command.

The ingestion workflow included:
- Creating Snowflake file formats
- Creating external stages connected to AWS S3
- Loading CSV files into Snowflake tables inside the `NODE` schema
  
```
//check here https://docs.snowflake.com/en/sql-reference/sql/create-file-format
CREATE OR REPLACE FILE FORMAT csv_format
  TYPE = 'CSV' 
  FIELD_DELIMITER = ','
  SKIP_HEADER = 1
  ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE;


CREATE OR REPLACE STAGE s3stage
FILE_FORMAT = csv_format
URL='s3://bucket_name/folder_name/'; //pointer to the folder holding all the data

COPY INTO TABLE_NAME
FROM @s3stage
FILES=('table_name.csv')
CREDENTIALS=(aws_key_id = '', aws_secret_key = '');
```

Source tables:
- BOOKINGS
- HOSTS
- LISTINGS

---

# 🏗️ Project Architecture

<img width="1536" height="1024" alt="ChatGPT Image May 23, 2026, 01_37_05 AM" src="https://github.com/user-attachments/assets/8fbe17b7-636c-4f24-ad4d-4182f22c943e" />

---

# ⚡ RAW Layer

The RAW layer incrementally ingests data from Snowflake source tables.

Key features:
- Incremental loading using `CREATED_AT`
- Reduced compute costs
- Faster execution
- Scalable processing for large datasets

---

# 🧹 STAGING Layer

The staging layer performs:
- Data cleaning
- Null handling
- Derived metrics creation
- Data standardization
- Data validation

---

# 📊 MART Layer

The MART layer follows a Star Schema design.

## ⭐ Fact Table

### `fact_bookings`

Contains:
- Booking metrics
- Financial measures
- Booking statuses
- Listing key
- Host key

---

## 📚 Dimension Tables

### `dim_hosts`
Stores historical host information.

### `dim_listings`
Stores historical listing information.

---

# 🕒 Slowly Changing Dimensions (SCD Type 2)

dbt snapshots are used to preserve historical changes in:
- Hosts
- Listings

This enables:
- Historical tracking
- Point-in-time analysis
- Change auditing

---

# ✅ Data Quality Testing

The project includes:
- `not_null` tests
- `unique` tests
- `relationships` tests
- Custom generic tests

### Custom Validations
- Booking status validation
- Property type validation
- Room type validation

---

# 🔄 Orchestration with Apache Airflow

The dbt workflow (staging → snapshots → marts → tests) is orchestrated using Apache Airflow with Astronomer Cosmos, which automatically generates Airflow tasks from the dbt project's lineage graph.

The full stack runs locally via Docker Compose (Airflow, Postgres, Redis, custom image with dbt-core + dbt-snowflake).

---

# 📈 Key Engineering Concepts Demonstrated

- Analytics Engineering
- ELT Pipelines
- Incremental Loading
- Data Modeling
- Star Schema Design
- Slowly Changing Dimensions
- Data Quality Testing
- dbt Snapshots
- Cloud Data Warehousing
- Workflow Orchestration (Airflow + Cosmos)
- Containerized Local Development (Docker)
---

# 📌 Future Improvements

- Add CI/CD pipelines
- Add source freshness monitoring
- Add dashboarding layer
- Add automated deployments

---
