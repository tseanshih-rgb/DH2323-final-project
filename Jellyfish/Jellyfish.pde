
float t = 0;
float[] tentacleOffset; //save array for each tentacle // save the beginning point of noise of tentacles
int tentacleCount = 0;
float[] tentacleWidth = new float[12];
float[] tentacleLength = new float[12];

void setup(){
    size(840, 840, P3D);

    tentacleCount = 12;
    tentacleOffset = new float[12];
    
    for(int idx = 0; idx < tentacleCount; idx++){
      tentacleOffset[idx] = random(0, 100);  
      tentacleWidth[idx] = random(5, 20);
      tentacleLength[idx] = random(250, 300);
    }   
}


void draw(){
  background(0);
  t += 0.7;
  jellyfish();
}

void jellyfish(){  
  pushMatrix();
  float bellPulse = sin(t * 0.5);
  float bellScale = 1.0 + bellPulse * 0.12; //for the ratio of the bell expanding and shrinking
  float offset = bellPulse * 20;
  translate(width/2, height/2 + offset ,  0);
  blendMode(ADD);
  
  rotateX(-0.4);
  int total = 75;

//draw half sphere and color  
  for (int r = 0; r <= 150; r++){
    for (int i = 0; i <= total; i++) { //from the top to equator
      float phi = map(i, 0, total, 0, HALF_PI); //φ:0 ~ π/2half sphere
      
      for (int j = 0; j <= total; j++) { //horizontally circulate inside i loop
        float theta = map(j, 0, total, 0, TWO_PI); //θ: a full circle

        //actual position of xyz in 3D
        float x = r * bellScale * sin(phi) * cos(theta);
        float y = -r * cos(phi);
        float z = r * bellScale * sin(phi) * sin(theta);

        stroke(50, 0, 255, 50);
        point(x, y, z);
      }
    }
  }

//draw tentacles
  int i1 = total;
  int tentacleIndex = 0; //counting tentacle
  int segments = 10; //split segments of tentacle to make it smoother

  for (int r1 = 0; r1 <=120; r1 = r1+50){
    float phi1 = map(i1, 0, total, 0, HALF_PI);
    
      for (int j1 = 0; j1 <= total; j1 = j1+50){
        float theta1 = map(j1, 0, total, 0, TWO_PI);
        
        float x1 = r1 * bellScale * sin(phi1) * cos(theta1);
        float y1 = -r1 * cos(phi1);
        float z1 = r1 * bellScale * sin(phi1) * sin(theta1);    
        
        //float noiseValue = noise(tentacleOffset[tentacleIndex] + t * 0.5);
        //float sway = map(noiseValue, 0, 1, -25, 25); //both to left and to right 
        
        float px = x1, py = y1, pz = z1;
        for (int s = 1; s <= segments; s++){
          float ratio = (float) s / segments; //how far down 0.1, 0.2...1.0 //
          
          float noiseX = noise(tentacleOffset[tentacleIndex] + t * 0.5, ratio * 2);
          float noiseZ = noise(tentacleOffset[tentacleIndex] + 50 + t * 0.5, ratio * 2);
          float swayX = map(noiseX, 0, 1, -30, 30) * ratio;
          float swayZ = map(noiseZ, 0, 1, -30, 30) * ratio;
          
          float nx = x1 + swayX;
          float ny = y1 + tentacleLength[tentacleIndex] * ratio;
          float nz = z1 + swayZ;
          
          strokeWeight(tentacleWidth[tentacleIndex] * 0.15);
          stroke(50, 0, 255, 60);
          line(px, py, pz, nx, ny, nz);
          px = nx;
          py = ny; 
          pz = nz;
        }
      tentacleIndex ++;
    }  
  }
  popMatrix();
}
