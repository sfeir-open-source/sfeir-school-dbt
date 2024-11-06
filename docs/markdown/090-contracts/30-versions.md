<!-- .slide: class="transition"-->

# Versions

## Versioning models

##==##

# Versioning models

Versioning models allows you to track changes over time and help you with data governance and model access management.

This feature is used to deploy updated versions of the same model without impacting current consumers, and leaving them time windows to update.

With dbt cloud, versioning can detect changes to models and prevent breaking changes to be published into production.

##==##

# Versioning models

By default, if versioning is enabled on a model, dbt adds a **"\_vX"** suffix to the generated model name, where X is the version declared in the property file.

| Version | Model name   |
| ------- | ------------ |
| -       | customers    |
| 1       | customers_v1 |
| 2       | customers_v2 |

If not explicitly specified, dbt automatically set the `latest_version` to the highest number.

##==##

# Versioning models

For each version of your model, you have to explicitly create a SQL file matching the contract and expected definition, and dbt will materialize each version in your warehouse.

| Version | Default model file name          |
| ------- | -------------------------------- |
| 1       | /models/customers_v1.sql         |
| 2       | /models/customers_v2.sql         |
| latest  | Link to /models/customers_v2.sql |

Reference a specific version of a model using the version argument of the ref() function (defaults to latest version).

```sql
SELECT * FROM {{ ref("customers", version=2) }}
```

##==##

# Versioning models

dbt does not create automatically a view pointing to the latest version of your models, and the tables or views are always suffixed with the **"\_vX"** syntax in your warehouse.

You can trigger this behavior using a [macro in the post-hook](https://docs.getdbt.com/docs/collaborate/govern/model-versions#configuring-database-location-with-alias) of a model, that will create a view without suffix once the model is created.

##==##

<!-- .slide: class="with-code max-height"-->

# Versioning models

Complete definition for each version (not recommended)

_models/\_\_models.yml_

```yaml
models:
  - name: mymodel
    latest_version: 1
    versions:
      - v: 1
        config:
          contract:
            enforced: true
        columns:
          - name: id
            data_type: int
          - name: name
            data_type: string
```

##==##

<!-- .slide: class="with-code max-height"-->

# Versioning models

Inheritance of global properties of the model (recommended)

_models/\_\_models.yml_

```yaml
models:
  - name: mymodel
    latest_version: 1
    config:
      contract:
        enforced: true
    columns:
      - name: id
        data_type: int
      - name: name
        data_type: string

    versions:
      - v: 1
```

##==##

<!-- .slide: class="with-code max-height"-->

# Versioning models

New version with differences only

_models/\_\_models.yml_

```yaml
models:
  - name: mymodel
    latest_version: 2
    columns:
      - name: id
        data_type: int
      - name: name
        data_type: string

    versions:
      - v: 1
      - v: 2
        columns:
          - include: all
            exclude: [name]
          - name: firstname
            data_type: string
```

Notes:
Be careful with the way to “exclude” columns → no dash before the keyword “exclude”
