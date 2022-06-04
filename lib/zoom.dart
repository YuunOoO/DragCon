class sizer {
  double x = 55;
  double y = 55;
  double x2 = 6;
  get z => null;
}

sizer ZoomDrag(sizer z) {
  if (z.x == 32) {
    z.x = 55;
    z.y = 55;
    z.x2 = 15;
  } else {
    z.x = 32;
    z.y = 32;
    z.x2 = 10;
  }
  return z;
}
