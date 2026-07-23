class Jellyfish {

  float x;
  float y;
  float vx;
  float vy;
  float ax;
  float ay;

  float maxSpeed = 0.8;
  float currentHeading;
  float turnRate = 0.05;
  float size;
  float depth;

  float phase;
  float period;
  float prevC = 0;
  float cGlobal = 0;
  float thrustJitter = 1.0;
  float thrustSmooth = 0;

  float offsetY = 0;

  float[] myTentacleOffset;
  float[] myTentacleOffset2;

  float[] myTentacleWidth;
  float[] myTentacleLength;
  float[] myTentacleWidth2;
  float[] myTentacleLength2;

  float[] nodeX = new float[41];
  float[] nodeY = new float[41];
  float[] nodeZ = new float[41];

  Jellyfish() {
    x = random(width);
    y = random(height);
    vx = random(-maxSpeed, maxSpeed);
    vy = random(-maxSpeed, maxSpeed);
    currentHeading = atan2(vy, vx) + HALF_PI;
    depth = random(0, 1);
    size = map(depth, 0, 1, 1.15, 0.7) * random(0.9, 1.1);
    phase = random(1);
    period = random(2.3, 2.9);

    myTentacleOffset = new float[tentacleCount];
    myTentacleWidth  = new float[tentacleCount];
    myTentacleLength = new float[tentacleCount];
    myTentacleOffset2 = new float[tentacleCount2];
    myTentacleWidth2  = new float[tentacleCount2];
    myTentacleLength2 = new float[tentacleCount2];
    for (int idx = 0; idx < tentacleCount; idx++) {
      myTentacleOffset[idx] = random(0, 100);
      myTentacleWidth[idx]  = random(8, 13);
      myTentacleLength[idx] = random(90, 150);
    }
    for (int idx2 = 0; idx2 < tentacleCount2; idx2++) {
      myTentacleOffset2[idx2] = random(0, 100);
      myTentacleWidth2[idx2]  = random(1.5, 3.5);
      myTentacleLength2[idx2] = random(150, 200);
    }
  }

  void display() {
    pushMatrix();

    translate(x, y, 0);
    rotateZ(currentHeading);
    scale(size);
    translate(0, offsetY, 0);

    drawBell(phase, depth);
    drawHalo(phase, depth);
    drawTentacles();

    popMatrix();
  }

  void flock() {
    ax = 0;
    ay = 0;

    separate(jellyfishes);
    align(jellyfishes);
    cohesion(jellyfishes);
    seekMouse();
    flee();

    float margin = 150;
    if (x < margin)          ax += 0.06;
    if (x > width - margin)  ax -= 0.06;
    if (y < margin)          ay += 0.06;
    if (y > height - margin) ay -= 0.06;
  }

  void update() {
    vx += ax;
    vy += ay;

    float speed = sqrt(sq(vx) + sq(vy));
    if (speed > maxSpeed) {
      vx = vx / speed * maxSpeed;
      vy = vy / speed * maxSpeed;
    }

    float dt = min(1.0 / max(frameRate, 1), 1.0 / 30);
    float prevPhase = phase;
    phase = wrap01(phase + dt / period);
    if (phase < prevPhase) thrustJitter = random(0.85, 1.15);

    cGlobal = contractionAt(phase);
    float dc = cGlobal - prevC;
    prevC = cGlobal;

    offsetY = lerp(offsetY, (0.5 - cGlobal) * 20, 0.15);

    float thrustRaw = max(dc, 0) * 12 * thrustJitter;
    if (thrustRaw > thrustSmooth) {
      thrustSmooth += (thrustRaw - thrustSmooth) * 0.5;
    } else {
      thrustSmooth += (thrustRaw - thrustSmooth) * 0.06;
    }

    x += vx * (0.4 + thrustSmooth) + currentVX;
    y += vy * (0.4 + thrustSmooth) + currentVY;

    if (x >= width || x < 0) {
      vx *= -1;
      x = constrain(x, 0, width);
    }
    if (y >= height || y < 0) {
      vy *= -1;
      y = constrain(y, 0, height);
    }
    
    float dirX = vx + currentVX;
    float dirY = vy + currentVY;
    float dirSpeed = sqrt(sq(dirX) + sq(dirY));
    
    float targetHeading = atan2(dirY, dirX) + HALF_PI;
    float diff = targetHeading - currentHeading;

    while (diff > PI)  diff -= TWO_PI;
    while (diff < -PI) diff += TWO_PI;
    currentHeading += diff * turnRate * min(dirSpeed / maxSpeed, 1);
  }

  void separate(Jellyfish[] others) {
    for (int i = 0; i < jellyfishCount; i++) {
      if (others[i] != this) {
        float dx = x - others[i].x;
        float dy = y - others[i].y;
        float distSq = sq(dx) + sq(dy);
        if (distSq > 0 && distSq <= sq(100)) {
          float dist = sqrt(distSq);
          float nx = dx / dist;
          float ny = dy / dist;
          ax += (nx * maxSpeed - vx) * 0.05;
          ay += (ny * maxSpeed - vy) * 0.05;
        }
      }
    }
  }

  void align(Jellyfish[] others) {
    float sumVx = 0;
    float sumVy = 0;
    int count = 0;

    for (int i = 0; i < jellyfishCount; i++) {
      if (others[i] != this) {
        float dx = x - others[i].x;
        float dy = y - others[i].y;
        float distSq = sq(dx) + sq(dy);
        if (distSq < sq(150)) {
          count += 1;
          sumVx += others[i].vx;
          sumVy += others[i].vy;
        }
      }
    }
    if (count > 0) {
      float aveVx = sumVx / count;
      float aveVy = sumVy / count;
      ax += (aveVx - vx) * 0.03;
      ay += (aveVy - vy) * 0.03;
    }
  }

  void cohesion(Jellyfish[] others) {
    float sumX = 0;
    float sumY = 0;
    int count = 0;

    for (int i = 0; i < jellyfishCount; i++) {
      if (others[i] != this) {
        float dx = x - others[i].x;
        float dy = y - others[i].y;
        float distSq = sq(dx) + sq(dy);
        if (distSq < sq(200)) {
          count += 1;
          sumX += others[i].x;
          sumY += others[i].y;
        }
      }
    }
    if (count > 0) {
      float dx = sumX / count - x;
      float dy = sumY / count - y;
      float d = sqrt(sq(dx) + sq(dy));
      if (d > 0) {
        ax += (dx / d * maxSpeed - vx) * 0.01;
        ay += (dy / d * maxSpeed - vy) * 0.01;
      }
    }
  }

  void seekMouse() {
    if (!mouseActive) return;
    float seekRadius = 200;
    float dx = mouseX - x;
    float dy = mouseY - y;
    float d = sqrt(sq(dx) + sq(dy));
    if (d > 0 && d < seekRadius) {
      ax += (dx / d * maxSpeed - vx) * 0.02;
      ay += (dy / d * maxSpeed - vy) * 0.02;
    }
  }

  void flee() {
    float age = t - scareTime;
    if (age > 5.0) return;
    
    float dx = x - scareX;
    float dy = y - scareY;
    float d = sqrt(sq(dx) + sq(dy));
    
    float radius = 300;
    if (d > 0 && d < radius){
      float spatialFalloff = 1.0 - d / radius;
      float timeFalloff = 1.0 - age / 5.0;
      float strength = 0.3 * spatialFalloff * timeFalloff;
      
      ax += (dx / d) * maxSpeed * strength;
      ay += (dy / d) * maxSpeed * strength;
    }
  }

  void drawTentacles() {

    float cRim = contractionAt(phase - WAVE_DELAY);
    float rimXZ = (1.0 - 0.40 * cRim) * sin(BELL_ANG);
    float rimY  = (-cos(BELL_ANG) + TUCK * cRim) * BELL_SQUASH;

    int segments = 35;

    for (int k = 0; k < tentacleCount; k++) {

      float theta1 = (float) k / tentacleCount * TWO_PI;

      nodeX[0] = 10 * cos(theta1);
      nodeY[0] = 0;
      nodeZ[0] = 10 * sin(theta1);

      for (int s = 1; s <= segments; s++) {
        float ratio = (float) s / segments;

        float noiseX = noise(myTentacleOffset[k] + t, ratio * 2);
        float noiseZ = noise(myTentacleOffset[k] + 50 + t, ratio * 2);

        nodeX[s] = nodeX[0] + map(noiseX, 0, 1, -30, 30) * ratio;
        nodeY[s] = myTentacleLength[k] * ratio;
        nodeZ[s] = nodeZ[0] + map(noiseZ, 0, 1, -30, 30) * ratio;
      }

      for (int s = 0; s < segments; s++) {
        float tip = (float) s / segments;
        stroke(150, 80, 255, lerp(40, 40 * 0.12, tip));
        strokeWeight(max(myTentacleWidth[k] * size * (1.0 - tip * 0.85), 0.4));
        line(nodeX[s], nodeY[s], nodeZ[s], nodeX[s+1], nodeY[s+1], nodeZ[s+1]);
      }

      noFill();
      stroke(150, 128, 222, 14);
      strokeWeight(myTentacleWidth[k] * size * 0.6);
      beginShape();
      for (int s = 0; s <= segments; s++) curveVertex(nodeX[s], nodeY[s], nodeZ[s]);
      endShape();
    }


    int segments2 = 40;

    for (int k = 0; k < tentacleCount2; k++) {

      float theta1 = ((float) k + 0.5) / tentacleCount2 * TWO_PI;

      nodeX[0] = bellRadius * rimXZ * cos(theta1);
      nodeY[0] = bellRadius * rimY;
      nodeZ[0] = bellRadius * rimXZ * sin(theta1);

      for (int s = 1; s <= segments2; s++) {
        float ratio = (float) s / segments2;

        float noiseX = noise(myTentacleOffset2[k] + t, ratio * 2);
        float noiseZ = noise(myTentacleOffset2[k] + 50 + t, ratio * 2);

        nodeX[s] = nodeX[0] + map(noiseX, 0, 1, -30, 30) * ratio;
        nodeY[s] = nodeY[0] + myTentacleLength2[k] * ratio;
        nodeZ[s] = nodeZ[0] + map(noiseZ, 0, 1, -30, 30) * ratio;
      }

      for (int s = 0; s < segments2; s++) {
        float tip = (float) s / segments2;
        stroke(90, 130, 255, lerp(80, 80 * 0.12, tip));
        strokeWeight(max(myTentacleWidth2[k] * size * (1.0 - tip * 0.85), 0.4));
        line(nodeX[s], nodeY[s], nodeZ[s], nodeX[s+1], nodeY[s+1], nodeZ[s+1]);
      }

      noFill();
      stroke(114, 158, 222, 14);
      strokeWeight(myTentacleWidth2[k] * size * 0.6);
      beginShape();
      for (int s = 0; s <= segments2; s++) curveVertex(nodeX[s], nodeY[s], nodeZ[s]);
      endShape();
    }
  }

}
