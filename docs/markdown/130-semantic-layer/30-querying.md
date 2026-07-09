<!-- .slide: class="with-code max-height"-->

# How to query Semantic Layer? (CLI)

**Metric Flow CLI**

Simple query
```bash
mf query --metrics total_revenue
```
Query with dimensions
```bash
mf query \
--metrics total_revenue \
--group-by product_category
```
Query with time filter
```bash
mf query \
--metrics average_basket \
--group-by last_restock_date__month \
--where "last_restock_date >= '2024-01-01'"
```


##==##


<!-- .slide: class="with-code max-height"-->

# How to query Semantic Layer? (CLI)

**Metric Flow CLI**

Get the generated SQL
```bash
mf query --metrics total_revenue --explain
```
Validate your semantic graph – run this in every PR pipeline
```bash
mf validate-configs (or "dbt sl validate" on dbt cloud)
```
Execute a pre-configured Saved Query export
```bash
mf query --saved-query revenue_by_category
```

`--explain` : show the query | `--csv` : export the result

##==##


<!-- .slide: class="with-code max-height"-->

# How to query Semantic Layer? (API/Python)

**API REST**

```python
# api.py
from metricflow.cli.main import query
import subprocess

def get_metric(metric_name, group_by=None):
    cmd = f"mf query --metrics {metric_name}"
    if group_by:
        cmd += f" --group-by {group_by}"

    result = subprocess.run(cmd, shell=True, capture_output=True)
    return result.stdout
```


##==##


<!-- .slide: class="with-code max-height"-->

# How to query Semantic Layer? (dbt Cloud)

**DBT Cloud**

```yaml
# profiles.yml
my_project:
  target: prod
  outputs:
    prod:
      type: duckdb
      semantic_layer_url: https://semantic-layer.cloud.getdbt.com
      service_token: "{{ env_var('DBT_SERVICE_TOKEN') }}"
```
