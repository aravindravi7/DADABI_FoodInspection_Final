# =====================================================
# Databricks Job Configuration: Food Inspection ETL Pipeline
# =====================================================

# NOTE:
# The following Databricks magic commands are not valid in a .py file.
# Run them manually in a notebook if needed:
# %pip install --upgrade databricks-sdk==0.70.0
# %restart_python

from databricks.sdk.service.jobs import JobSettings as Job
from databricks.sdk import WorkspaceClient

# Define Job Configuration
Food_Inspection_ETL_Pipeline = Job.from_dict(
    {
        "name": "Food_Inspection_ETL_Pipeline",
        "tasks": [
            {
                "task_key": "01_bronze_ingestion",
                "notebook_task": {
                    "notebook_path": "notebooks/01_bronze_ingestion",
                    "source": "GIT",
                },
            },
            {
                "task_key": "03_silver_cleansing",
                "depends_on": [
                    {
                        "task_key": "01_bronze_ingestion",
                    },
                ],
                "notebook_task": {
                    "notebook_path": "notebooks/03_silver_cleansing",
                    "source": "GIT",
                },
            },
            {
                "task_key": "04_gold_dim_load",
                "depends_on": [
                    {
                        "task_key": "03_silver_cleansing",
                    },
                ],
                "notebook_task": {
                    "notebook_path": "notebooks/04_gold_dim_load",
                    "source": "GIT",
                },
            },
        ],
        "git_source": {
            "git_url": "https://github.com/aravindravi7/FoodInspection_Chicago_Dallas.git",
            "git_provider": "gitHub",
            "git_branch": "main",
        },
        "queue": {
            "enabled": True,
        },
        "parameters": [
            {
                "name": "volume_path",
                "default": "/Volumes/workspace/food_inspection/raw_data",
            },
            {
                "name": "chicago_file",
                "default": "Food_Inspections_20260411.csv",
            },
            {
                "name": "dallas_file",
                "default": "Restaurant_and_Food_Establishment_Inspections_(October_2016_to_January_2024)_20260411.csv",
            },
            {
                "name": "database_name",
                "default": "food_inspection",
            },
        ],
        "environments": [
            {
                "environment_key": "Default",
                "spec": {
                    "environment_version": "5",
                },
            },
        ],
        "performance_target": "PERFORMANCE_OPTIMIZED",
    }
)

# Initialize Workspace Client
w = WorkspaceClient()

# Reset existing job
w.jobs.reset(new_settings=Food_Inspection_ETL_Pipeline, job_id=436327109340686)

# Alternatively, create a new job:
# w.jobs.create(**Food_Inspection_ETL_Pipeline.as_shallow_dict())
