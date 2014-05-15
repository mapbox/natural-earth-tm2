// NOTE: the current vector tile source for this style will not
// be around for long. Do not use it in other projects - export
// your own version from the 'natural-earth.tm2source' project.

// Common Colors //
@water_fill: #ace;
@water_line: #6af;

Map {
  background-color: #fff;
}

#water {
  polygon-fill: @water_fill;
  line-color: @water_line;
}

#admin_0_lines {
  line-width: 1;
  line-color: #644;
  [class='dispute'] { line-dasharray: 5,3; }
  [class='control'] { line-dasharray: 2,2; }
}

#ice {
  polygon-fill: #fff;
}

#playas {
  polygon-fill: #ffc;
  line-color: @water_line;
  line-dasharray: 5,3;
  [zoom<=6] {
    line-width: 0.5;
    line-dasharray: 4,2;
  }
}

#urban_areas {
  polygon-fill: #fff0b0;
}

#geographic_lines {
  line-color: #fff;
  line-dasharray: 6,2;
}

#roads::ferry[featurecla='Ferry'] {
  line-color: #6be;
  line-dasharray: 5,2;
}

#roads::road[featurecla='Road'] {
  line-color: #daa;
  line-width: 0.75;
  [type='Major Highway'] {
    [zoom>=5] { line-width: 1.2; }
    [zoom>=6] { line-width: 1.5; }
    [zoom>=7] { line-width: 1.8; }
  }
  [type='Secondary Highway'] {
    [zoom>=6] { line-width: 1; }
    [zoom>=7] { line-width: 1.2; }
    [zoom>=8] { line-width: 1.4; }
  }
}