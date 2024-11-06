<!-- .slide: class="transition"-->

# Testing

## Unit tests

##==##

# What about testing models?

**What we can do so far:**

- test data quality in sources and models
- test structure of sources and models
- test the freshness of data using dbt source freshness

**What can we also do?**

Test dbt code and models generation by implementing unit-tests in dbt !

New in dbt 1.8+ : unit testing does not require an external package anymore.

<!-- .element: class="admonition warning" -->

Notes:
Soon : integrated unit tests in future version of dbt

##==##

# How does unit-testing work?

It's based on the assumption that you know:

- What data do you have as input ⇒ **mocks**
- What data do you want as output ⇒ **expects**

If the **expected** output of your dbt models does not match **mocks** of your input, then something is broken in your latest development and you should fix it.

Unit-testing should be used **before** deployment.

You **should not run unit test in production**, but in development phase only: use a filter in your production execution to avoid running unit tests.

```bash
$ dbt build --exclude-resource-type unit_test
```

##==##

<!-- .slide: class="with-code max-height"-->

# Example of unit-test

_models/unit_tests.yml_

```yaml
unit_tests:
  - name: test_is_valid_email
    description: 'Check email validity.'
    model: int_customers
    given:
      - input: ref('stg_customers')
        rows:
          - { email: sophie@sfeir.com, domain: sfeir.com }
          - { email: “mar c@sfeir.com”, domain: sfeir.com }
          - { email: thibault@yahoo.fr, domain: yahoo.fr }
      - input: ref('stg_domains')
        rows:
          - { domain: sfeir.com }
    expect:
      rows:
        - { email: sophie@sfeir.com, is_valid_email_address: true }
        - { email: “mar c@sfeir.com”, is_valid_email_address: false }
        - { email: thibault@yahoo.fr, is_valid_email_address: false }
```
