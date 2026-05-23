---
layout: post
title: "Day11"
---
Some changes:
1. Halo scale and shininess change  with bell scale
2. Add Fresnel effect
   ```java
        float R0 = 0.001;
        float cosTheta0 = nz0;
        float cosTheta1 = nz1;
        float fresnel0 = R0 + (1-R0) * pow(1 - max(cosTheta0, 0), 5);
        float fresnel1 = R0 + (1-R0) * pow(1 - max(cosTheta1, 0), 5);
   ```
4. Add tentacles in the outer ring 
5. Add subsurface scattering, but the color is too similiar to the bell's, and I use a very low alpha, so it's pretty dim.
   Not sure should I try a different approach or parameters to make it as noticeable as possible? or stop when it feels balanced
   ```java
        PVector lightDir0 = new PVector(-x0, 300-y0, 500-z0);
        lightDir0.normalize();
        PVector n0 = new PVector(nx0, ny0, nz0);
        float lightDot0 = n0.dot(lightDir0);
        float sss0 = map(lightDot0, -1, 0, 1, 0);
        sss0 = max(sss0, 0);
   ```
