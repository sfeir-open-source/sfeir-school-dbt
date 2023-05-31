<!-- .slide: class="with-code"-->
# Models property file

Models properties can be declared in `.yml` files in your models/ directory.

<div>
Properties can be used to give your models:<br/>

* a description
* a tag or a list of tags
* a list of columns and their own properties
</div>
<!-- .element: class="fragment" -->

<br/><br/>
But also to declare **constraints** and **tests** !
<!-- .element: class="fragment" -->

Notes:
- It's good practice to prefix them with "__" to make sure they are listed first.

##==##
<!-- .slide: class="with-code"-->

# Sample model property file

`models/staging/__models.yml`
```
version: 2

models:
  - name: customers  # The name must match your .sql file name
    description: "Main customers table"
    config:
      materialized: table
      tags: ["sfeir", "school"]
    columns:
      - name: id
        tests:
          - not_null
      - name: name
  - name: products
  - name: orders
    ...
```

Notes:
- All fields must not be defined: dbt does not use field list to build SQL statements
- If a model property file references an inexisting model, dbt will output a warning
- On the other hand, a SQL model does not need to be declared in a property file
