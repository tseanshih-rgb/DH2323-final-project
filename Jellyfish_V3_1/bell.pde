int totalPhi = 20;
int totalTheta = 40;
int bellLayers = 4;

float[][] bellUnitX;
float[][] bellUnitZ;
float[] bellUnitY;

float[][] bellR;
float[][] bellG;
float[][] bellB;
float[][] bellAlphaFactor;

void initBell() {
  bellUnitX = new float[totalPhi + 1][totalTheta + 1];
  bellUnitZ = new float[totalPhi + 1][totalTheta + 1];
  bellUnitY = new float[totalPhi + 1];
  bellR = new float[totalPhi + 1][totalTheta + 1];
  bellG = new float[totalPhi + 1][totalTheta + 1];
  bellB = new float[totalPhi + 1][totalTheta + 1];
  bellAlphaFactor = new float[totalPhi + 1][totalTheta + 1];

  for (int i = 0; i <= totalPhi; i++) {
    float phi = map(i, 0, totalPhi, 0, BELL_ANG);
    bellUnitY[i] = -cos(phi) * BELL_SQUASH;

    for (int j = 0; j <= totalTheta; j++) {
      float theta = map(j, 0, totalTheta, 0, TWO_PI);

      float scallop = 1.0 + 0.035 * sin(8 * theta) * ((float) i / totalPhi);

      float ux = sin(phi) * cos(theta) * scallop;
      float uy = bellUnitY[i];
      float uz = sin(phi) * sin(theta) * scallop;
      bellUnitX[i][j] = ux;
      bellUnitZ[i][j] = uz;

      float px = bellRadius * ux;
      float py = bellRadius * uy;
      float pz = bellRadius * uz;
      float lx = -px;
      float ly = 300 - py;
      float lz = 500 - pz;
      float invLen = 1.0 / sqrt(lx*lx + ly*ly + lz*lz);
      float lightDot = (ux*lx + uy*ly + uz*lz) * invLen;
      float sss = max(map(lightDot, -1, 0, 1, 0), 0);

      float R0 = 0.001;
      float fresnel = R0 + (1 - R0) * pow(1 - max(uz, 0), 5);

      float ratioBell = (float) i / totalPhi;
      bellAlphaFactor[i][j] = pow(1.0 - ratioBell * 0.9, map(fresnel, 0.02, 1, 2, 0));
      bellR[i][j] = map(fresnel, 0, 1, 60, 190) + sss * 120;
      bellG[i][j] = map(fresnel, 0, 1, 80, 160) + sss * 160;
      bellB[i][j] = map(fresnel, 0, 1, 190, 255) + sss * 60;
    }
  }
}

void drawBell(float phase, float depth) {

  float cGlobal = contractionAt(phase);
  float maxAlpha = map(cGlobal, 0, 1, 75, 150);
  maxAlpha *= map(depth, 0, 1, 1.0, 0.35);
  
  float fog = depth * 0.5;

  noStroke();

  for (int layer = 0; layer < bellLayers; layer++) {
    float layerRadius = bellRadius + layer * 5;
    for (int i = 0; i < totalPhi; i++) {

      float u0 = (float) i / totalPhi;
      float u1 = (float) (i+1) / totalPhi;
      float c0 = contractionAt(phase - u0 * WAVE_DELAY) * smoothstep01(u0);
      float c1 = contractionAt(phase - u1 * WAVE_DELAY) * smoothstep01(u1);

      float sxz0 = 1.0 - 0.40 * c0;
      float sxz1 = 1.0 - 0.40 * c1;
      float ty0 = BELL_SQUASH * TUCK * c0 * pow(u0, 1.5);
      float ty1 = BELL_SQUASH * TUCK * c1 * pow(u1, 1.5);

      beginShape(TRIANGLE_STRIP);

      for (int j = 0; j <= totalTheta; j++) {
        
       fill(lerp(bellR[i][j], 0, fog),
       lerp(bellG[i][j], 0, fog),
       lerp(bellB[i][j], 20, fog),
       maxAlpha * bellAlphaFactor[i][j]);
         
        normal(bellUnitX[i][j], bellUnitY[i], bellUnitZ[i][j]);
        vertex(layerRadius * sxz0 * bellUnitX[i][j], layerRadius * (bellUnitY[i] + ty0), layerRadius * sxz0 * bellUnitZ[i][j]);

        fill(lerp(bellR[i+1][j], 0, fog), lerp(bellG[i+1][j], 0, fog), lerp(bellB[i+1][j], 20, fog), maxAlpha * bellAlphaFactor[i+1][j]);
        normal(bellUnitX[i+1][j], bellUnitY[i+1], bellUnitZ[i+1][j]);
        vertex(layerRadius * sxz1 * bellUnitX[i+1][j], layerRadius * (bellUnitY[i+1] + ty1), layerRadius * sxz1 * bellUnitZ[i+1][j]);
      }
      endShape();
    }
  }
}
