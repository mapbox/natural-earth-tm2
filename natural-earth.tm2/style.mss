// NOTE: the current vector tile source for this style will not
// be around for long. Do not use it in other projects - export
// your own version from the 'natural-earth.tm2source' project.

// Common Colors //
@water_fill: #adf;
@water_line: #48d;

Map {
  background-color: #fff;
}

#water {
  polygon-fill: @water_fill;
  line-color: @water_line;
  line-join: round;
  line-width: 0.8;
  [zoom>=4] { line-width: 1; }
  [zoom>=6] { line-width: 1.2; }
}

#admin_0_lines[zoom>=1] {
  line-width: 0.6;
  line-color: #644;
  [class='dispute'] { line-dasharray: 5,3; }
  [class='control'] { line-dasharray: 2,2; }
  [zoom>=2] { line-width: 1; }
  [zoom>=6] { line-width: 1.2; }
}

#admin_1_lines[zoom>=1] {
  line-width: 0.8;
  line-color: #aaa;
  line-dasharray: 3,1;
}

#ice {
  opacity: 0.5;
  polygon-fill: #eff;
  line-color: #8de;
  line-join: round;
  line-dasharray: 5,1;
}

#playas {
  polygon-fill: #f8f8e8;
  line-color: @water_line;
  line-dasharray: 5,3;
  [zoom<=6] {
    line-width: 0.5;
    line-dasharray: 4,2;
  }
}

#urban_areas {
  polygon-fill: #800;
  polygon-opacity: 0.075;
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
  line-color: #fff;
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

@mix_col: #fff;
@mix_amt: 15;
#country_fill {
  [color=1] { polygon-fill: mix(#D19C44,@mix_col,@mix_amt); }
  [color=2] { polygon-fill: mix(#99AF4D,@mix_col,@mix_amt); }
  [color=3] { polygon-fill: mix(#5AB87B,@mix_col,@mix_amt); } 
  [color=4] { polygon-fill: mix(#2CB8B2,@mix_col,@mix_amt); }
  [color=5] { polygon-fill: mix(#BB99CF,@mix_col,@mix_amt); } 
  [color=6] { polygon-fill: mix(#EE85A7,@mix_col,@mix_amt); } 
  [color=7] { polygon-fill: mix(#F78571,@mix_col,@mix_amt); }
  ::band[zoom>=1] {
    comp-op: overlay;
    line-color: #000;
    line-join: round;
    line-width: 3;
    [zoom>=2] { line-width: 4; }
    [zoom>=4] { line-width: 6; }
    [zoom>=6] { line-width: 8; }
  }
  ::band2[zoom>=1] {
    comp-op: overlay;
    line-color: #000;
    line-join: round;
    line-width: 6;
    [zoom>=2] { line-width: 8; }
    [zoom>=4] { line-width: 12; }
    [zoom>=6] { line-width: 16; }
  }
}