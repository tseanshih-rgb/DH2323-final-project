---
layout: post
title: "23/7 "
---

Changes:
1. mousePressed() and flee(): now when the mouse is pressed, jellyfishes will swim toward the opposite direction, but only within a short time then they'll swim back toward the mouse.
```java
  void mousePressed(){
    scareX = mouseX;
    scareY = mouseY;
    scareTime = t;
  }
```
```java
  void flee() {
  float age = t - scareTime; //how long since the last time scared
  if (age > 5.0) return; 
    
  float dx = x - scareX;
  float dy = y - scareY;
  float d = sqrt(sq(dx) + sq(dy));
  
  float radius = 300;
  if (d > 0 && d < radius){
    float spatialFalloff = 1.0 - d / radius; //the closer the jellyfish is to the mouse, the harder it is pushed away
    float timeFalloff = 1.0 - age / 3.0; //the push decrease along with time
    float strength = 0.3 * spatialFalloff * timeFalloff;
    
    ax += (dx / d) * maxSpeed * strength;
    ay += (dy / d) * maxSpeed * strength;
  }
}
```

2. depth of field:
3. adjusting water currents to influence the moving direction of jellyfishes:
   Draw a compass in the corner to adjust watter currents, but because currently mousePressed and mouseDragged were occupied by flee() and mouseActive, so this feature needed to be limited within the range of the compass.
  ```java
  void mousePressed() {
    if (insideCompass(mouseX, mouseY)) {
      draggingCompass = true;
      updateCurrentFromCompass();
    } else {
      scareX = mouseX;
      scareY = mouseY;
      scareTime = t;
    }
  }
  ```
  ```java
  void updateCurrentFromCompass() { //calculate the direction and strength of currents
    float dx = mouseX - compassX;
    float dy = mouseY - compassY;
    float d = sqrt(sq(dx) + sq(dy));
    float clamped = min(d, compassRadius);  
    float angle = atan2(dy, dx);
    float mag = map(clamped, 0, compassRadius, 0, maxCurrentStrength);
  
    currentVX = cos(angle) * mag;
    currentVY = sin(angle) * mag;
  }
```
However, after updating this feature, I realized this feature was conflict with seekMouse(). Even jellyfishes follow currents, they soon swim back toward the mouse. They were both my babies, I really didn't want to delete any of them. So, I sought some helps from Claude, to see if there was any way to keep both.
Clause provided four approaches:
  1. Make heading account for the current too, not just swim velocity (RECOMEND): "Right now heading is computed as atan2(vy, vx) — purely from the jellyfish's own swim velocity,     ignoring   currentVX, currentVY entirely. Change it to compute heading from the combined direction (swim velocity + current) instead. That way, when the current is strong, the body actually turns to face the direction it's really drifting in, instead of staying locked onto the mouse. Visually, this becomes "when the current is strong enough, the whole school turns and faces the direction of the flow as it gets swept along" — which is the read you actually want."
  2. Give seekMouse a distance falloff and a perception radius (same design as flee) (RECOMEND): "Right now seekMouse pulls with the same strength regardless of distance — no falloff at all. This is actually inconsistent with every other force you have (separate/align/cohesion/flee all have a defined radius); seekMouse is the one outlier with unlimited global range. Add a radius, and only jellyfish near the cursor get pulled toward it — jellyfish far from the cursor (the ones currently being swept by the current) are left alone. The two effects naturally separate in space, and you don't have to sacrifice either feature."
  3. Change the trigger from "mouse has moved" to "mouse is actively being dragged"
  4. Automatically suppress seekMouse's weight once the current is strong enough  



5. j
   

