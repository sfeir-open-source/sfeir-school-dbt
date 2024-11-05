<!-- .slide: class="transition"-->

# Packages and dependencies

## Installing and using dbt packages

##==##

<!-- .slide: class="with-code max-height"-->

# Add packages to a project

dependencies.yml (or packages.yml)

```yaml
packages:
  # Hub packages (recommended)
  - package: calogica/dbt_expectations
    version: 0.10.0

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
