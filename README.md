Natural Earth for TM2
=====================

This project serves as an example for creating a relatively complex vector tile source in [TM2][] along with a visual style for that source. All data is from [Natural Earth][].

[TM2]: http://github.com/mapbox/tm2
[Natural Earth]: http://naturalearthdata.com

Requirements
------------

- PostgreSQL
- PostGIS >= 2.0
- GDAL (for `ogr2ogr`)
- basic Unix tools: bash, wget, unzip

This project has been tested on Ubuntu Linux and it should also work on Mac OS X. Windows is not yet supported.

Setup
-----

```sh
git clone git@github.com:mapbox/natural-earth-tm2.git
cd natural-earth-tm2
./util/setup_db.sh
```

__TODO__: configurable database connection. For now you'll need `postgres@localhost:5432` to connect, without a password.

Scales
------

Natural Earth comes in 3 scales. This project uses 1:110,000,000 for zoom levels 0 through 2, 1:50,000,000 for zoom levels 3 & 4, and 1:10,000,000 for zoom levels 5 and up. There are a few exceptions since some layers that are only available at 1:10,000,000 scale - notably roads.

PostgreSQL & PostGIS
--------------------

For creating anything more than basic vector tile sources, using a PostGIS data source is *highly recommended*. The flexible queries and spatial functions are very important for creating vector tile sources that are compact and easy to style.

### Zoom level conditionals

Mapnik's `!scale_denominator!` token along with a custom PostgreSQL function called `z` to let's us include different data at different zoom levels in the same vector tile layer. For example, the following in a `WHERE` clause will include only the most important objects at lower zoom levels, but include more and more as you zoom in:

```sql
CASE WHEN z(!scale_denominator!) = 4 AND scalerank <= 2 THEN TRUE
     WHEN z(!scale_denominator!) = 5 AND scalerank <= 4 THEN TRUE
     WHEN z(!scale_denominator!) >= 6 THEN TRUE  -- includes all data
     END
```

### Multiple tables in one layer

To simplify styling we sometimes combine multiple tables into a single layer query. We do this using a `UNION ALL` SQL statement. `UNION ALL` concatenates multiple queries together, but they all must have the same number of columns. If you want a column from one table that the other table does not have, you'll need to include a placeholder column in that query. In this example, that's the `'' AS name` part in the ocean query:

```sql
( SELECT geom, '' AS name FROM ne_10m_ocean
  UNION ALL
  SELECT geom, name FROM ne_10m_lakes
) AS data
```

In this project you'll also see multiple tables combined with zoom level conditionals in order to handle switching between Natural Earth's 3 data scales at different zoom levels.

### On-the-fly geometry transforms

Using PostGIS we're able to make geometry transformations at query time. For example you can buffer polygons, simplify lines, or derive centroid points.

Deriving points from polygons is especially important for vector tiles. Labeling polygons doesn't work like it did in TileMill 1 - with vector tiles a polygon might be split across many vector tiles, so if you try to label it directly you'll end up with lots of duplicate labels. Here we use PostGIS's `ST_PointOnSurface` function to derive a point layer for labeling a separate polygon layer.

```sql
( SELECT ST_PointOnSurface(geom) AS geom, name
  FROM ne_10m_lakes
) AS data
```
