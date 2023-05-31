<!-- .slide -->
# Folders and files structure

dbt looks for models, seeds, tests, etc. in specific directories by default, and provides a CLI command to build your project skeleton.

It will create your project folder, dbt_project.yml file and profile, as well as required directories.

All you need to do then is update your profile with credentials.

<br/>
Tips:<br/>

* make sure your don't push your profile on the repo...
* unless you use environment variables with `env_var()` jinja macro


##==##
<!-- .slide class="with-code"-->
# Initializing the project

```bash
# Create a "sfeir_school" project

dbt init sfeir_school
```
