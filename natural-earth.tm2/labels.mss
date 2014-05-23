#country_labels {
  text-name: [name];
  text-face-name: "PT Sans Caption Regular";
  text-transform: uppercase;
  text-character-spacing: 1;
  text-placement: point;
  text-fill: #602;
  text-halo-fill: fadeout(#fff,90%);
  text-halo-radius: 2;
  text-halo-rasterizer: fast;
}

#places {
  text-name: [name];
  text-face-name: "PT Sans Regular";
  [scalerank<=1] { text-face-name: "PT Sans Bold"; }
  text-fill: #044;
  text-halo-radius: 2;
  text-halo-fill: fadeout(white,80%);
  text-halo-rasterizer: fast;
  [scalerank<=7] { text-size: 11; }
  [scalerank<=5] { text-size: 12; }
  [scalerank<=3] { text-size: 13; }
  [scalerank<=2] { text-size: 14; }
  [scalerank<=1] { text-size: 15; }
  [zoom=5] {
    [scalerank<=7] { text-size: 12; }
    [scalerank<=5] { text-size: 13; }
    [scalerank<=3] { text-size: 14; }
    [scalerank<=2] { text-size: 15; }
    [scalerank<=1] { text-size: 16; }
  }
  [zoom=6] {
    [scalerank<=7] { text-size: 13; }
    [scalerank<=5] { text-size: 14; }
    [scalerank<=3] { text-size: 16; }
    [scalerank<=2] { text-size: 17; }
    [scalerank<=1] { text-size: 18; }
  }
  [zoom>=7] {
    [scalerank<=8] { text-size: 14; }
    [scalerank<=7] { text-size: 15; }
    [scalerank<=5] { text-size: 16; }
    [scalerank<=4] { text-size: 17; }
    [scalerank<=3] { text-size: 18; }
    [scalerank<=2] { text-size: 19; }
    [scalerank<=1] { text-size: 20; }
  }
}