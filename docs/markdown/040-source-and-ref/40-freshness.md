<!-- .slide: class="transition"-->

# _dbt_ Sources and References

## Checking source freshness

##==##

<!-- .slide: class="with-code max-height"-->

# Declaring source freshness requirement

Updating your models only if your sources are up-to-date makes sense.

Implementing source freshness control will help you save compute and brain power.

_/models/\_\_sources.yml_

```yaml
sources:
  - name: 'SAP'
    database: "ssd-{{ env_var('ENV', 'dev') }}"
    schema: 'sap'
    freshness: # default freshness for all tables in this source
    warn_after: { count: 12, period: hour }
    error_after: { count: 24, period: hour }
    loaded_at_field: \_\_timestamp
    tables:
      - name: 'companies'
        freshness: # Override freshness for this specific table
        warn_after: { count: 7, period: day }
        error_after: { count: 30, period: day }
```

##==##

<!-- .slide: class="with-code"-->

# Checking source freshness

Checking your sources freshness is pretty straightforward:

```bash
# Check for all sources with freshness configuration
$ dbt source freshness

# Check only for sources tagged "need_up_to_date"
$ dbt source freshness --select tag:need_up_to_date
```

The command will return an error or warning in case freshness is not matched.
