void drawTentacles(float bellScale) {

  //inner ring
  int tentacleIndex = 0;
  int segments = 35;

  for (int r1 = 0; r1 <= 100 && tentacleIndex < tentacleCount; r1 += 40) {
    for (int j1 = 0; j1 <= 100 && tentacleIndex < tentacleCount; j1 += 40) {

      float phi1 = HALF_PI;
      float theta1 = map(j1, 0, 100, 0, TWO_PI);

      float x1 = r1 * bellScale * sin(phi1) * cos(theta1);
      float y1 = -r1 * cos(phi1);
      float z1 = r1 * bellScale * sin(phi1) * sin(theta1);

      float px = x1, py = y1, pz = z1;

      for (int s = 1; s <= segments; s++) {
        float ratio = (float) s / segments;

        float noiseX = noise(tentacleOffset[tentacleIndex] + t, ratio * 2);
        float noiseZ = noise(tentacleOffset[tentacleIndex] + 50 + t, ratio * 2);
        float swayX = map(noiseX, 0, 1, -30, 30) * ratio;
        float swayZ = map(noiseZ, 0, 1, -30, 30) * ratio;

        float nx = x1 + swayX;
        float ny = y1 + tentacleLength[tentacleIndex] * ratio;
        float nz = z1 + swayZ;

        strokeWeight(tentacleWidth[tentacleIndex] * (1.0 - ratio * 0.7));
        stroke(100, 0, 255, map(ratio, 0, 1, 40, 5));
        line(px, py, pz, nx, ny, nz);

        px = nx;
        py = ny;
        pz = nz;
      }
      tentacleIndex++;
    }
  }


  //outer ring
  int tentacleIndex2 = 0;
  int segments2 = 40;

  for (int r1 = 0; r1 <= 100 && tentacleIndex2 < tentacleCount2; r1 += 10) {
    for (int j1 = 0; j1 <= 100 && tentacleIndex2 < tentacleCount2; j1 += 10) {

      float phi1 = HALF_PI; //all tentacles grow from equator
      float theta1 = map(j1, 0, 100, 0, TWO_PI);

      float x1 = 150 * bellScale * sin(phi1) * cos(theta1);
      float y1 = -r1 * cos(phi1);
      float z1 = r1 * bellScale * sin(phi1) * sin(theta1);

      float px = x1, py = y1, pz = z1;

      for (int s = 1; s <= segments2; s++) {
        float ratio = (float) s / segments2;

        float noiseX = noise(tentacleOffset2[tentacleIndex2] + t, ratio * 2);
        float noiseZ = noise(tentacleOffset2[tentacleIndex2] + 50 + t, ratio * 2);
        float swayX = map(noiseX, 0, 1, -30, 30) * ratio;
        float swayZ = map(noiseZ, 0, 1, -30, 30) * ratio;

        float nx = x1 + swayX;
        float ny = y1 + tentacleLength2[tentacleIndex2] * ratio;
        float nz = z1 + swayZ;

        strokeWeight(tentacleWidth2[tentacleIndex2] * (1.0 - ratio * 0.7));
        stroke(50, 0, 255, map(ratio, 0, 1, 80, 20));
        line(px, py, pz, nx, ny, nz);

        px = nx;
        py = ny;
        pz = nz;
      }
      tentacleIndex2++;
    }
  }
}
