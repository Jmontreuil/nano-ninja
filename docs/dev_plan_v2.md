# Cyberpunk Ninja — Game Development Plan
### Version 2 — February 23 2026

> Based on the wiki GDD. This is a living document — phases are sequential
> but will flex as the project evolves.
>
> **Changelog v2:** Added incremental visual development note to Phase 8.
> Clarified Phase 1 combat as placeholder. Added wiki and documentation
> organisation as Phase 0 task. Added code conventions and daily workflow
> documents to project setup. Added timed mode and speedrun infrastructure
> to Phase 7. Added accessibility toggles to Phase 9.
>
> **Changelog v3:** Moved gestural combat system to Phase 1 as the core
> prototype deliverable. Removed old Phase 5 gestural deep pass — it is
> now integrated into Phase 1 from the start. Added moveset forking and
> debug room moveset selector. Added Phase 0.5 Visual Foundation Sprint.
> Added pixel art shader pipeline as side hustle consideration.

---

## Phase 0 — Foundation
*Project setup and engine configuration. Do this once, do it right.*

- [x] Create Godot 4.5 project with Compatibility renderer
- [x] Connect project to GitHub repository
- [ ] **Organise wiki and documentation** — ingest all session documents,
      establish main wiki index page with table of contents linking all
      other documents
- [ ] Configure Input Map — all named actions for movement, aim, parry,
      shoulder buttons
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
  /debug
/assets
  /sprites
  /audio
  /shaders
/docs
  wiki.md              ← main index with table of contents
  design_pillars.md
  code_conventions.md
  dev_diary.md
  dev_workflow.md
