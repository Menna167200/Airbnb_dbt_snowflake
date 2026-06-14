import os
from datetime import datetime
from cosmos import DbtDag, ProjectConfig, ProfileConfig, ExecutionConfig
from cosmos.profiles import SnowflakeUserPasswordProfileMapping

DBT_PROJECT_PATH = '/opt/airflow/airbnb_dbt_snowflake'

profile_config = ProfileConfig(
    profile_name='airbnb_dbt_snowflake',
    target_name='dev',
    profile_mapping=SnowflakeUserPasswordProfileMapping(
        conn_id='snowflake_connection',
        profile_args={
            'database': os.environ['SNOWFLAKE_DATABASE'],
            'schema': os.environ['SNOWFLAKE_SCHEMA'],
            'warehouse': os.environ['SNOWFLAKE_WAREHOUSE'],
        },
    ),
)

execution_config = ExecutionConfig(
    dbt_executable_path='/home/airflow/.local/bin/dbt',
)

airbnb_dbt_dag = DbtDag(
    project_config=ProjectConfig(DBT_PROJECT_PATH),
    profile_config=profile_config,
    execution_config=execution_config,
    schedule='@daily',
    start_date=datetime(2026, 1, 1),
    catchup=False,
    dag_id='airbnb_dbt',
    default_args={'retries': 2},
)