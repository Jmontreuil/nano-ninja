# Cyberpunk Ninja — Game Development Plan

> Based on the wiki GDD. This is a living document — phases are sequential but will flex as the project evolves.

---

## Phase 0 — Foundation
*Project setup and engine configuration. Do this once, do it right.*

- [x] Create Godot 4.5 project with Compatibility renderer
- [x] Connect project to GitHub repository
- [ ] Configure Input Map — all named actions for movement, aim, parry, shoulder buttons
- [ ] Establish folder structure

```
/scripts
  /player
  /enemies
  /combat
  /nano
  /ui
/scenes
  /player
  /enemies
  /levels
  /ui
/assets
  /sprites
  /audio
  /shaders
/docs
  wiki.md
```

- [ ] Set base viewport resolution and pixel scaling settings
- [ ] Add `.gitignore` for Godot

---

## Phase 1 — Core Prototype
*Get a character moving and attacking. Nothing else matters yet.*

### Player Movement
- [ ] `CharacterBody2D` player scene with `CollisionShape2D`
- [ ] Left stick movement via `Input.get_vector()`
- [ ] Single dash — the core resource
- [ ] Basic gravity / grounding (if platformer elements exist) or top-down movement

### Basic Combat Loop
- [ ] Right stick input reading and gesture detection
- [ ] Single attack on gesture input
- [ ] Hit detection using `Area2D` hitbox / hurtbox
- [ ] Reward window on successful hit → dash refresh
- [ ] Parry — timed shoulder input, distinct from attack

### Placeholder Enemy
- [ ] Static or pacing enemy with a hurtbox
- [ ] Takes damage, dies
- [ ] No AI yet — just a target to test combat against

**Milestone:** Player can move, dash, attack, parry, chain a combo, and kill a placeholder enemy.

---

## Phase 2 — Stage 1 (The Sewers)
*First playable stage. Teaches the game in its most constrained form.*

### Level Design
- [ ] TileMap setup — TileSet with terrain autotiling
- [ ] Ground, wall, and detail layers
- [ ] Collision per tile configured
- [ ] Hand-crafted sewer environment layout

### Enemy Pass 1
- [ ] Basic human enemy with simple patrol AI
- [ ] Attack behaviour — wind-up, strike, cooldown
- [ ] Enemy takes damage from player gestures
- [ ] Death state and removal

### Stage Flow
- [ ] Stage entry and exit points
- [ ] End of stage capture sequence (scripted / cutscene)
- [ ] Scene transition to Stage 2

**Milestone:** Stage 1 is playable start to finish. No upgrades. Player learns dash and combat loop.

---

## Phase 3 — Chip and Upgrade System
*Stage 2. The chip implant opens everything up.*

### Nano Computer Terminals
- [ ] Terminal scene — `Area2D` interaction zone + UI
- [ ] Proximity detection (chip range does not expand)
- [ ] Terminal unlocks story beat / upgrade menu

### Collectible Resource
- [ ] Collectible item scene — spawnable, trackable
- [ ] Global tracker (spent vs. saved)
- [ ] UI display for current count

### Upgrade System
- [ ] Upgrade data structure (resources or dictionary)
- [ ] Upgrade menu UI — accessible at terminals
- [ ] Movement path: double dash unlock
- [ ] Damage path: knockback and armour break unlock
- [ ] Nano path: first nano effect unlock
- [ ] Refund Station scene — free respec anywhere

### Stage 2 Build
- [ ] Awakening sequence — scripted intro
- [ ] Surgical lab environment (TileMap)
- [ ] Three terminals — one per upgrade path
- [ ] Collectible resource seeded throughout

**Milestone:** Stage 2 is playable. Upgrades work. Collectible choice is live. Nano is introduced.

---

## Phase 4 — Nano System
*The deepest combat system. Build it right before building on top of it.*

### Nano Core
- [ ] Nano state component — applied per enemy, tracks active types and buildup
- [ ] Parry applies nano to attacker
- [ ] Contagion spread — nano transfers on kill or critical hit

### Nano Effects
- [ ] **Nano Corrosion** — armour decay over time
- [ ] **Nano Swarm** — DoT cloud, spreads on kill
- [ ] **Nano Trace** — mark enemy, network damage amplification
- [ ] **Nano Overload** — threshold detonation, chain explosions
- [ ] **Nano Heal** — passive regen tied to combat performance

