<!-- .slide -->

# Reusable code with macros

Macros are reusable blocks of code that can be defined and invoked within your _dbt_ project.

<br/>

- Code Reusability: provides consistency and reduce duplication
- Encapsulation of Logic: improve readability
- Dynamic SQL generation: SQL queries based on provided parameters or conditions
- Parameterization: use of parameters brings flexibility
- Modularity: macros can be organized into modules or files

##==##

<!-- .slide: class="with-code" -->

# Declaring macros

Macros are `SQL` files using a custom jinja-like syntax, kept in the `macros` directory and subdirectories.

If you have to repeat code logic or formulas more than once: use a macro.

<!-- {% raw %} -->

`/macros/formulas/turnover.sql`

```sql[]
{% macro turnover() %}
    (base_price * quantity - rebate)
{% endmacro %}

{% macro raw_turnover() %}
    (base_price * quantity)
{% endmacro %}
```

<!-- {% endraw %} -->

Notes:

- You can declare more than one macro in each file -- use it to regroup logic

##==##

<!-- .slide: class="with-code" -->

# Using macros

Using macros in your models is as simple as using variables.

The macro placeholders will be replaced by the generated SQL code at compilation time.

<!-- {% raw %} -->

`models/sales.sql`

```sql[]
SELECT
  order_id
  , customer_id
  , order_date
  , {{ turnover() }} AS turnover  -- Macro is used here
FROM {{ ref("sales") }}
WHERE TRUE
  {{ order_completed() }} -- Potential complex logic here
```

<!-- {% endraw %} -->

Notes:

<!-- {% raw %} -->

- Remember you can always use dbt compile to see the generated SQL.
- Use {%- (with dashes) to control the output
<!-- {% endraw %} -->

##==##

<!-- .slide: class="with-code" -->

# Using arguments in macros

You can create more complex logic in a single macro using arguments.

`/macros/formulas/turnover.sql`

<!-- {% raw %} -->

```sql[]
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

`models/sales.sql`

<!-- {% raw %} -->

```sql[]
SELECT
  *
  , {{ turnover(true) }} AS turnover
FROM {{ ref("sales") }}
```

<!-- {% endraw %} -->

##==##

<!-- .slide: class="with-code" -->

# Documenting macros

Documenting macros is done using a `YAML` file:

- include a global description of the macro
- add a description of each argument of the macro

<br/>

```yaml[]
macros:
  - name: i18n_compatible_name
    description: "Compute a international-compatible name from a list of fields."
  - name: turnover
    description: Compute turnover for each line in sales
    arguments:
        - name: _include_rebate
          type: bool
          description: Include rebate amount in the computation or not
```

Notes:

- It's a good practice to document macros !
- Declaring macros is optionnal, but it's always better to implicitely declare what you build
