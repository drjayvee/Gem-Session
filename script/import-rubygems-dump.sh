#!/bin/bash

# This script is an alternative to the rubygems.org repo's script/load-pg-dump.sh
# That script depends on the Postgres CLI being installed, which I don't have or want.
#
# To use this script, start the repo's containers using `docker compose up -d`.
# Next, download and extract the database dump to its default location.
#
# You'll need to run this from the rubygems.org repo's root.

docker compose exec db dropdb -U postgres rubygems_development
docker compose exec db createdb -U postgres rubygems_development
docker compose exec db psql -U postgres -d rubygems_development -c "CREATE EXTENSION IF NOT EXISTS hstore;"

rake db:migrate

docker compose exec db psql -U postgres -d rubygems_development -c "DROP TABLE IF EXISTS dependencies, gem_downloads, linksets, rubygems, versions CASCADE;"

zcat public_postgresql/databases/PostgreSQL.sql.gz |docker compose exec -T db psql rubygems_development postgres
