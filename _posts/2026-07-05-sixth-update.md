---
layout: post
title: "Day-idk-how-many-let's-just-use-5/7 fixed bugs and smoothed movements"
---

After the crazy final month, finally got time getting back to my jellyfishes.
1. Fixed the problem that when jellyfishes reach edges, they get stucked, by modifying positions but not only speed.
2. Added tOffset = random(TWO_PI) to make jellyfishes shrink in different tempo.
3. Added "thrust" to adjust drifting movements. In reality, when a jellyfish contracts, it drifts forwards at an accelerated pace; when it expands, it drifts at a slower pace. In the previous version, contracting and expanding weren't really linked to speed and drifting.
4. Jellyfishes now swim toward different directions. Added currentHeading and turnRate etc. to stimulate jellyfishes carried away by water currents.
