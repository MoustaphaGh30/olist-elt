from airflow import DAG
from airflow.providers.google.cloud.transfers.gcs_to_bigquery import GCSToBigQueryOperator
from airflow.operators.empty import EmptyOperator
from airflow.operators.bash import BashOperator  # for dbt run/test steps
from datetime import datetime, timedelta


PROJECT = "olist-etl-pipeline"
STAGING = "staging"
BUCKET  = "kagglecsv"
GCP_CONN = "google_cloud_default"  

default_args = dict(
    owner="you",
    start_date=datetime(2025, 4, 1),
    retries=0,
    retry_delay=timedelta(minutes=5),
)

with DAG(
    dag_id="staging_csv_to_bq",
    default_args=default_args,
    schedule="@hourly",
    catchup=False,
) as dag:

    start = EmptyOperator(task_id="start")

    load_customers = GCSToBigQueryOperator(
        task_id="load_customers",
        bucket=BUCKET,
        source_objects=["olist_customers_dataset.csv"],
        destination_project_dataset_table=f"{PROJECT}.{STAGING}.customers",
        source_format="CSV",
        skip_leading_rows=1,
        write_disposition="WRITE_TRUNCATE",
        autodetect=True,
        gcp_conn_id=GCP_CONN,
    )

    load_products = GCSToBigQueryOperator(
        task_id="load_products",
        bucket=BUCKET,
        source_objects=["olist_products_dataset.csv"],
        destination_project_dataset_table=f"{PROJECT}.{STAGING}.olist_products",
        skip_leading_rows=1,
        write_disposition="WRITE_TRUNCATE",
        autodetect=True,
        gcp_conn_id=GCP_CONN,
    )

    load_sellers = GCSToBigQueryOperator(
        task_id="load_sellers",
        bucket=BUCKET,
        source_objects=["olist_sellers_dataset.csv"],
        destination_project_dataset_table=f"{PROJECT}.{STAGING}.olist_sellers",
        skip_leading_rows=1,
        write_disposition="WRITE_TRUNCATE",
        autodetect=True,
        gcp_conn_id=GCP_CONN,
    )

    load_geolocation = GCSToBigQueryOperator(
        task_id="load_geolocation",
        bucket=BUCKET,
        source_objects=["olist_geolocation_dataset.csv"],
        destination_project_dataset_table=f"{PROJECT}.{STAGING}.geolocation",
        skip_leading_rows=1,
        write_disposition="WRITE_TRUNCATE",
        autodetect=True,
        gcp_conn_id=GCP_CONN,
    )

    load_orders = GCSToBigQueryOperator(
        task_id="load_orders",
        bucket=BUCKET,
        source_objects=["olist_orders_dataset.csv"],
        destination_project_dataset_table=f"{PROJECT}.{STAGING}.olist_orders",
        skip_leading_rows=1,
        write_disposition="WRITE_APPEND",
        autodetect=True,
        gcp_conn_id=GCP_CONN,
    )

    load_order_items = GCSToBigQueryOperator(
        task_id="load_order_items",
        bucket=BUCKET,
        source_objects=["olist_order_items_dataset.csv"],
        destination_project_dataset_table=f"{PROJECT}.{STAGING}.order_items",
        skip_leading_rows=1,
        write_disposition="WRITE_APPEND",
        autodetect=True,
        gcp_conn_id=GCP_CONN,
    )

    load_payments = GCSToBigQueryOperator(
        task_id="load_payments",
        bucket=BUCKET,
        source_objects=["olist_order_payments_dataset.csv"],
        destination_project_dataset_table=f"{PROJECT}.{STAGING}.order_payments",
        skip_leading_rows=1,
        write_disposition="WRITE_APPEND",
        autodetect=True,
        gcp_conn_id=GCP_CONN,
    )

    load_reviews = GCSToBigQueryOperator(
    task_id="load_reviews",
    bucket=BUCKET,
    source_objects=["olist_order_reviews_dataset.csv"],
    destination_project_dataset_table=f"{PROJECT}.staging.olist_order_reviews_dataset",
    source_format="CSV",
    skip_leading_rows=1,
    quote_character='"',
    allow_quoted_newlines=True,
    write_disposition="WRITE_APPEND",
    autodetect=True,
    gcp_conn_id=GCP_CONN,
    )

    end = EmptyOperator(task_id="end")

    dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command=(
            "cd /opt/airflow/dbt/olist_project && "
            "dbt run --profiles-dir /opt/airflow/dbt"
        ),
    )

    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command=(
            "cd /opt/airflow/dbt/olist_project && "
            "dbt test --profiles-dir /opt/airflow/dbt"
        ),
    )

    start >> [
        load_customers,
        load_products,
        load_sellers,
        load_geolocation,
        load_orders,
        load_order_items,
        load_payments,
        load_reviews,
    ] >> end >> dbt_run >> dbt_test
