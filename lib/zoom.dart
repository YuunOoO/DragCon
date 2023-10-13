class TileSizer {
  double x = 45;
  double y = 45;
  double x2 = 6;
  get z => null;
}

TileSizer zoomDrag(TileSizer z) {
  if (z.x == 32) {
    z.x = 45;
    z.y = 45;
    z.x2 = 15;
  } else {
    z.x = 32;
    z.y = 32;
    z.x2 = 10;
  }
  return z;
}
