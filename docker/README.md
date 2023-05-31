## Environment for Postgres

Default user/password avec set in the .env-dist file: just create a symlink to this file in the same directory to use these default credentials.

```bash
ln -sfn .env-dist .env
```

## About the dbt image

The dbt image is included in the docker-compose.yml file but is not started as a service. It's here to make the whole pulling process easier only.

## Starting whole environment

Simply start or stop the whole environment using these docker commands:

```bash
# Start
docker-compose up

# Stop
docker-compose down
```
