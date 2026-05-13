

void setup(){
    size(840, 840, P3D);
}


void draw(){
  background(0);
  translate(width/2, height/2,  0); 
  blendMode(ADD);
  
  rotateX(-0.4);
  int total = 150;

//draw half sphere and color
  for (int r = 0; r <=150; r++){
    for (int i = 0; i <= total; i++) { //from the top to equator
      float phi = map(i, 0, total, 0, HALF_PI); //φ:0 ~ π/2half sphere
      
      for (int j = 0; j <= total; j++) { //horizontally circulate inside i loop
        float theta = map(j, 0, total, 0, TWO_PI); //θ: a full circle

        //actual position of xyz in 3D
        float x = r * sin(phi) * cos(theta);
        float y = -r * cos(phi);
        float z = r * sin(phi) * sin(theta);

        stroke(50, 0, 200, 50);
        stroke(50, 0, 255, 50);
        point(x, y, z);
      }
    }
  }

//draw tentacles
  int i1 = total;
  for (int r1 = 0; r1 <=120; r1 = r1+50){
    float phi1 = map(i1, 0, total, 0, HALF_PI);
      for (int j1 = 0; j1 <= total; j1 = j1+50){
        float theta1 = map(j1, 0, total, 0, TWO_PI);
        float x1 = r1 * sin(phi1) * cos(theta1);
        float y1 = -r1 * cos(phi1);
        float z1 = r1 * sin(phi1) * sin(theta1);    
      
        stroke(255);
        print(x1, y1, z1);

        float random_length = random(100, 300);
        stroke(50, 0, 100, 50);
        stroke(50, 0, 255, 50);
        strokeWeight(random(1, 5));
        line(x1, y1, z1, x1, y1+random_length, z1);                         
    }  
  }
}
