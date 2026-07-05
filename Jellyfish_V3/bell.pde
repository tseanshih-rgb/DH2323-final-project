void drawBell(float bellScale) {

  int totalPhi = 40;
  int totalTheta = 80;
  
  float radius = 50;

  float maxAlpha = map(bellScale, 0.88, 1.12, 100, 50);

  noStroke();

  for (int layer = 0; layer < 6; layer++) {
    float layerRadius = radius + layer * 3;
    for (int i = 0; i < totalPhi; i++) {
      float phi0 = map(i, 0, totalPhi, 0, HALF_PI);
      float phi1 = map(i + 1, 0, totalPhi, 0, HALF_PI);

      beginShape(TRIANGLE_STRIP);

      for (int j = 0; j <= totalTheta; j++) {
        float theta = map(j, 0, totalTheta, 0, TWO_PI);

        float x0 = layerRadius * bellScale * sin(phi0) * cos(theta);
        float y0 = -layerRadius * cos(phi0);
        float z0 = layerRadius * bellScale * sin(phi0) * sin(theta);

        float nx0 = sin(phi0) * cos(theta);
        float ny0 = -cos(phi0);
        float nz0 = sin(phi0) * sin(theta);

        float x1 = layerRadius * bellScale * sin(phi1) * cos(theta);
        float y1 = -layerRadius * cos(phi1);
        float z1 = layerRadius * bellScale * sin(phi1) * sin(theta);

        float nx1 = sin(phi1) * cos(theta);
        float ny1 = -cos(phi1);
        float nz1 = sin(phi1) * sin(theta);

        PVector lightDir0 = new PVector(-x0, 300-y0, 500-z0);
        lightDir0.normalize();
        PVector n0 = new PVector(nx0, ny0, nz0);
        float lightDot0 = n0.dot(lightDir0);
        float sss0 = map(lightDot0, -1, 0, 1, 0);
        sss0 = max(sss0, 0);

        PVector lightDir1 = new PVector(-x1, 300-y1, 500-z1);
        lightDir1.normalize();
        PVector n1 = new PVector(nx1, ny1, nz1);
        float lightDot1 = n1.dot(lightDir1);
        float sss1 = map(lightDot1, -1, 0, 1, 0);
        sss1 = max(sss1, 0);

        float R0 = 0.001;
        float cosTheta0 = nz0;
        float cosTheta1 = nz1;
        float fresnel0 = R0 + (1-R0) * pow(1 - max(cosTheta0, 0), 5);
        float fresnel1 = R0 + (1-R0) * pow(1 - max(cosTheta1, 0), 5);

        float ratioTopBell = (float) i / totalPhi;
        float ratioBotBell = (float) (i+1) / totalPhi;
        float alphaTopBell = maxAlpha * pow(1.0 - ratioTopBell * 0.9, map(fresnel0, 0.02, 1, 2, 0));
        float alphaBotBell = maxAlpha * pow(1.0 - ratioBotBell * 0.9, map(fresnel1, 0.02, 1, 2, 0));

        fill(map(fresnel0, 0, 1, 150, 180) + sss0 * 180, map(fresnel0, 0, 1, 100, 180) + sss0 * 200, 200, alphaTopBell);
        normal(nx0, ny0, nz0);
        vertex(x0, y0, z0);

        fill(map(fresnel1, 0, 1, 150, 180) + sss1 * 180, map(fresnel1, 0, 1, 100, 180) + sss1 * 200, 200, alphaBotBell);
        normal(nx1, ny1, nz1);
        vertex(x1, y1, z1);
      }
      endShape();
    }
  }
}
