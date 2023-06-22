<!-- .slide -->

# _dbt_ in production

## dbt Cloud

![center hm-800](./assets/images/docs/markdown/80-advanced/dbt-cloud.png)

##==##

# _dbt_ in production

## Airflow x _dbt_

[airflow-dbt](https://pypi.org/project/airflow-dbt/) provides a convenient way to run _dbt_ command on Airflow.

<br/>

```python[]
from airflow_dbt.operators.dbt_operator import (
    DbtSeedOperator, DbtSnapshotOperator, DbtRunOperator, DbtTestOperator
)
...
with DAG(...) as dag:
  dbt_run = DbtRunOperator(
    task_id='dbt_run',
  )
  
  dbt_test = DbtTestOperator(
    task_id='dbt_test',
  )
  
  dbt_run >> dbt_test
  
```

<br/>

These operator will be run _dbt_ within Airflow environment. You must ensure library version compatibility for all DAGs.

##==##

# _dbt_ in production

## Airflow x _dbt_: Cloud based version

When using `Google Cloud Composer`, `MWAA` or `Astronomer`, you should think about running _dbt_ in docker instance on
Kubernetes. This allows:

* better isolation of executions by allowing the use of different versions of dbt,

* interaction with different Data Warehouse by declaring different adapters

* and a better use of Airflow

##==##

# _dbt_ in production

## Astronomer Cosmos

Astronomer published [Cosmos](jaffle_shop_task_group) library to compute each step of _dbt_ graph as an Operator. Each
operator will define its own virtualenv to allow isolation.

![center hm-600](./assets/images/docs/markdown/80-advanced/jaffle_shop_task_group.png)
