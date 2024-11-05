<!-- .slide: class="with-code"-->

# Installing dbt

## Simple installation

Installation is pretty straightforward, depending on your OS:

Use pip, <del>preferably</del> mandatorily in a virtual environment:

```shell
$ mkdir sfeir-institute-dbt
$ python3 -m venv dbt-env
$ source dbt-env/bin/activate
$ pip install dbt-core dbt-postgres
$ dbt --version
```

MacOS user can easily do it with [brew](https://brew.sh/) :

```shell
$ brew update
$ brew install git
$ brew tap dbt-labs/dbt
$ brew install dbt-postgres
```

##==##

# Other options

## Use a virtual machine

If you can’t run python or install new packages, use a VM with python and install dbt with pip in a virtual environment.

- Light and ephemeral
- Does not need a lot of resources
- Your database actually does the work

**… or use dbt cloud**

##==##

<!-- .slide: class="with-code"-->

# Installing dbt

## Installation with docker

_dbt_ conveniently provides public Docker images.
<br/><br/>

```shell
# Replace this code with correct paths and dbt image
$ docker run \
  --network=host \
  --mount type=bind,source=path/to/project,target=/usr/app \
  --mount type=bind,source=path/to/profiles.yml,target=/root/.dbt/ \
  <dbt_image_name> \
  run
```

<br/>

![sfeir-icons big](alert-circle) <span style="vertical-align:top">You should create an alias to run your images and mount volumes easily.</span>

Notes:

- even better: use a makefile
