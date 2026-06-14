# 🏡 Airbnb Data Engineering Project

An end-to-end Analytics Engineering project built using AWS S3, Snowflake, and dbt.

This project demonstrates a modern ELT workflow starting from cloud object storage ingestion all the way to analytics-ready dimensional models using a layered dbt architecture.

<img width="930" height="387" alt="image (1)" src="https://github.com/user-attachments/assets/08e598a0-5469-4f06-b0e4-8b764f4a12c2" />

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

# 🔗 Connecting Airflow to Snowflake

To let Airflow (and Cosmos) authenticate with Snowflake, you need to create an **Airflow Connection**:

1. Open the Airflow UI at `http://localhost:8080`
2. Go to **Admin → Connections**
3. Click **+ Add Connection**
4. Set:
   - **Connection ID**: `snowflake_connection` (must match the `conn_id` used in the dbt DAG)
   - **Connection Type**: `Snowflake`
5. Fill in your Snowflake credentials:
   - **Account**
   - **Login** (username)
   - **Password**
   - **Role**
   - **Warehouse**
   - **Database**
   - **Schema**
6. Click **Save**

<img width="206" height="255" alt="image (2)" src="https://github.com/user-attachments/assets/61407745-2ee7-4e42-a666-4b702ef7ff46" />
<img width="885" height="262" alt="image (3)" src="https://github.com/user-attachments/assets/30239e59-5e18-44d2-bdd1-a1828cb28d2b" />

> 💡 Database, schema, and warehouse can also be supplied via environment variables (`SNOWFLAKE_DATABASE`, `SNOWFLAKE_SCHEMA`, `SNOWFLAKE_WAREHOUSE`) and are picked up automatically by Cosmos's `SnowflakeUserPasswordProfileMapping`.

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

# 📚 References
- [Astronomer Cosmos](https://github.com/astronomer/astronomer-cosmos) — for example DAGs and configuration patterns
