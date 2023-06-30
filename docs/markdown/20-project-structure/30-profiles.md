<!-- .slide -->

# Profiles

Profiles are a centralized way to store configuration that defines connection details for different databases or data warehouses.

Profiles tell _dbt_ **HOW** to run.

_dbt_ searches for a `profile.yml` file in this order:

- in the main _dbt_ project directory
- in the `$HOME/.dbt` directory
- path passed as argument of the dbt commands

Profiles make it easier to switch between different environments and databases.

Notes:

- Profile file are yaml files
- You can have as many profiles as you want in a file, or use different files (use arguments to define which file to use)
- Profiles enhance the flexibility and portability of your dbt projects

##==##

<!-- .slide: class="with-code"-->

# Profiles

## Sample `profile.yml` (1/3)

At the top of your profile files, you can set global configuration directives:

```yaml[]
config:
  partial_parse: false
  use_colors: true
  printer_width: 120
  send_anonymous_usage_stats: false
```

##==##

<!-- .slide: class="with-code"-->

# Profiles

## Sample `profile.yml` (2/3)

You can use anchors in `YAML` to avoid repeating configuration blocks.

<!-- {% raw %} -->

```yaml[]
# Configuration for all authentication methods
config_global: &config_global
  type: bigquery
  dataset: "MY_DATASET"
  project: "my-project-{{ env_var('ENV', 'dev') }}"
  ...

config_oauth: &config_oauth
  <<: *config_global
  method: oauth

config_service_account: &config_service_account
  <<: *config_global
  method: service-account
  keyfile: "{{ env_var('GOOGLE_APPLICATION_CREDENTIALS') }}"
```

<!-- {% endraw %} -->

##==##

<!-- .slide: class="with-code"-->

# Profiles

## Sample `profile.yml` (3/3)

Then use anchors reference in the actual profiles.

```yaml[]
# Actual profiles
gitlab:
  target: dev # Default target name.
  outputs:
    dev:
      <<: *config_service_account

local:
  target: dev
  outputs:
    dev:
      <<: *config_oauth
```

##==##

<!-- .slide: class="with-code"-->

# Using profiles

Default profile name must be set in `dbt_project.yml` file.

`dbt_project.yml`

```yaml[]
...
name: "sfeir_school_dbt"
profile: "local"  # dbt will look for this profile if not overridden in command args
...
```

<br>

Command to run _dbt_ with profile "gitlab"

```bash[]
# Use default profile
$ dbt run

# Specify profile to use
$ dbt run --profile gitlab

# Specify profile to use and in which directory
$ dbt run --profile gitlab --profiles-dir ~/.dbt/profiles/school.yml
```

Notes:

- dbt does NOT use "default" profile anymore to avoid unintentionnal usage of credentials / env.
