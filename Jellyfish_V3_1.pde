float t = 0;
int tentacleCount = 6;
int tentacleCount2 = 12;

float bellRadius = 50;

final float BELL_SQUASH = 0.52;
final float BELL_ANG = HALF_PI * 1.2;
final float TUCK = 0.55;
final float WAVE_DELAY = 0.13;
final float CONTRACT_FRAC = 1.0 / 3.0;

float currentVX = 0;
float currentVY = 0;

float compassX, compassY;
float compassRadius = 50;
float maxCurrentStrength = 1.2;
boolean draggingCompass = false;

float scareX;
float scareY;
float scareTime = -999;

PImage ocean;

int jellyfishCount = 20;
Jellyfish[] jellyfishes = new Jellyfish[jellyfishCount];

boolean mouseActive = false;

void mouseMoved() {
  mouseActive = true;
}

void mouseDragged() {
  if (draggingCompass) {
    updateCurrentFromCompass();
  } else {
    mouseActive = true;
  }
}

void mousePressed() {
  if (insideCompass(mouseX, mouseY)) {
    draggingCompass = true;
    updateCurrentFromCompass();
  } else {
    scareX = mouseX;
    scareY = mouseY;
    scareTime = t;
  }
}

void mouseReleased() {
  draggingCompass = false;
}

boolean insideCompass(float mx, float my) {
  float d = sqrt(sq(mx - compassX) + sq(my - compassY));
  return d < compassRadius;
}

void updateCurrentFromCompass() {
  float dx = mouseX - compassX;
  float dy = mouseY - compassY;
  float d = sqrt(sq(dx) + sq(dy));
  float clamped = min(d, compassRadius);
  float angle = atan2(dy, dx);
  float mag = map(clamped, 0, compassRadius, 0, maxCurrentStrength);

  currentVX = cos(angle) * mag;
  currentVY = sin(angle) * mag;
}

void drawCompass() {
  noFill();
  stroke(200, 220, 255, 150);
  strokeWeight(2);
  ellipse(compassX, compassY, compassRadius * 2, compassRadius * 2);

  float mag = sqrt(sq(currentVX) + sq(currentVY));
  float angle = atan2(currentVY, currentVX);
  float handleDist = map(mag, 0, maxCurrentStrength, 0, compassRadius);
  float hx = compassX + cos(angle) * handleDist;
  float hy = compassY + sin(angle) * handleDist;

  stroke(255);
  strokeWeight(3);
  line(compassX, compassY, hx, hy);
  noStroke();
  fill(255);
  ellipse(hx, hy, 8, 8);
}

void setup() {
  size(1680, 840, P3D);

  compassX = 80;
  compassY = height - 80;

  ocean = createImage(width, height, RGB);
  ocean.loadPixels();
  for (int py = 0; py < height; py++){
    float ratio = (float) py / height;
    color topColor = color(20, 20, 70);
    color botColor = color(0, 0, 20);
    color midColor = lerpColor(topColor, botColor, ratio);
  
    for (int px = 0; px < width; px++){
      ocean.pixels[py * width + px] = midColor;
    }
  }
  ocean.updatePixels();
  
  initBell();
  for (int idx3 = 0; idx3 < jellyfishCount; idx3++) {
    jellyfishes[idx3] = new Jellyfish();
  }
}

void draw() {
  background(0); //clears the depth buffer too; color gets fully covered by the image below
  blendMode(BLEND);
  image(ocean, 0, 0);
  t += 0.018 * 60.0 / frameRate;

  fill(255);
  text(nf(frameRate, 0, 1) + " fps", 20, 30);
  drawCompass();

  blendMode(ADD);

  ambientLight(30, 0, 80);
  lightSpecular(255, 255, 255);
  pointLight(180, 160, 255, width / 2, height / 2 - 300, 500);
  shininess(150);

  for (int idx3 = 0; idx3 < jellyfishCount; idx3++) {
    jellyfishes[idx3].flock();
  }
  for (int idx3 = 0; idx3 < jellyfishCount; idx3++){
    jellyfishes[idx3].update();
    jellyfishes[idx3].display();
  }
}

float contractionAt(float p) {
  p = wrap01(p);
  if (p < CONTRACT_FRAC) {
    float tc = p / CONTRACT_FRAC;
    return easeOutExpo(tc);
  } else {
    float tr = (p - CONTRACT_FRAC) / (1 - CONTRACT_FRAC);
    return 1.0 - easeInOutSine(tr);
  }
}

float easeOutExpo(float x) {
  return (x >= 1.0) ? 1.0 : 1.0 - pow(2, -10 * x);
}

float easeInOutSine(float x) {
  return -(cos(PI * x) - 1) * 0.5;
}

float smoothstep01(float x) {
  x = constrain(x, 0, 1);
  return x * x * (3 - 2 * x);
}

float wrap01(float p) {
  p = p % 1.0;
  if (p < 0) p += 1.0;
  return p;
}
