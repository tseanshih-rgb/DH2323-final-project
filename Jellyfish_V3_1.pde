float t = 0;
int tentacleCount = 6;
int tentacleCount2 = 12;

//bell geometry, contraction constant
float bellRadius = 50;

final float bellSquash = 0.52;
final float bellAng = HALF_PI * 1.2;
final float tuck = 0.55;
final float waveDelay = 0.13;
final float contractFrac = 1.0 / 3.0;

//for water current
float currentVX = 0;
float currentVY = 0;

float compassX, compassY;
float compassRadius = 50;
float maxCurrentStrength = 1.2;
boolean draggingCompass = false;

//flee
float fleeX;
float fleeY;
float fleeTime = -999;


//scene
PImage ocean;

int jellyfishCount = 20;
Jellyfish[] jellyfishes = new Jellyfish[jellyfishCount];

boolean mouseActive = false;

//mouse interaction
void mouseMoved(){
  mouseActive = true;
}

void mouseDragged(){
  if(draggingCompass){
    updateCurrentFromCompass();
  }
  else{
    mouseActive = true;
  }
}

void mousePressed(){
  if(insideCompass(mouseX, mouseY)){
    draggingCompass = true;
    updateCurrentFromCompass();
  } 
  else{
    fleeX = mouseX;
    fleeY = mouseY;
    fleeTime = t;
  }
}

void mouseReleased(){
  draggingCompass = false;
}

//compass to control water currents
boolean insideCompass(float mx, float my){
  float d = sqrt(sq(mx - compassX) + sq(my - compassY));
  return d < compassRadius;
}

void updateCurrentFromCompass(){
  float dx = mouseX - compassX;
  float dy = mouseY - compassY;
  float d = sqrt(sq(dx) + sq(dy));
  float c = min(d, compassRadius);
  float angle = atan2(dy, dx);
  float magnitude = map(c, 0, compassRadius, 0, maxCurrentStrength);

  currentVX = cos(angle) * magnitude;
  currentVY = sin(angle) * magnitude;
}

void drawCompass(){
  noFill();
  stroke(200, 220, 255, 150);
  strokeWeight(2);
  ellipse(compassX, compassY, compassRadius * 2, compassRadius * 2);

  float magnitude = sqrt(sq(currentVX) + sq(currentVY));
  float angle = atan2(currentVY, currentVX);
  float handleDist = map(magnitude, 0, maxCurrentStrength, 0, compassRadius);
  float handleX = compassX + cos(angle) * handleDist;
  float handleY = compassY + sin(angle) * handleDist;

  stroke(255);
  strokeWeight(3);
  line(compassX, compassY, handleX, handleY);
  noStroke();
  fill(255);
  ellipse(handleX, handleY, 8, 8);
}

void setup(){
  size(1680, 840, P3D);

  compassX = 80;
  compassY = height - 80;

  ocean = createImage(width, height, RGB);
  ocean.loadPixels();
  
  
  for(int py = 0; py < height; py++){
    float ratio = (float) py / height;
    color topColor = color(20, 20, 70);
    color botColor = color(0, 0, 20);
    color midColor = lerpColor(topColor, botColor, ratio);
  
    for(int px = 0; px < width; px++){
      ocean.pixels[py * width + px] = midColor;
    }
  }
  
  ocean.updatePixels();
  
  initBell();
  for(int idx4 = 0; idx4 < jellyfishCount; idx4++){
    jellyfishes[idx4] = new Jellyfish();
  }
}

void draw(){
  background(0); 
  blendMode(BLEND);
  image(ocean, 0, 0);
  t += 0.018 * 60.0 /frameRate;

  fill(255);
  text(nf(frameRate, 0, 1) + " fps", 20, 30);
  drawCompass();

  blendMode(ADD);

  ambientLight(30, 0, 80);
  lightSpecular(255, 255, 255);
  pointLight(180, 160, 255, width / 2, height / 2 - 300, 500);
  shininess(150);

  for(int idx4 = 0; idx4 < jellyfishCount; idx4++){
    jellyfishes[idx4].flock();
  }
  for(int idx4 = 0; idx4 < jellyfishCount; idx4++){
    jellyfishes[idx4].update();
    jellyfishes[idx4].display();
  }
}

//contration
float contractionAt(float p){
  p = wrap01(p);
  if(p < contractFrac){
    float tc = p / contractFrac;
    return easeOutExpo(tc);
  } 
  else{
    float tr = (p - contractFrac) / (1 - contractFrac);
    return 1.0 - easeInOutSine(tr);
  }
}

float easeOutExpo(float x){
  return (x >= 1.0) ? 1.0 : 1.0 - pow(2, -10 * x);
}

float easeInOutSine(float x){
  return -(cos(PI * x) - 1) * 0.5;
}

float smoothstep01(float x){
  x = constrain(x, 0, 1);
  return x * x * (3 - 2 * x);
}

float wrap01(float p){
  p = p % 1.0;
  if (p < 0) p += 1.0;
  return p;
}
