#!/usr/bin/env bash
set -eu

# This script will download the full set of Natural Earth data in SQLite
# format and load it into a PostGIS-enabled PostgreSQL database, projecting
# the data to Web Mercator (EPSG:3857) at the same time.

# Database connection settings - edit as needed:
dbname=natural_earth
dbuser=postgres
dbhost=localhost
dbport=5432

psql="psql -q -h $dbhost -p $dbport -U $dbuser"

tmp="${TEMP:-/tmp}"

echo "Setting up PostGIS database..."
#$psql -c "drop database $dbname;" || true  # useful to uncomment during dev
$psql -c "create database $dbname"
$psql -d $dbname -c "create extension postgis;"
$psql -d $dbname -f "$(dirname $0)/functions.sql"

echo "Downloading Natural Earth Data (213MB)..."
wget --trust-server-names -qNP "$tmp" http://kelso.it/x/nesqlite
unzip -qjun -d "$tmp" "$tmp/natural_earth_vector.sqlite.zip"

echo "Importing Natural Earth to PostGIS..."
PGCLIENTENCODING=LATIN1 ogr2ogr \
    -progress \
    -f Postgresql \
    -s_srs EPSG:4326 \
    -t_srs EPSG:3857 \
    -clipsrc -180 -85.0511 180 85.0511 \
    PG:"dbname=$dbname user=$dbuser host=$dbhost port=$dbport" \
    -lco GEOMETRY_NAME=geom \
    -lco DIM=2 \
    -nlt GEOMETRY \
    "$tmp/natural_earth_vector.sqlite"

echo "Done."
