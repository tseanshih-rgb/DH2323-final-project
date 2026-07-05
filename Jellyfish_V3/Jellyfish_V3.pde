float t = 0;
int tentacleCount = 6;
int tentacleCount2 = 12;

int jellyfishCount = 20;
Jellyfish[] jellyfishes = new Jellyfish[jellyfishCount];

void setup() {
  size(1680, 840, P3D);
  for (int idx3 = 0; idx3 < jellyfishCount; idx3++) {    
    jellyfishes[idx3] = new Jellyfish();    
  }  
}

void draw() {
  background(0, 0, 45);
  t += 0.03;

  blendMode(ADD);

  ambientLight(30, 0, 80);
  lightSpecular(255, 255, 255);
  pointLight(180, 160, 255, width / 2, height / 2 - 300, 500);
  shininess(150);
  
  for (int idx3 = 0; idx3 < jellyfishCount; idx3++){
    jellyfishes[idx3].display();
    jellyfishes[idx3].update();  
  }  
}
