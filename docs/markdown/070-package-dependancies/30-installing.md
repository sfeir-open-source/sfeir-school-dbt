<!-- .slide: class="transition"-->

# Packages and dependencies

## Installing and using dbt packages


##==##


<!-- .slide: class="with-code max-height"-->

# Add packages to a project

_packages.yml_

```yaml
packages:
  # Hub packages (recommended)
  - package: metaplane/dbt_expectations
    version: ['>=0.8.0', '<0.9.0']

  # Git packages
  - git: 'https://github.com/dbt-labs/dbt-utils.git'
    revision: 1.1.1

  # Local packages
  - local: ../my_dbt_package
```

```bash
# Installing and updating packages
$ dbt deps
```

Notes:
Do not commit your package folder in your code repo
