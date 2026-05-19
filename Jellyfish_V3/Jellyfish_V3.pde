float t = 0;
float[] tentacleOffset;
int tentacleCount = 12;
float[] tentacleWidth  = new float[12];
float[] tentacleLength = new float[12];

void setup() {
  size(840, 840, P3D);
  tentacleOffset = new float[tentacleCount];
  for(int idx = 0; idx < tentacleCount; idx++) {
    tentacleOffset[idx] = random(0, 100);
    tentacleWidth[idx]  = random(10, 20);
    tentacleLength[idx] = random(250, 400);
  }
}

void draw() {
  background(0, 0, 45);
  t += 0.015;
 
  ambientLight(30, 0, 80);
  pointLight(180, 160, 255, width / 2, height / 2 - 300, 500);
  lightSpecular(255, 255, 255);
  shininess(150);
  
  jellyfish();

}

void jellyfish() {
  pushMatrix();

  float bellPulse = sin(t * PI);
  float bellScale = 1.0 + bellPulse * 0.12;
  float offsetY = bellPulse * 20;

  translate(width / 2, height / 2 + offsetY, 0);
  blendMode(ADD);
  rotateX(-0.4);

  int totalPhi = 40; //latitude
  int totalTheta = 80; //longtitude
  float radius = 150;
  float haloRadius = 185;

  noStroke();
  
  for(int layer = 0; layer < 10; layer++){
    float layerRadius = radius + layer * 3;
    for(int i = 0; i < totalPhi; i++) {
      float phi0 = map(i, 0, totalPhi, 0, HALF_PI);
      float phi1 = map(i + 1, 0, totalPhi, 0, HALF_PI);
      
      beginShape(TRIANGLE_STRIP);
          
      for(int j = 0; j <= totalTheta; j++) {
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
        
        float ratioTop = (float) i / totalPhi;
        float ratioBot = (float) (i+1) / totalPhi;
        float alphaTop = 80 * pow(1.0 - ratioTop * 0.9, 2);
        float alphaBot = 80 * pow(1.0 - ratioBot * 0.9, 2);
  
        fill(150, 100, 255, alphaTop);
        normal(nx0, ny0, nz0);
        vertex(x0, y0, z0);
  
        fill(150, 100, 255, alphaBot);
        normal(nx1, ny1, nz1);
        vertex(x1, y1, z1);
      }
    endShape();
    }
  }
    
  //halo
    for(int i = 0; i < totalPhi; i++) {
      float phi0 = map(i, 0, totalPhi, 0, HALF_PI);
      float phi1 = map(i + 1, 0, totalPhi, 0, HALF_PI);
      
      beginShape(TRIANGLE_STRIP);
          
      for(int j = 0; j <= totalTheta; j++) {
        float theta = map(j, 0, totalTheta, 0, TWO_PI);
  
        float haloX0 = haloRadius * bellScale * sin(phi0) * cos(theta);
        float haloY0 = -haloRadius * cos(phi0);
        float haloZ0 = haloRadius * bellScale * sin(phi0) * sin(theta);
        
        float haloX1 = haloRadius * bellScale * sin(phi1) * cos(theta);
        float haloY1 = -haloRadius * cos(phi1);
        float haloZ1 = haloRadius * bellScale * sin(phi1) * sin(theta);
        
        float ratioTop = (float) i / totalPhi;
        float ratioBot = (float) (i+1) / totalPhi;
        float alphaTop = 50 * pow(1.0 - ratioTop * 0.8 , 2);
        float alphaBot = 50 * pow(1.0 - ratioBot * 0.8, 2);
        
        fill(0, 0, 200, alphaTop);
        vertex(haloX0, haloY0, haloZ0);
        
        fill(0, 0, 200, alphaBot);
        vertex(haloX1, haloY1, haloZ1);
      }
    endShape();
    }

//tentacles
  int tentacleIndex = 0;
  int segments = 35;

  for(int r1 = 0; r1 <= 100 && tentacleIndex < tentacleCount; r1 += 50) {
    for(int j1 = 0; j1 <= 100 && tentacleIndex < tentacleCount; j1 += 50) {

      float phi1 = HALF_PI; //all tentacles grow from equator
      float theta1 = map(j1, 0, 100, 0, TWO_PI);

      float x1 = r1 * bellScale * sin(phi1) * cos(theta1);
      float y1 = -r1 * cos(phi1);
      float z1 = r1 * bellScale * sin(phi1) * sin(theta1);

      float px = x1, py = y1, pz = z1;

      for(int s = 1; s <= segments; s++) {
        float ratio = (float) s / segments; //which part on tentacle

        float noiseX = noise(tentacleOffset[tentacleIndex] + t, ratio * 2);
        float noiseZ = noise(tentacleOffset[tentacleIndex] + 50 + t, ratio * 2);
        float swayX = map(noiseX, 0, 1, -30, 30) * ratio;
        float swayZ = map(noiseZ, 0, 1, -30, 30) * ratio;

        float nx = x1 + swayX;
        float ny = y1 + tentacleLength[tentacleIndex] * ratio;
        float nz = z1 + swayZ;

        strokeWeight(tentacleWidth[tentacleIndex] * (1.0 - ratio * 0.7)); 
        stroke(50, 0, 255, map(ratio, 0, 1, 40, 5));
        line(px, py, pz, nx, ny, nz);

        px = nx; py = ny; pz = nz;
      }
      tentacleIndex++;
    }
  }
  popMatrix();
}
