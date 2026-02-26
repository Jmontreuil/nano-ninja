# Prompt for Antigravity — Debug Room Enemy and Animation Scaffold

---

Two additions to make to the existing plan. Read both before starting
anything.

---

## 1. Add Patrol Drone to the Debug Room

The debug room already has three enemy spawn points. Add the patrol
drone as the first enemy scene to populate them.

The patrol drone is the first enemy the player encounters in the game.
Design brief:
- Tall narrow central body, soft white plastic with thin detail lines
- Four legs, tall and narrow, crab-like movement
- Bright red circular lens dead center, surrounded by a chrome bracket
- Attack: one leg lifts and jabs forward with a sharp toe
- Dash interaction: dashing into the active jab frames knocks the
  player back and cancels the dash
- Damage is minimal — this enemy is an introduction

For the debug room, one patrol drone spawning at one of the spawn
points is enough to start. We are testing the combat system, not
building a full encounter.

---

## 2. Animation Scaffold — Player and Patrol Drone

I want a signal-driven animation base for both the player and the
patrol drone. This is not a full animation pipeline — it is the
architecture. Placeholder sprites are fine. Final art drops in later
without touching the logic.

**The goal:** signals trigger animation states, animation states play
the correct clip. Nothing more.

For the player, wire these existing signals to AnimationPlayer clips:
- `sig_dash_started` → dash animation
- `sig_dash_ended` → return to idle
- `sig_invulnerability_started` → i-frame visual state

For the patrol drone, two states are enough for now:
- Idle — crab movement loop
- Attack — leg lift and jab

Write an AnimationController script that sits between the signals and
the AnimationPlayer. It listens, it drives. It does not contain game
logic.

Before writing any code, ask me if I want to try the next step myself
or if I want your help. Follow the tutoring protocol in
docs/dev_workflow.md under the Tutoring section.

---

## Notes

- Read docs/code_conventions.md before writing any code
- The scaffold is the deliverable — placeholder art is expected
- Do not start building final character art yet
- The animation signal names for attacks are not defined yet —
  stub them with a comment and we will define them in Phase 1
