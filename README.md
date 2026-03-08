# Flappy Joyride

A high-intensity Flappy Bird clone with ballistic hazards and dynamic obstacles built in Godot 4.

---

## 📖 Project Description

Flappy Joyride is a fast-paced survival game that takes the classic "flap-and-dodge" mechanic and introduces scaling difficulty and ballistic threats. Unlike the original, players must contend with homing missiles and pipes with randomized orientations (horizontal, diagonal, or rotated) that significantly alter the navigation path.The game features a dynamic difficulty system where scroll speeds increase over time and hazard spawn rates accelerate, forcing players to adapt to a tightening window of survival.

---

## 🎮 Gameplay Overview

- Gravity-Based Flight: Click the left mouse button to flap upward ; gravity and velocity caps govern the bird's downward descent.
- Procedural Obstacles: Pipes spawn with randomized gap positions and various orientations, including Normal, Horizontal, Diagonal, and Rotated.
- Scaling Difficulty: Both scroll speed and obstacle frequency increase automatically as the game progresses.
- Permadeath: Collision with any obstacle—pipe, missile, or ground—results in an immediate Game Over where the bird falls to the ground.
---

## 🌀 Mechanical Twist: Ballistic Hazards

The primary disruption in this version is the Missile System:

- Targeted Spawning: Missiles are designed to spawn at a Y-position relative to the bird's current location to intercept the player.
- Telegraphed Danger: A warning indicator with an animated sprite and sound appears shortly before a missile launches.
- Dynamic Speed: Missiles travel faster than the standard environment scroll speed to increase the challenge.
- Audio-Visual Impact: Missiles feature randomized pitch scales for launch sounds and utilize particle emitters for trails and explosions upon impact.

---

## 🧠 Architecture & Design

This project demonstrates a robust, signal-driven architecture:

- State Management: Uses boolean flags like flying, falling, and game_running to manage physics states and game flow.
- Signal-Driven Communication: Obstacles such as Pipes and Missiles use custom hit signals to notify the Main controller of collisions without tight coupling.
- Object Lifecycle: Efficient use of queue_free() and array management to clean up off-screen obstacles once they pass a certain coordinate.
- Timers & Async: Utilizes Timer nodes for spawning and await functionality for telegraphed hazard timing.

---

## 🕹 Controls

| Action  | Input |
|----------|--------|
| Flap     | Left Mouse Click |
| Restart  | UI Button "Reset" |

---

## ⚙️ Technical Features

- Kinematic Physics: Custom movement implementation using move_and_slide() for the player character.
- Orientation Logic: Enum-based pipe rotations (NORMAL, HORIZONTAL, DIAGONAL_LEFT, DIAGONAL_RIGHT, ROTATED) to create varied gap geometries.
- Particle Systems: Use of emitters for missile trails and explosion effects.
- Adaptive HUD: Real-time score updates that append "m" (meters) to the distance score.

---

## 🏗 Project Structure

```
main.gd: Manages the core game loop, scoring, difficulty scaling, and procedural spawning logic.
bird.gd: Handles physics-based movement, gravity, and animation states.
pipe.gd: Controls randomized obstacle orientations and collision detection.
missile.gd: Logic for ballistic hazards, including launch sounds and explosion effects.
warning.gd: Manages the pre-spawn indicator and sound for incoming missiles.
hud.gd: Responsible for UI management, score tracking displays, and game state buttons.
```

---

## 🎨 Assets & Credits

All visual and audio assets are free-to-use and properly credited.

Credits can be found in:

```
CREDITS.txt
```

---

## 🚀 How to Run

1. Clone the repository.
2. Open the project in Godot 4.x.
3. Run `Main.tscn`.

---

## 📊 Learning Outcomes

This project demonstrates understanding of:

- 2D game physics  
- Collision systems  
- Procedural generation  
- State management  
- Signal-based architecture  
- Game feel balancing  
