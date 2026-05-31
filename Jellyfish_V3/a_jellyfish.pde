void jellyfish() {
  pushMatrix();

  float bellPulse = sin(t * PI); //-1~1
  float bellScale = 1.0 + bellPulse * 0.12; //0.88~1.12
  float offsetY = bellPulse * 30;

  translate(width / 2, height / 2 + offsetY, 0);
  //translate(jellyfishX, jellyfishY + offsetY, 0);
  blendMode(ADD);
  rotateX(-0.4);

  drawBell(bellScale);
  drawHalo(bellScale);
  //drawTentacles(bellScale);

  popMatrix();
}
