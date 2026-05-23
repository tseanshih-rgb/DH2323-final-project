float t = 0;
float[] tentacleOffset;
float[] tentacleOffset2;
int tentacleCount = 12;
int tentacleCount2 = 24;
float[] tentacleWidth  = new float[12];
float[] tentacleLength = new float[12];
float[] tentacleWidth2  = new float[24];
float[] tentacleLength2 = new float[24];

float jellyfishX, jellyfishY;

void setup() {
  size(840, 840, P3D);
  tentacleOffset = new float[tentacleCount];
  tentacleOffset2 = new float[tentacleCount2];
  for (int idx = 0; idx < tentacleCount; idx++) {
    tentacleOffset[idx] = random(0, 100);
    tentacleWidth[idx]  = random(10, 20);
    tentacleLength[idx] = random(250, 400);
  }
  for (int idx2 = 0; idx2 < tentacleCount2; idx2++) {
    tentacleOffset2[idx2] = random(0, 100);
    tentacleWidth2[idx2]  = random(5, 8);
    tentacleLength2[idx2] = random(300, 550);
  }
}

void draw() {
  background(0, 0, 45);
  t += 0.015;

  ambientLight(30, 0, 80);
  pointLight(180, 160, 255, width / 2, height / 2 - 300, 500);
  lightSpecular(255, 255, 255);
  shininess(150);
  
  //jellyfishX += (mouseX - jellyfishX) * 0.01;
  //jellyfishY += (mouseY - jellyfishY) * 0.01;
  
  //float a = atan2(mouseY - jellyfishY, mouseX - jellyfishX);
  //rotate(radians(a));

  jellyfish();
}
