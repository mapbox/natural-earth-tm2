Natural Earth for TM2
=====================

This project provides a usable [TM2][] vector tiles source using data from [Natural Earth][], and also serves as an example/template for creating your own complex vector tiles source.

[TM2]: http://github.com/mapbox/tm2
[Natural Earth]: http://naturalearthdata.com

Requirements
------------

This project is developed primarily on Ubuntu Linux and it should also work on Mac OS X. Windows is not yet supported.

- PostgreSQL
- PostGIS >= 2.0
- GDAL (for `ogr2ogr`)
- basic Unix utils: bash, wget, unzip

Setup
-----

```sh
git clone <url>
cd natural-earth.tm2source
./setub_db.sh
```

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