```

- [ ] Set base viewport resolution and pixel scaling settings
- [ ] Add `.gitignore` for Godot
- [ ] Add `code_conventions.md` to `/docs`
- [ ] Add `dev_workflow.md` to `/docs`
- [ ] Create `dev_diary.md` in `/docs` — first entry on project start

---

## Phase 0.5 — Visual Foundation Sprint
*Establish the visual grammar of the game before anything is built on top
of it. These decisions become assumptions everything else rests on.*

> **Why this comes before Phase 1:** The pixel art shader pipeline defines
> how every effect in the game looks. The scaling system defines how every
> space in the game feels. Building the prototype without these settled
> means building on assumptions that may need to change — which is
> significantly more expensive to fix mid-development than to establish
> correctly at the start.

### Pixel Art Shader Pipeline
- [ ] Set up a dedicated test scene for shader experimentation
- [ ] Implement and tune the five core techniques:
  - [ ] Pixelation — UV quantization to pixel grid
  - [ ] Palette restriction — hard steps between defined palette colors
  - [ ] Hand-painted noise texture — create first test texture in Aseprite
  - [ ] Dithering — ordered Bayer matrix dither instead of smooth alpha
  - [ ] Framerate quantization — TIME snapped to sprite animation fps
- [ ] Validate pipeline with the practical test — shader frame vs sprite
      frame at same zoom, same visual language
- [ ] Define and lock pixel size constant used across all shaders
- [ ] Define and lock the game palette as shader uniforms
- [ ] Document pipeline settings in `docs/visual_bible.md`
- [ ] Package techniques as reusable shader includes for later use
- [ ] Note: this work is also R&D for a potential pixel art shader
      asset pack — document decisions and reasoning throughout

### Scaling System
- [ ] Set up FloorTransitionManager in a test scene
- [ ] Experiment with camera-tied vs independent tween modes
- [ ] Tune and settle zoom range across floor tiers
- [ ] Tune and settle player scale values per tier
- [ ] Tune tween duration and easing curves
- [ ] Validate the smallness feeling — player dwarfed by environment
      reads correctly at the smallest zoom level
- [ ] Validate enemy and sprite readability at all zoom levels
- [ ] Lock values and document in `docs/visual_bible.md`

### Visual Bible Document
- [ ] Create `docs/visual_bible.md` capturing all locked visual decisions:
  - Pixel size constant
  - Game palette — all defined colors with hex values
  - Shader animation framerate
  - Camera zoom range and per-floor values
  - Player scale range and per-floor values
  - District tone mapping signatures — brightness, saturation, contrast
    per arcology district
  - CanvasLayer stack with motion_scale values

**Milestone:** Pixel art shader pipeline is validated and documented.
Scaling system feel is established and locked. Visual bible exists.
Phase 1 prototype is built inside a defined visual framework.

---

## Phase 1 — Core Prototype
*The elevator pitch first. Get the gestural combat system working and
feeling right before anything else is built on top of it.*

> **Why gestural input is here and not later:** The gestural system is
> the combat system — not a polish pass on it. A placeholder attack cannot
> validate the combat loop, reward window timing, parry feel, or nano
> system. Tuning against the wrong system produces findings that don't
> transfer. Technical risk in gesture recognition surfaces here where it
> costs least to address. Every hour of playtesting the real system is
> more valuable than any amount of playtesting a placeholder.

### Player Movement
- [ ] `CharacterBody2D` player scene with `CollisionShape2D`
- [ ] Left stick movement via `Input.get_vector()`
- [ ] Acceleration and deceleration via lerp
- [ ] Single dash — the core resource
- [ ] Dash signals — `sig_dash_started`, `sig_dash_ended`, `sig_dash_ready`
- [ ] Invulnerability signals — `sig_invulnerability_started`,
      `sig_invulnerability_ended`
- [ ] IFrameManager node — listens to invulnerability signals

### Gestural Combat System — Core
*Full gesture recognition from day one. Move library expands over time
but the reading system must be correct before anything else is built.*
- [ ] Right stick raw input sampling every physics frame
- [ ] Gesture buffer — rolling window of recent stick positions
- [ ] Approach vector capture — direction of movement toward target
- [ ] Raw stick input translated relative to approach vector
      (rotate by inverse of approach angle)
- [ ] Pattern matcher — reads gesture buffer against move definitions
- [ ] First gesture implemented end to end — quarter circle producing
      one attack with correct hitbox, signal, and visual
- [ ] Moveset resource system — moves defined as data, not hardcoded
- [ ] Moveset forking — ability to swap active moveset in debug room
      for testing alternate move definitions
- [ ] Shoulder button modifier integration
- [ ] Time slow on charge — 0.85x base speed

### Combat Loop
- [ ] Hit detection — `Area2D` hitbox and hurtbox
- [ ] Reward window on successful hit → dash refresh signal
- [ ] Parry — timed shoulder input, distinct from attack
- [ ] Parry assist toggle — auto-parry during charge
- [ ] Combo system — chaining gestures through reward windows

### Debug Room
- [ ] Debug room scene — floor, borders, obstacles, spawn points
- [ ] Debug manager script — exported scene references, spawn logic
- [ ] Moveset selector — dropdown or export to swap active moveset
- [ ] Debug quality of life — live state display including current
      gesture buffer, active moveset name, last recognised gesture
- [ ] Reset button (R), slow motion toggle (T)
- [ ] Save as `debug_room_template.tscn`

### Placeholder Enemy
- [ ] Static or pacing enemy with a hurtbox
- [ ] Takes damage, dies
- [ ] No AI yet — just a target to validate gesture recognition against

**Milestone:** Gesture recognition system reads stick input correctly.
At least one move works end to end — gesture → attack → hit detection →
reward window → dash refresh. Combat loop is validated against the real
system. Moveset forking works in the debug room.

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

**Milestone:** Stage 1 is playable start to finish. No upgrades. Player
learns dash and combat loop.

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

**Milestone:** Stage 2 is playable. Upgrades work. Collectible choice is
live. Nano is introduced.

---

## Phase 4 — Nano System
*The deepest combat system. Build it right before building on top of it.*

### Nano Core
- [ ] Nano state component — applied per enemy, tracks active types
      and buildup
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

**Milestone:** Full nano system functional. Parry → contagion → burst
chain works end to end.

---

## Phase 5 — Challenge Tiers
*Layer the optional challenge systems on top of the working base game.*

### Tier 2 — Secret Boss
- [ ] Track whether all collectibles are saved (zero spent)
- [ ] Secret final boss scene — locked behind collectible condition
- [ ] Boss fight design (to be developed)
- [ ] Boss phase design — consistent mechanic across all phases

### Tier 3 — Gauntlet
- [ ] Gauntlet trigger — forfeit all upgrade points, irreversible
- [ ] Confirmation screen with in-universe framing
- [ ] Gauntlet state flag — single dash locked, no upgrades
- [ ] Environmental gauntlet — hazards activate, building destabilises
- [ ] Opt-out implementation (in-world terminal or stabilisation zones)
- [ ] Mech boss fight on ruined building rooftop
- [ ] Hard mode ending sequence
- [ ] Mech phases tied to gauntlet challenges completed — player's
      excellence arms the enemy

### Tier 4 — Hidden Layer
- [ ] Condition: all collectibles saved AND all upgrades forfeited
- [ ] Hidden ending — to be developed

**Milestone:** All four challenge tiers are triggerable. Tier 3 gauntlet
is completable.

---

## Phase 7 — Endless and Tower Mode
*Replayability layer. Exploits the combat and nano systems built earlier.*

- [ ] Combat simulator framing — in-universe lab
- [ ] Sterile mode — clean, corporate, committee-designed default
- [ ] Hacked mode — chaotic, unlocked via hidden code or sterile completion
      (created by rebellious young scientist character)
- [ ] Stage Select mode — hand-crafted room pool
- [ ] Random Mode — procedural room selection with seeded randomization
- [ ] Endless Mode — fully upgraded power fantasy loop
- [ ] Tower Mode — structured escalating challenge
- [ ] Procedural modifier system — random rule sets per run
  - No parry, double nano spread speed, double dash start,
    meter starts full, etc.

### Speedrun Infrastructure
- [ ] Skippable cutscenes — all story sequences skippable from day one
- [ ] Seeded randomization — same seed produces same run
- [ ] Clear load boundaries between scenes for load time removal
- [ ] Timed mode UI layer — overall time, split times at checkpoints,
      challenge checklist
- [ ] Split points: end of stage 1, surgical lab awakening, each boss,
      final confrontation
- [ ] Randomizer mode — collectibles, upgrade contents, enemy placements
      shuffled within constraints

**Milestone:** Endless mode is playable with modifier variety. Timed mode
is functional.

---

## Phase 8 — Polish Pass
*The game is feature-complete. Now make it feel good.*

> **Note:** Visual development should happen incrementally throughout all
> phases rather than deferred entirely to this pass. Shaders, normal maps,
> canvas layer configuration, and color direction should be established
> early and refined here. This phase is a final polish pass, not a
> first visual pass.

### Visual
- [ ] `WorldEnvironment` — glow, tonemapping, colour correction
- [ ] `CanvasModulate` darkness with `PointLight2D` punch-through
- [ ] Shader pass — hit flash, enemy outline, nano spread visual, dissolve
- [ ] `GPUParticles2D` — nano clouds, impacts, bursts
- [ ] Each nano type has a distinct visual language
- [ ] Normal maps applied to player, enemies, and key environment elements
- [ ] Rim lighting — player and enemy silhouette separation
- [ ] Scene-wide shader effects — nano surge, combo threshold shift,
      matter projection reveal

### Audio
- [ ] Combat SFX — hits, parry, dash
- [ ] Nano SFX — spread, detonation chain, burst
- [ ] Music system — stage tracks, tension layers
- [ ] Audio bus setup — master, SFX, music, UI

### Game Feel
- [ ] Screenshake on impact
- [ ] Hitpause (brief freeze on hit)
- [ ] Camera smoothing and lock-on assist
- [ ] `AnimationTree` wired up for smooth combat transitions
- [ ] Persistent particle accumulation during skilled play
- [ ] Camera zoom thresholds tied to combo count

---

## Phase 9 — UI and HUD
- [ ] HUD — nano charge meter, dash indicator, health
- [ ] Upgrade menu — clean, usable at terminals
- [ ] Pause menu — settings, quit, gauntlet surrender option
- [ ] Main menu — new game, continue, mode select
- [ ] Device detection — swap controller/keyboard prompts dynamically
- [ ] Accessibility — colorblindness support, user definable color wheel
      with presets
- [ ] Parry assist toggle — independent from other accessibility options
- [ ] Resilience scaling toggle — independent easy mode, progressive
      damage reduction per death
- [ ] Timed mode UI — run timer, split display, challenge checklist

---

## Phase 10 — Testing and Launch
- [ ] Full playthrough — all tiers tested
- [ ] Balance pass — enemy health, damage, nano thresholds, upgrade costs
- [ ] Performance check — particle counts, scene complexity
- [ ] Speedrun pass — verify all cutscenes skippable, splits firing
      correctly, seeding consistent
- [ ] Build and export settings configured
- [ ] Release

---

## Side Tasks — Ongoing

- [ ] **Markdownception** — beginner overview of markdown syntax,
      generated as a markdown document
- [ ] **Pixel art shader pipeline experimentation** — dedicated session
      to build and tune the five pixel art shader techniques before visual
      development begins in earnest. Foundational to visual identity.
      Do before Phase 2 level building.
- [ ] **Scaling system experimentation** — dedicated session with the
      FloorTransitionManager to establish correct zoom range, player scale
      values, tween settings, and camera-tie behaviour. Foundational to
      level design. Do before hub room is built.
- [ ] Publishing to game consoles
- [ ] Publishing to web
- [ ] Debug layers in Godot
- [ ] Git hook for diary reminder at commit time
- [ ] Controller setup — connect physical controller and configure
      in Godot
- [ ] Promotional idle game design pass

---

*Created: Session 1 — February 22 2026*
*Revised: Session 2 — February 23 2026*
