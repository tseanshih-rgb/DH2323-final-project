float t = 0;
int tentacleCount = 6;
int tentacleCount2 = 12;

float bellRadius = 50;

final float BELL_SQUASH = 0.52;
final float BELL_ANG = HALF_PI * 1.2;
final float TUCK = 0.55;
final float WAVE_DELAY = 0.13;
final float CONTRACT_FRAC = 1.0 / 3.0;

int jellyfishCount = 20;
Jellyfish[] jellyfishes = new Jellyfish[jellyfishCount];

boolean mouseActive = false;

void mouseMoved() {
  mouseActive = true;
}

void mouseDragged() {
  mouseActive = true;
}

void setup() {
  size(1680, 840, P3D);
  initBell();
  for (int idx3 = 0; idx3 < jellyfishCount; idx3++) {
    jellyfishes[idx3] = new Jellyfish();
  }
}

void draw() {
  background(0, 0, 45);
  t += 0.012 * 60.0 / frameRate;

  blendMode(BLEND);
  fill(255);
  text(nf(frameRate, 0, 1) + " fps", 20, 30);

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
