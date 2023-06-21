<!-- .slide: class="two-column" -->
# Project structure

There is a ***CLI*** to initialize your project skeleton:

- it will create your project folder and subfolders
- generate your `dbt_project.yml` file
- generate a profile file (if it does not exist)

<br/>
<br/>

By default, *dbt* looks for _models_, _macros_, _seeds_, _tests_, etc. in pre-defined directories .

<br/><br/>
Next step: update the profile with adapter settings and credentials.

##--##
<!-- .slide: data-background="var(--black)"-->
# &nbsp;

```shell[]
sfeir_school_dbt
├── README.md
├── analyses
├── dbt_project.yml
├── macros
├── models
│   └── example
│       ├── my_first_dbt_model.sql
│       ├── my_second_dbt_model.sql
│       └── schema.yml
├── seeds
├── snapshots
└── tests
```
<!-- .element: class="center" -->
<br/>

notes:
* make sure your don't push your profile on the repo...
* ...unless you use environment variables with `env_var()` jinja macro

##==##
<!-- .slide: class="two-column" -->
# Constraints

![sfeir-icons](alert-triangle) _dbt_ is mono-adapter

![sfeir-icons](alert-triangle) _dbt_ is SQL-only

![sfeir-icons](alert-triangle) Model and seed names are unique and project-wide

![sfeir-icons](alert-triangle) _dbt_ will destroy and recreate models at each run


##--##
<!-- .slide: data-background="var(--black)"-->
# Best practices

![sfeir-icons](thumbs-up) Organize your files in folders

![sfeir-icons](thumbs-up) Use tags

![sfeir-icons](thumbs-up) Use prefix in file names

![sfeir-icons](thumbs-up) **D**on't **R**epeat **Y**ourself

![sfeir-icons](thumbs-up) Test !


Notes:
* You can filter using paths in dbt commands + it's easier to read for future contributors
* Use macros, it's powerful !
* destroy / create unless incremental materialization

##==##
<!-- .slide class="with-code"-->
# Initializing the project

```bash[]
# Create a "sfeir_school_init" project

dbt init sfeir_school_init
```

<br/>

![center h-400](./assets/images/docs/markdown/20-project-structure/tree.png)
