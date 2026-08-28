void drawHalo(float phase, float depth){

  float global = contractionAt(phase);
  float expand = map(global, 0, 1, 20, 5);
  float haloRadius = bellRadius + expand;

  float maxAlpha = map(haloRadius, 55, 70, 80, 20);
  maxAlpha *= map(depth, 0, 1, 1.0, 0.35);

  for(int haloLayer = 0; haloLayer < 4; haloLayer++){
    float haloLayerRadius = haloRadius + haloLayer * 2;
    for(int i = 0; i < totalPhi; i++){

      float topHalo = maxAlpha * pow(1.0 - (float) i / totalPhi * 0.8, 2);
      float botHalo = maxAlpha * pow(1.0 - (float) (i+1) / totalPhi * 0.8, 2);

      float u0 = (float) i / totalPhi;
      float u1 = (float) (i+1) / totalPhi;
      float c0 = contractionAt(phase - u0 * waveDelay) * smoothstep01(u0);
      float c1 = contractionAt(phase - u1 * waveDelay) * smoothstep01(u1);

      float sxz0 = 1.0 - 0.40 * c0;
      float sxz1 = 1.0 - 0.40 * c1;
      float ty0 = bellSquash * tuck * c0 * pow(u0, 1.5);
      float ty1 = bellSquash * tuck * c1 * pow(u1, 1.5);

      beginShape(TRIANGLE_STRIP);

      for(int j = 0; j <= totalTheta; j++){
        fill(0, 0, 200, topHalo);
        vertex(haloLayerRadius * sxz0 * bellUnitX[i][j],
               haloLayerRadius * (bellUnitY[i] + ty0),
               haloLayerRadius * sxz0 * bellUnitZ[i][j]);

        fill(0, 0, 200, botHalo);
        vertex(haloLayerRadius * sxz1 * bellUnitX[i+1][j],
               haloLayerRadius * (bellUnitY[i+1] + ty1),
               haloLayerRadius * sxz1 * bellUnitZ[i+1][j]);
      }
      endShape();
    }
  }
}
