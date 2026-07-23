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
However, after updating this feature, I realized this feature was conflict with seekMouse(). Even jellyfishes follow currents, they soon swim back toward the mouse. They were both my babies, I really didn't want to delete any of them.
So I sought some helps from Claude.


4. j
   