### Nano Charge Meter
- [ ] Meter fills on successful parries
- [ ] Nano burst — room-wide pulse applying active nano to all enemies
- [ ] Visual and audio feedback for meter state and burst

### Nano Interactions
- [ ] Interaction table — corrosion + swarm compound effect, etc.
- [ ] Threshold detection triggering emergent effects

**Milestone:** Full nano system functional. Parry → contagion → burst chain works end to end.

---

## Phase 5 — Gestural Combat (Deep Pass)
*Upgrade the placeholder attack to the full gestural input system.*

- [ ] Right stick gesture pattern matching
- [ ] Translate raw stick input relative to approach vector (rotate by inverse of approach angle)
- [ ] Move library — quarter circles, arcs, directional combinations
- [ ] Approach angle modifiers — downward vs. horizontal approach variants
- [ ] Shoulder button modifier roles finalised
- [ ] Combo system — chaining gestures through reward windows

**Milestone:** The full gestural combat system is live. Combat feels distinct from Phase 1 placeholder.

---

## Phase 6 — Challenge Tiers
*Layer the optional challenge systems on top of the working base game.*

### Tier 2 — Secret Boss
- [ ] Track whether all collectibles are saved (zero spent)
- [ ] Secret final boss scene — locked behind collectible condition
- [ ] Boss fight design (to be developed)

### Tier 3 — Gauntlet
- [ ] Gauntlet trigger — forfeit all upgrade points, irreversible
- [ ] Confirmation screen with in-universe framing
- [ ] Gauntlet state flag — single dash locked, no upgrades
- [ ] Environmental gauntlet — hazards activate, building destabilises
- [ ] Opt-out implementation (in-world terminal or stabilisation zones)
- [ ] Mech boss fight on ruined building rooftop
- [ ] Hard mode ending sequence

### Tier 4 — Hidden Layer
- [ ] Condition: all collectibles saved AND all upgrades forfeited
- [ ] Hidden ending — to be developed

**Milestone:** All four challenge tiers are triggerable. Tier 3 gauntlet is completable.

---

## Phase 7 — Endless and Tower Mode
*Replayability layer. Exploits the combat and nano systems built in earlier phases.*

- [ ] Combat simulator framing — in-universe lab
- [ ] Stage Select mode — hand-crafted room pool
- [ ] Random Mode — procedural room selection
- [ ] Endless Mode — fully upgraded power fantasy loop
- [ ] Tower Mode — structured escalating challenge
- [ ] Procedural modifier system — random rule sets per run
  - No parry, double nano spread speed, double dash start, meter starts full, etc.

**Milestone:** Endless mode is playable with modifier variety.

---

## Phase 8 — Polish Pass
*The game is feature-complete. Now make it feel good.*

### Visual
- [ ] `WorldEnvironment` — glow, tonemapping, colour correction
- [ ] `CanvasModulate` darkness with `PointLight2D` punch-through
- [ ] Shader pass — hit flash, enemy outline, nano spread visual, dissolve
- [ ] `GPUParticles2D` — nano clouds, impacts, bursts
- [ ] Each nano type has a distinct visual language

### Audio
- [ ] Combat SFX — hits, parry, dash
- [ ] Nano SFX — spread, detonation chain, burst
- [ ] Music system — stage tracks, tension layers
- [ ] Audio bus setup — master, SFX, music, UI

### Game Feel
- [ ] Screenshake on impact
- [ ] Hitpause (brief freeze on hit)
- [ ] Camera smoothing and lock-on assist
- [ ] AnimationTree wired up for smooth combat transitions

---

## Phase 9 — UI and HUD
- [ ] HUD — nano charge meter, dash indicator, health
- [ ] Upgrade menu — clean, usable at terminals
- [ ] Pause menu — settings, quit, gauntlet surrender option
- [ ] Main menu — new game, continue, mode select
- [ ] Device detection — swap controller/keyboard prompts dynamically

---

## Phase 10 — Testing and Launch
- [ ] Full playthrough — all tiers tested
- [ ] Balance pass — enemy health, damage, nano thresholds, upgrade costs
- [ ] Performance check — particle counts, scene complexity
- [ ] Build and export settings configured
- [ ] Release

---

*Created: Session 1 — February 22 2026*
