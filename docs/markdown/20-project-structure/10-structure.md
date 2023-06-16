<!-- .slide -->
# Folders and files structure

dbt looks for _models_, _macros_ _seeds_, _tests_, etc. in specific directories by default

There is a **CLI** command to build your project skeleton:

- It will create your project folder and subfolders
- dbt_project.yml file
- a profile file (if it does not exist)

<br/><br/>
Next step: update the profile with adapter settings and credentials.

notes:
* make sure your don't push your profile on the repo...
* ...unless you use environment variables with `env_var()` jinja macro

##==##
<!-- .slide-->
# Constraints and best practices

**Constraints:**

* dbt is mono-adapter
* dbt is SQL-only
* Model and seed names are unique, project-wide
* dbt destroy and recreate your model at each run

<br/>

**Best practices:**

* Organize your files in folders
* Use tags
* Use prefix in file names
* **D**on't **R**epeat **Y**ourself
* Test !

Notes:
* You can filter using paths in dbt commands + it's easier to read for future contributors
* Use macros, it's powerful !
* destroy / create unless incremental materialization

##==##
<!-- .slide class="with-code"-->
# Initializing the project

```bash[]
# Create a "sfeir_school" project

dbt init sfeir_school_init
```

<br/>

![center h-400](./assets/images/docs/markdown/20-project-structure/tree.png)
