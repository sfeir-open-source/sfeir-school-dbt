<!-- .slide -->
# Reusable code with macros

Macros are reusable blocks of code that can be defined and invoked within your dbt project.

<br/>

* Code Reusability: provides consistency and reduce duplication
* Encapsulation of Logic: Improve readability
* Dynamic SQL Generation: SQL queries based on provided parameters or conditions
* Parameterization: use of parameters brings flexibility
* Modularity: macros can be organized into modules or files

##==##
<!-- .slide: class="with-code" -->
# Declaring macros

Macros are `SQL` files using a custom jinja-like syntax, kept in the `macros` directory and subdirectories.

Documenting macros is done using a `YAML` file:
* include a global description of the macro
* add a description of each argument of the macro

<br/>

```yaml[]
macros:
  - name: i18n_compatible_name
    description: "Compute a international-compatible name from a list of fields."
  - name: compute_volume
    description: Compute daily beer consumption in bottle-equivalent
    arguments:
        - name: is_friday
          type: bool
        - name: base_volume
          type: integer
          description: Default volume of a bottle
```

Notes:
* It's a good practice to document macros !
* Declaring macros is optionnal, but it's always better to implicitely declare what you build
