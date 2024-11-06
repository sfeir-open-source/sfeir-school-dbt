<!-- .slide: class="transition"-->

# Testing

## Setting up automated tests

##==##

# Automating generic and singular tests

**Check source freshness first**

- This is not done in dbt build
- You can cancel the pipeline if your sources are not up-to-date

**Use dbt build**

- Models tests will run right after the creation of given models
- Singular tests will run right after the creation of referenced models

**Use dbt test with tags**

- Tag your tests and run specific test groups at given steps in your dag

**Do not materialize marts / output tables in case of failure**

- Run tests before it’s too late and don’t expose bad quality data

##==##

# Automating unit tests

**Run unit tests manually and locally**

- Do not rely only on your CI
  - It’s easy to run all tests or a single test during your development phase
  - Use git commit hooks to run tests

**Use your CI/CD**

- Unit test are just a single command line
- Integrate in your CI before the stage of build and deploy
- You wouldn’t deploy a mobile app without testing

##==##

<!-- .slide: class="with-code max-height"-->

# Example with gitlab CI

**gitlab-ci.yml**

```yaml
include:
  - project: data/common/ci-template
    ref: latest
    file:
      - stages/dbt-test.yml
      - stages/dbt-seed.yml
      - stages/deploy-dbt-image.yml
      - stages/deploy-dbt-docs.yml

dbt_unit_test_jobs:
  script:
    - !reference ['.dbt', 'script']
    - |
      if [ -n "$DBT_VARS_TEST" ]; then
        dbt_vars=" --vars '$(echo ''$DBT_VARS_TEST'')'"
      fi
    - eval "dbt test ${dbt_params}${dbt_vars} --select test_type:unit"
```

##==##

# Tests aren’t free

Each test may run one or several queries :

- Should all tests run every time ?

  - Test groups can benefit from custom scheduling
    - Daily, monthly, etc.

- Should whole table be tested or new partitions only ?

  - You can use conditions in tests
  - Leverage your adapter options to avoid invoice crisis

- Some tests can be avoided, or at least not repeated at each stage
  - Tested in staging, should you retest in intermediate and mart ?
