void drawHalo(float bellScale) {
  int totalPhi = 40; //latitude
  int totalTheta = 80; //longtitude
  float radius = 50;

  float haloExpand = map(bellScale, 0.88, 1.12, 5, 20);
  float haloRadius = radius + haloExpand;

  float haloMaxAlpha = map(haloRadius, 55, 70, 80, 20);

  for (int haloLayer = 0; haloLayer < 4; haloLayer++) {
    float haloLayerRadius = haloRadius + haloLayer * 2;
    for (int i = 0; i < totalPhi; i++) {
      float phi0 = map(i, 0, totalPhi, 0, HALF_PI);
      float phi1 = map(i + 1, 0, totalPhi, 0, HALF_PI);

      beginShape(TRIANGLE_STRIP);

      for (int j = 0; j <= totalTheta; j++) {
        float theta = map(j, 0, totalTheta, 0, TWO_PI);

        float haloX0 = haloLayerRadius * bellScale * sin(phi0) * cos(theta);
        float haloY0 = -haloLayerRadius * cos(phi0);
        float haloZ0 = haloLayerRadius * bellScale * sin(phi0) * sin(theta);

        float haloX1 = haloLayerRadius * bellScale * sin(phi1) * cos(theta);
        float haloY1 = -haloLayerRadius * cos(phi1);
        float haloZ1 = haloLayerRadius * bellScale * sin(phi1) * sin(theta);

        float ratioTopHalo = (float) i / totalPhi;
        float ratioBotHalo = (float) (i+1) / totalPhi;
        float alphaTopHalo = haloMaxAlpha * pow(1.0 - ratioTopHalo * 0.8, 2);
        float alphaBotHalo = haloMaxAlpha * pow(1.0 - ratioBotHalo * 0.8, 2);

        fill(0, 0, 200, alphaTopHalo);
        vertex(haloX0, haloY0, haloZ0);

        fill(0, 0, 200, alphaBotHalo);
        vertex(haloX1, haloY1, haloZ1);
      }
      endShape();
    }
  }
}
