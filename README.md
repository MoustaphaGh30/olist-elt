# Brazilian E-Commerce Data Analytics Pipeline

This project implements an **ELT pipeline** for the Brazilian E-Commerce (Olist) dataset, covering data ingestion, storage, transformation, querying, and visualization.

---

## Technologies Used

- **Google Cloud Storage (GCS):** Cloud storage for raw data ingestion.
- **BigQuery:** Cloud-based data warehouse for structured data storage and querying.
- **dbt (Data Build Tool):** SQL-based transformation layer to build a dimensional model (fact and dimension tables).
- **Apache Airflow:** Workflow orchestration tool for automating ELT pipeline stages.
- **MySQL:** Initial data exploration and transformations (first approach).
- **Python (Pandas, NumPy):** Data preprocessing and exploratory analysis.
- **Looker Studio:** Interactive dashboard creation and visualization of KPIs.

## Project Structure

- **Initial MySQL Approach:**  
  - Notebook: [`MSBA305-FinalProject.ipynb`](MSBA305-FinalProject.ipynb)  
  - Performed direct ingestion, exploration, and transformations inside a local MySQL database.

- **Airflow DAGs:**  
  - DAG Script: [`airflow/dags/ecommerce_pipeline.py`](airflow/dags/ecommerce_pipeline.py)  
  - Manages the automated ELT workflow, from ingestion (GCS) to transformation (dbt) and loading into BigQuery.

- **Data Cleaning & Transformations:**  
  - Folder: [`dbt/olist_project/models`](dbt/olist_project/models)  
  - Contains SQL models for staging, cleaning, dimensional modeling, and building final analytical tables.

---

## Pipeline Overview

1. **Data Ingestion:** Load raw CSV data into GCS buckets.
2. **Loading:** Ingest raw data from GCS into BigQuery staging tables.
3. **Transformation:** Clean, join, and aggregate data using dbt.
4. **Orchestration:** Schedule and automate the entire workflow using Apache Airflow.
5. **Visualization:** Build dashboards on Looker Studio using final transformed tables.

---

## Key Highlights

- **Scalable and modular architecture** designed using best practices for modern data engineering.
- **Dimensional modeling** implemented with dbt
- **Airflow DAGs** automate end-to-end ELT workflows to guarantee reproducibility and monitoring.
- **Looker dashboards** provide insights
  
---

- ## License
This project is licensed under the [Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0)](https://creativecommons.org/licenses/by-nc/4.0/).

You are free to:
- Share — copy and redistribute the material in any medium or format
- Adapt — remix, transform, and build upon the material

Under the following terms:
- **Attribution** — You must give appropriate credit.
- **NonCommercial** — You may not use the material for commercial purposes.

No warranties are provided. See the [full license here](https://creativecommons.org/licenses/by-nc/4.0/).

