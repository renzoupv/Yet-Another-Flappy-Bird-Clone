# 🐦 Flappy Chaos

A Flappy Bird clone with dynamic disruption mechanics built in Godot 4.

---

## 📖 Project Description

Flappy Chaos is an original Godot 4 implementation inspired by Flappy Bird, featuring a unique mechanical twist: roaming airborne hazards that temporarily destabilize gameplay. Players must navigate through procedurally generated pipe gaps using gravity-based flapping mechanics while avoiding both static obstacles and randomly spawning birds that fly across the screen.

Colliding with these roaming birds does not immediately end the game; instead, it triggers a temporary screen shake effect that disrupts visibility and increases difficulty before returning to normal gameplay.

This project focuses on clean architecture, proper state management, procedural obstacle spawning, and signal-driven communication between scenes while maintaining tight game feel and responsive controls.

---

## 🎮 Gameplay Overview

- Press input to flap upward.
- Gravity constantly pulls the bird downward.
- Pipes spawn procedurally and scroll from right to left.
- Passing through pipe gaps increases score.
- Collision with pipes or ground ends the game.

---

## 🌀 Mechanical Twist: Flying Hazards

Random birds spawn from the right side of the screen and travel left.

If the player collides with a flying hazard:

- The game does not immediately end.
- A temporary screen shake effect is triggered.
- Visibility and precision are impaired for a short duration.
- After the effect ends, gameplay returns to normal.

This mechanic introduces dynamic tension and recovery-based gameplay, rewarding adaptability rather than punishing every mistake with instant failure.

---

## 🧠 Architecture & Design

This project demonstrates:

- Strongly typed GDScript usage  
- Enum-based finite state machine (Idle / Playing / Game Over)  
- Scene separation:
  - Player
  - Pipe
  - HazardBird
  - UI
  - Main controller
- Signal-driven communication (score updates, state transitions, collisions)
- Procedural pipe spawning system
- Temporary environmental effects (screen shake system)
- Clean separation of movement, scoring, and collision logic  

Architecture prioritizes readability, modularity, and maintainability.

---

## 🕹 Controls

| Action  | Input |
|----------|--------|
| Flap     | Space / Mouse Click |
| Restart  | Press after Game Over |

---

## ⚙️ Technical Features

- Physics-based vertical movement  
- Procedural obstacle generation  
- Dynamic difficulty via hazard spawning  
- Screen shake system using Camera2D offsets  
- Collision detection using Area2D nodes  
- Clean state transitions via FSM  

---

## 🏗 Project Structure

```
Main.tscn
Bird.tscn
Pipe.tscn
HazardBird.tscn
HUD.tscn
```

Each system is isolated to prevent spaghetti code and ensure architectural integrity.

---

## 🎨 Assets & Credits

All visual and audio assets are free-to-use and properly credited.

Credits can be found in:

```
CREDITS.txt
```

---

## ⚠️ Known Limitations

- Screen shake may slightly affect UI readability.
- Hazard spawn timing is randomized within a defined interval.
- Object pooling is not implemented (basic spawn/despawn system used).

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
