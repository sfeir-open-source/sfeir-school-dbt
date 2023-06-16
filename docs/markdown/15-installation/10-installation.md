<!-- .slide: class="with-code"-->
# Simple installation

For the purpose of this school, we will:

* use PostgreSQL as our database
* use the latest version of dbt with PostgreSQL adapter

<br/><br/>
Installation is pretty straightforwardw, depending on your OS:

```shell[]
# MacOS, using brew
$ brew update
$ brew install git
$ brew tap dbt-labs/dbt
$ brew install dbt-postgres

# Using python pip
$ pip install dbt-postgres
```

##==##
<!-- .slide: class="with-code"-->
# Installation with docker

dbt convieniently provides public Docker images.
<br/><br/>

Tips: you should create an alias to run your images and mount volumes easily.
<br/><br/>

```shell[]
# Replace this code with correct paths and dbt image
$ docker run \
  --network=host \
  --mount type=bind,source=path/to/project,target=/usr/app \
  --mount type=bind,source=path/to/profiles.yml,target=/root/.dbt/ \
  <dbt_image_name> \
  run
```

Notes:
- even better: use a makefile
