<!-- .slide -->

# Profiles

Profiles are a centralized way to store configuration that defines connection details for different databases or data warehouses.

Profiles tell _dbt_ **HOW** to run.

_dbt_ searches for a `profiles.yml` file in this order:

- path passed as argument of the dbt commands
- then at the root of your dbt project directory
- then in the `$HOME/.dbt` directory

Profiles make it easier to switch between different environments and databases thanks to targets.

Be careful not to commit your `profiles.yml` file with hardcoded credentials !

<!-- .element: class="admonition warning" -->

Notes:

- Profile file are yaml files
- You can have as many profiles as you want in a file, or use different files (use arguments to define which file to use)
- Profiles enhance the flexibility and portability of your dbt projects


##==##


<!-- .slide: class="with-code"-->

# Profiles

## Simple profiles.yml

```yaml
sfeir_institute: # This is the name of your profile
  target: dev # This is the name of the default target / outputs below
  outputs:
    dev:
      type: postgres
      threads: 4
      host: localhost
      port: 5432
      user: dbt
      pass: dibiti
      dbname: dbt_03
      schema: sales
```


##==##


<!-- .slide: class="with-code"-->

# Profiles

## Advanced profiles.yml (1/2)

You can use anchors and environment variables in YAML to avoid repeating blocks.

```yaml
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


##==##


<!-- .slide: class="with-code"-->

# Profiles

## Advanced profiles.yml (2/2)

Then use anchors reference in the actual profiles.

```yaml
# Actual profiles
gitlab:
  target: dev # Default target name.
  outputs: # The list of targets and the config associated with them
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

```yaml
name: 'sfeir_institute'
profile: 'local' # dbt will look for this profile if not overridden in command args
```

Command to run _dbt_ with profile "gitlab"

```bash
# Use default profile
$ dbt run

# Specify profile to use
$ dbt run --profile gitlab

# Specify profile to use and in which directory is located the profiles.yml
$ dbt run --profile gitlab --profiles-dir ~/.dbt/profiles
```

Notes:

- dbt does NOT use "default" profile anymore to avoid unintentionnal usage of credentials / env.
