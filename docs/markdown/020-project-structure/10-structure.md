<!-- .slide: class="two-column" -->

# Constraints

![sfeir-icons big](alert-triangle) **dbt** is mono-adapter

![sfeir-icons big](alert-triangle) **dbt** is SQL-only (or almost)

![sfeir-icons big](alert-triangle) Model and seed names are unique

![sfeir-icons big](alert-triangle) **dbt** will destroy and recreate models at each run

##--##

<!-- .slide: data-background="var(--black)"-->

# Best Practices

![sfeir-icons big](thumbs-up) Organize your files in folders

![sfeir-icons big](thumbs-up) Use tags

![sfeir-icons big](thumbs-up) Use prefix in file names

![sfeir-icons big](thumbs-up) **D**on't **R**epeat **Y**ourself

![sfeir-icons big](thumbs-up) Implement tests !

##==##

<!-- .slide: class="two-column" -->

# Project structure

There is a **_CLI_** to initialize your project skeleton:

- it will create your project folder and subfolders
- generate your `dbt_project.yml` file
- generate or update `profile.yml` file

<br/>

By default, _dbt_ looks for _**models**, **macros**, **seeds**, **tests**_, etc. in pre-defined directories .

<br/>
Next step: update the profile with adapter settings and credentials.

Notes:

- You can filter using paths in dbt commands + it's easier to read for future contributors
- Use macros, it's powerful !
- destroy / create unless incremental materialization

##--##

<!-- .slide: data-background="var(--black)" class="with-code"-->

# &nbsp;

```shell
# Create a "sfeir_institute" project
dbt init --profiles-dir ./ sfeir_institute

tree sfeir_institute
```

```markdown
sfeir_institute_dbt
├── README.md
├── analyses
├── dbt_project.yml
├── macros
├── models
│   └── example
│   ├── my_first_dbt_model.sql
│   ├── my_second_dbt_model.sql
│   └── schema.yml
├── seeds
├── snapshots
└── tests
```

<!-- .element: class="center" -->
<br/>

notes:

- make sure your don't push your profile on the repo...
- ...unless you use environment variables with `env_var()` jinja macro

Remember the –profiles-dir option when initializing the project.
