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
wget --trust-server-names -qNP "$tmp" http://naciscdn.org/naturalearth/packages/natural_earth_vector.sqlite.zip
unzip -qjun -d "$tmp" "$tmp/natural_earth_vector.sqlite.zip"

echo "Importing Natural Earth to PostGIS..."
PGCLIENTENCODING=LATIN1 ogr2ogr \
    -progress \
    -f Postgresql \
    -s_srs EPSG:4326 \
    -t_srs EPSG:3857 \
    -clipsrc -180.1 -85.0511 180.1 85.0511 \
    PG:"dbname=$dbname user=$dbuser host=$dbhost port=$dbport" \
    -lco GEOMETRY_NAME=geom \
    -lco DIM=2 \
    -nlt GEOMETRY \
    "$tmp/natural_earth_vector.sqlite"

echo "Post-processing..."

# Because polygons can get split up between many vector tiles, in order to
# draw labels we'll want to pre-calculate label positions for polygons as
# points. This section creates additional geometry columns for polygon 
# layers we'll want to label, plus additional indexes.
#
# This could also be done as part of the SQL queries in the TM2 project, but
# doing it beforehand cuts down on export time.

tables=('ne_110m_admin_0_countries'
        'ne_50m_admin_0_countries'
        'ne_10m_admin_0_countries'
        'ne_110m_admin_1_states_provinces_shp'
        'ne_50m_admin_1_states_provinces_shp'
        'ne_10m_admin_1_states_provinces_shp'
    )

for table in ${tables[@]}; do
    $psql --single-transaction --dbname=$dbname --quiet --command="
        ALTER TABLE $table ADD COLUMN geom_point geometry(point);
        UPDATE $table SET geom_point = ST_PointOnSurface(ST_MakeValid(geom));
        CREATE INDEX ${table}_geom_point ON $table USING gist (geom_point);"
done

echo "Done."
