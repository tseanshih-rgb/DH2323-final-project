---
layout: post
title: "15/7 "
---

Changes:
1. Cohesion: the last rule of Boids
2. Interaction: added seekMouse() to make jellyfishes swim toward the mouse, making this a bit more interactive. Maybe will add another way of interaction later, like making them move away
3. Movement: made a huge change about bell movement. Before jellyfishes moved at a constant speed, but real jellyfishes contract the bell first and a vortex forms at the edge of the bell, then the bell relaxes and the second vortex formed, and when two vortex meet, a "virtual wall" of water is generated and it push off jellyfishes.
   3.1. thrust = the rate of change of contraction, only appear during the squeeze, not the whole cycle
     ```java
     float dc = cGlobal - prevC;  // how much contraction changed this frame
     float thrustRaw = max(dc, 0) * 12 * thrustJitter;
    ```
     dc is only positive while contraction is actively increasing (squeezing in). Once it starts relaxing, dc goes negative and gets clamped to 0 by max(dc, 0). So thrust naturally appears only during the squeeze
   3.2. two different smoothing speeds

     ˋˋˋjava
       if (thrustRaw > thrustSmooth) {
      thrustSmooth += (thrustRaw - thrustSmooth) * 0.5;  // catches up fast
      } else {
      thrustSmooth += (thrustRaw - thrustSmooth) * 0.06; // releases slowly
      }
     ˋˋˋ
     When thrust is rising, it follows quickly, and when thrust is falling, it eases down slowly.
4. The look of the bell: draw the bell in a flatter shape
  
   <img width="752" height="590" alt="Screenshot 2026-07-15 at 7 29 37 PM" src="https://github.com/user-attachments/assets/2c6ce640-ddc8-4431-8898-1a20d8dbe815" />
