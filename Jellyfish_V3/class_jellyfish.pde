class Jellyfish {

  float x;
  float y;
  float vx;
  float vy;

  float maxSpeed = 3;

  float[] myTentacleOffset;
  float[] myTentacleOffset2;

  float[] myTentacleWidth  = new float[6];
  float[] myTentacleLength = new float[6];
  float[] myTentacleWidth2  = new float[12];
  float[] myTentacleLength2 = new float[12];

  Jellyfish() {
    x = random(width);
    y = random(height);
    vx = random(-maxSpeed, maxSpeed);
    vy = random(-maxSpeed, maxSpeed);

    myTentacleOffset = new float[tentacleCount];
    myTentacleOffset2 = new float[tentacleCount2];
    for (int idx = 0; idx < tentacleCount; idx++) {
      myTentacleOffset[idx] = random(0, 100);
      myTentacleWidth[idx]  = random(3, 10);
      myTentacleLength[idx] = random(80, 150);
    }
    for (int idx2 = 0; idx2 < tentacleCount2; idx2++) {
      myTentacleOffset2[idx2] = random(0, 100);
      myTentacleWidth2[idx2]  = random(5, 8);
      myTentacleLength2[idx2] = random(150, 200);
    }
  }

  void display() {
    pushMatrix();

    float bellPulse = sin(t * PI); //-1~1
    float bellScale = 1.0 + bellPulse * 0.12; //0.88~1.12
    float offsetY = bellPulse * 20;

    translate(x, y + offsetY, 0);
    blendMode(ADD);
    rotateX(-0.4);

    drawBell(bellScale);
    drawHalo(bellScale);
    drawTentacles(bellScale);

    popMatrix();
  }

  void update() {
    x += vx;
    if (x >= width || x < 0) {
      vx *= -1;
    }

    y += vy;
    if (y >= height || y < 0) {
      vy *= -1;
    }

    vx = constrain(vx, -4, 4);
    vy = constrain(vy, -4, 4);

    separate(jellyfishes);
    align(jellyfishes);
  }

  void separate(Jellyfish[] others) {
    for (int i = 0; i < jellyfishCount; i++) {
      if (others[i] != this) {
        float dx = x - others[i].x;
        float dy = y - others[i].y;
        float dist = sqrt(sq(dx) + sq(dy));
        float nx = dx / dist;
        float ny = dy / dist;
        if (dist <= 100) {
          vx += (nx * maxSpeed - vx) * 0.1;
          vy += (ny * maxSpeed - vy) * 0.1;
        }
      }
    }
  }

  void align(Jellyfish[] others) {
    float sumVx = 0;
    float sumVy = 0;
    float count = 0;

    for (int i = 0; i < jellyfishCount; i++) {
      if (others[i] != this) {
        float dx = x - others[i].x;
        float dy = y - others[i].y;
        float dist = sqrt(sq(dx) + sq(dy));
        if (dist < 150) {
          count += 1;
          sumVx += others[i].vx;
          sumVy += others[i].vy;
        }
      }
    }
    if (count > 0) {
      float aveVx = sumVx / count;
      float aveVy = sumVy / count;
      vx += (aveVx - vx) * 0.05;
      vy += (aveVy - vy) * 0.05;
    }
  }
  void drawTentacles(float bellScale) {

    float radius = 50;

    //inner ring
    int tentacleIndex = 0;
    int segments = 35;

    //for (int r1 = 0; r1 <= 1 && tentacleIndex < tentacleCount; r1 += 50) {
    for (int j1 = 0; j1 <= 100 && tentacleIndex < tentacleCount; j1 += 20) {

      float phi1 = HALF_PI;
      float theta1 = map(j1, 0, 100, 0, TWO_PI);

      float x1 = 10 * bellScale * sin(phi1) * cos(theta1);
      float y1 = -10 * cos(phi1);
      float z1 = 10 * bellScale * sin(phi1) * sin(theta1);

      float px = x1, py = y1, pz = z1;

      for (int s = 1; s <= segments; s++) {
        float ratio = (float) s / segments;

        float noiseX = noise(myTentacleOffset[tentacleIndex] + t, ratio * 2);
        float noiseZ = noise(myTentacleOffset[tentacleIndex] + 50 + t, ratio * 2);
        float swayX = map(noiseX, 0, 1, -30, 30) * ratio;
        float swayZ = map(noiseZ, 0, 1, -30, 30) * ratio;

        float nx = x1 + swayX;
        float ny = y1 + myTentacleLength[tentacleIndex] * ratio;
        float nz = z1 + swayZ;

        strokeWeight(myTentacleWidth[tentacleIndex] * (1.0 - ratio * 0.7));
        stroke(100, 0, 255, map(ratio, 0, 1, 40, 5));
        line(px, py, pz, nx, ny, nz);

        px = nx;
        py = ny;
        pz = nz;
      }
      tentacleIndex++;
    }
    //}


    //outer ring
    int tentacleIndex2 = 0;
    int segments2 = 40;

    for (int r1 = 0; r1 <= 50 && tentacleIndex2 < tentacleCount2; r1 += 10) {
      for (int j1 = 0; j1 <= 100 && tentacleIndex2 < tentacleCount2; j1 += 10) {

        float phi1 = HALF_PI; //all tentacles grow from equator
        float theta1 = map(j1, 0, 100, 0, TWO_PI);

        float x1 = 50 * bellScale * sin(phi1) * cos(theta1);
        float y1 = -r1 * cos(phi1);
        float z1 = r1 * bellScale * sin(phi1) * sin(theta1);

        float px = x1, py = y1, pz = z1;

        for (int s = 1; s <= segments2; s++) {
          float ratio = (float) s / segments2;

          float noiseX = noise(myTentacleOffset2[tentacleIndex2] + t, ratio * 2);
          float noiseZ = noise(myTentacleOffset2[tentacleIndex2] + 50 + t, ratio * 2);
          float swayX = map(noiseX, 0, 1, -30, 30) * ratio;
          float swayZ = map(noiseZ, 0, 1, -30, 30) * ratio;

          float nx = x1 + swayX;
          float ny = y1 + myTentacleLength2[tentacleIndex2] * ratio;
          float nz = z1 + swayZ;

          strokeWeight(myTentacleWidth2[tentacleIndex2] * (1.0 - ratio * 0.7));
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
}
