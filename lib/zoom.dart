class sizer {
  double x = 55;
  double y = 55;
}

sizer ZoomDrag(sizer z) {
  if (z.x == 25) {
    z.x = 55;
    z.x = 55;
  } else {
    z.x = 25;
    z.y = 27;
  }
  return z;
}
