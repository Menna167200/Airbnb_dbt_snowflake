FROM apache/airflow:3.1.8

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

USER airflow


RUN pip install dbt-core>=1.11.11 dbt-snowflake>=1.11.5 astronomer-cosmos>=1.6.0 apache-airflow-providers-snowflake>=6.0.0