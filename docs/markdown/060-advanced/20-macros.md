<!-- .slide: class="transition"-->

# Advanced data transformation and control

## Macros

##==##

# Reusable code with macros

Macros are reusable blocks of code that can be defined and invoked within your dbt project.

- Code Reusability: provides consistency and reduce duplication

- Encapsulation of Logic: improve readability

- Dynamic SQL generation: SQL queries based on provided parameters or conditions

- Parameterization: use of parameters brings flexibility

- Modularity: macros can be organized into modules or files

##==##

<!-- .slide: class="with-code"-->

# Declaring macros

Macros are SQL files using a custom jinja-like syntax, kept in the macros directory and subdirectories.

If you have to repeat code logic or formulas more than once: use a macro.

_/macros/formulas/turnover.sql_

<!-- {% raw %} -->

```sql
{% macro turnover() %}
  (base_price * quantity - rebate)
{% endmacro %}

{% macro raw_turnover() %}
  (base_price * quantity)
{% endmacro %}
```

<!-- {% endraw %} -->

Notes:
Even if they are defined in SQL file, macro can also not produce any SQL output

##==##

<!-- .slide: class="with-code"-->

# Using macros

Using macros in your models is as simple as using variables.

The macro placeholders will be replaced by the generated SQL code at compilation time.

_models/sales.sql_

```sql
SELECT
  order_id
  , customer_id
  , order_date
  , {{ turnover() }} AS turnover -- Macro is used here
FROM {{ ref("sales") }}
WHERE TRUE
  {{ order_completed() }} -- Potential complex logic here
```

##==##

<!-- .slide: class="with-code"-->

# Using arguments in macros

You can create more complex logic in a single macro using arguments.

_/macros/formulas/turnover.sql_

<!-- {% raw %} -->

```sql
{% macro turnover(_include_rebate) %}
  (
    base_price * quantity
    {% if _include_rebate %}
    - rebate
    {% endif %}
  )
{% endmacro %}
```

<!-- {% endraw %} -->

_models/sales.sql_

```sql
SELECT
 *
 , {{ turnover(true) }} AS turnover
  FROM {{ ref("sales") }}
```

##==##

<!-- .slide: class="with-code"-->

# Documenting macros

Documenting macros is done using a YAML file:

- include a global description of the macro
- add a description of each argument of the macro

```yaml
macros:
  - name: i18n_compatible_name
    description: 'Compute a international-compatible name from a list of fields.'
  - name: turnover
    description: Compute turnover for each line in sales
    arguments:
      - name: _include_rebate
        type: bool
        description: Include rebate amount in the computation or not
```
