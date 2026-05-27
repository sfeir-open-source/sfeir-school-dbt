<!-- .slide: class="tc-multiple-columns" -->

##++##

# Constraints

![](alert-triangle 'tc-icons feather tc-big') **dbt** is mono-adapter (by project)

![](alert-triangle 'tc-icons feather tc-big') **dbt** models are SQL-only

![](alert-triangle 'tc-icons feather tc-big') Model and seed names are unique

![](alert-triangle 'tc-icons feather tc-big') **dbt** will destroy and recreate models at each run (default behavior)
##++##
##++## data-background="var(--black)" class="contrast-opposite"

# Best Practices

![](thumbs-up 'tc-icons feather tc-big') Organize your files in folders

![](thumbs-up 'tc-icons feather tc-big') Use tags

![](thumbs-up 'tc-icons feather tc-big') Use prefix in file names

![](thumbs-up 'tc-icons feather tc-big') **D**on't **R**epeat **Y**ourself

![](thumbs-up 'tc-icons feather tc-big') Implement tests !
##++##

##==##

<!-- .slide: class="tc-multiple-columns" -->

##++##

# Project structure

There is a **_CLI_** to initialize your project skeleton:

- it will create your project folder and subfolders
- generate your `dbt_project.yml` file
- generate or update `profiles.yml` file

<br/>

By default, _dbt_ looks for _**models**, **macros**, **seeds**, **tests**_, etc. in pre-defined directories .

<br/>
Next step: update the profile with adapter settings and credentials.
##++##
##++## data-background="var(--black)" class="with-code"

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

##++##

Notes:

- make sure your don't push your profile on the repo...
- ...unless you use environment variables with `env_var()` jinja macro

Remember the –profiles-dir option when initializing the project.

- You can filter using paths in dbt commands + it's easier to read for future contributors
- Use macros, it's powerful !
- destroy / create unless incremental materialization
