<!-- .slide: class="with-code"-->
# Simple installation

For the purpose of this school, we will use:

* [PostgreSQL](https://www.postgresql.org/) as database
* the [latest version](https://docs.getdbt.com/docs/dbt-versions/core) of dbt with [PostgreSQL adapter](https://docs.getdbt.com/docs/core/connect-data-platform/postgres-setup)

<br/><br/>
Installation is pretty straightforward, depending on your OS:

- MacOS user can easily do it with [brew](https://brew.sh/)
```shell[]
$ brew update
$ brew install git
$ brew tap dbt-labs/dbt
$ brew install dbt-postgres
```
- Otherwise, you can use `pip`
```shell[]
$ pip install dbt-postgres
```

##==##
<!-- .slide: class="with-code"-->
# Installation with docker

*dbt* conveniently provides public Docker images.
<br/><br/>

***Tips:*** you should create an alias to run your images and mount volumes easily.
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
