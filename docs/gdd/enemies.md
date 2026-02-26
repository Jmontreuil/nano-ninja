# Enemies and Bosses

---

## Enemy AI

### The State Machine
Every enemy is always in exactly one state at a time. The state machine decides which state
the enemy is in and what they do while in it. Each state is self contained and predictable.

Common states:
- **Idle** — standing still, waiting
- **Patrol** — moving along a defined path
- **Chase** — moving toward the player
- **Attack** — executing an attack
- **Stunned** — temporarily unable to act
- **Dead** — playing death sequence, queued for removal

Transitions happen when conditions are met:
- Idle → Patrol when a timer expires
- Patrol → Chase when the player enters detection range
- Chase → Attack when the player enters attack range
- Attack → Chase when the attack finishes and player is still alive
- Any state → Stunned when hit with sufficient force

### Detection
Enemies use two Area2D detection zones:
- A large **detection zone** — the range at which they notice the player and begin chasing
- A smaller **attack zone** — the range at which they can execute an attack

When the player enters either zone a signal fires and the enemy transitions states. No manual
distance checking required every frame.

### Line of Sight
Detection zones alone feel dumb — an enemy detecting you through a wall breaks immersion.
RayCast2D solves this by shooting an invisible line from the enemy toward the player. If the
ray hits a wall before reaching the player, the enemy cannot see them and will not react.
Combined with detection zones this produces enemies that only chase you when they can
actually see you.

### Navigation
Godot's built in NavigationAgent2D handles pathfinding automatically. Rather than moving in
a straight line and getting stuck on walls, enemies calculate a path around obstacles. A
NavigationRegion2D defined in each level tells Godot where enemies are allowed to walk.

---

## Multi-Stage Bosses and Attack Points

### Concept
Large enemies and bosses have multiple attack points that activate in stages. Example: vents
open after an attack cycle to waste heat, and the player must destroy each one to progress
to the next phase.

### Scene Structure
A vent or attack point is its own scene file, instanced into the boss scene. Build once,
instance everywhere.

**Vent.tscn (the reusable component):**
```
Vent (Area2D) ← root
├── CollisionShape2D
├── Sprite2D
└── AnimationPlayer
```

**BossRoot scene using instanced vents:**
```
BossRoot (CharacterBody2D)
├── Sprite2D
├── CollisionShape2D
├── HealthComponent
├── AnimationPlayer
├── AttackCycleManager
├── Vent.tscn (instanced)
├── Vent.tscn (instanced)
└── Vent.tscn (instanced)
```

### Phase Progression via Signals
Each vent emits a signal when destroyed. The AttackCycleManager listens for all of them and
counts. When the count matches the required number, the phase advances. Each vent does not
know about the others — clean, modular, easy to extend.

### Phase Transitions
Each phase transition is a dramatic visual beat — the boss staggers, the screen shakes, new
components reveal themselves, music shifts. Shader work is central here: color grading
shifting to indicate a new dangerous state, vents glowing with increasing intensity, screen
distortion on transition.

### Scaling to Other Enemy Types
The same system scales down to elite enemies. Clone enemies could have specific attack points
— hit the legs to slow, hit the arms to prevent parrying.

---

## Boss Phase Design

### Every Boss Has a Specific Mechanic
One core mechanical identity that runs through every phase of the encounter. The player
always knows what they are doing and why. The mechanic changes in expression, not in nature.

### Phases Are Not Just Health Thresholds
Each phase must feel distinct from the previous one while adhering to the boss's specific
mechanical identity. Phases are distinct gameplay experiences united by a consistent
thematic mechanic.

### Apply to All Boss Encounters

**CEO Final Boss** — the specific mechanic is exposure. Each phase strips away a layer of
corporate protection. Vulnerability increases as defenses are removed. The player is always
working toward the same goal — getting to the man beneath the machine.

**Hard Mode Mech** — the specific mechanic is consequence. Phases are tied to the gauntlet
challenges the player completed. The player's own excellence armed the enemy. Each phase is
a reflection of a choice the player made earlier in the run.

**Secret Boss** — mechanic to be defined. Must have a consistent mechanical identity across
all phases.

---

## Spider Tank — Complex Enemy Case Study

### Concept
A multi-legged mechanical enemy where each leg is an independent target. The body is
partitioned into separate meshes rather than relying on a sprite sheet, enabling dynamic
animation and phase based destruction.

### Why Partitioned Meshes Over Sprite Sheets
- Organic procedural leg movement without drawing every frame
- Dynamic damage reactions — a destroyed leg responds in real time
- Normal maps apply per segment, catching light independently
- Each piece is a separate visual element — damage reads clearly
- Inverse kinematics handles ground contact automatically

### Scene Structure

```
SpiderTank (CharacterBody2D) ← root, main AI script
│
├── Body (Node2D)
│   ├── Sprite2D
│   ├── CollisionShape2D
│   ├── HealthComponent
│   ├── AttackCycleManager
│   ├── Turret (Node2D)
│   │   ├── Sprite2D
│   │   └── GunBarrel (Node2D)
│   │       ├── Sprite2D
│   │       └── Marker2D (projectile spawn point)
│   └── Cockpit (Area2D) ← weak point, exposed in final phase only
│       ├── Sprite2D
│       └── CollisionShape2D
│
├── LegAssembly_FL (LegAssembly.tscn instanced)
├── LegAssembly_FR (LegAssembly.tscn instanced)
├── LegAssembly_ML (LegAssembly.tscn instanced)
├── LegAssembly_MR (LegAssembly.tscn instanced)
├── LegAssembly_RL (LegAssembly.tscn instanced)
└── LegAssembly_RR (LegAssembly.tscn instanced)
```

### LegAssembly.tscn — The Reusable Leg Scene

```
Hip (Node2D) ← root
├── Sprite2D
└── UpperLeg (Node2D)
    ├── Sprite2D
    └── LowerLeg (Node2D)
        ├── Sprite2D
        └── Foot (Node2D)
            ├── Sprite2D
            ├── CollisionShape2D
            └── Area2D (targetable hitbox)
                └── CollisionShape2D
```

Built once, instanced six times. Change the leg scene and all six instances update simultaneously.

### Inverse Kinematics
Godot 4's SkeletonModification2D system with FABRIK handles procedural leg placement. Each
foot has a target position and IK calculates the correct joint angles automatically. Legs
plant themselves realistically as the tank moves, adjusting to terrain beneath them.

### Leg as Independent Target

```gdscript
# leg_assembly.gd
signal sig_leg_destroyed

var leg_health = 30
var is_destroyed = false

func take_damage(amount):
    if is_destroyed:
        return
    leg_health -= amount
    if leg_health <= 0:
        _destroy_leg()

func _destroy_leg():
    is_destroyed = true
    sig_leg_destroyed.emit()
    $Foot/Area2D.monitoring = false
    # Play destruction animation
    # Spawn persistent particles
    # Disable IK target
```

The spider tank root listens for `sig_leg_destroyed` signals from all six legs and responds —
changing movement, altering attack patterns, triggering phase transitions.

### Phase Progression via Leg Count

- **6 legs** — fast, aggressive, full mobility
- **4 legs** — begins limping, movement asymmetric and slower, attack patterns shift
- **2 legs** — barely mobile, becomes more dangerous at range, heavier weapons deployed
- **0 legs** — collapses, cockpit weak point exposed, final phase begins

Each phase asks a different question of the player using the same mechanical language:
- Phase 1: can you navigate a fast moving threat and identify targets?
- Phase 2: can you adapt to unpredictable asymmetric movement?
- Phase 3: can you deal with a stationary but heavily armed threat?
- Phase 4: can you finish a vulnerable target before it recovers?

### Z Index for Leg Rendering
Front legs render in front of the body, rear legs render behind it. Managed per instance —
front assemblies get higher Z index than the body, rear assemblies get lower. The body sits
between them, creating visual depth and the illusion of three dimensionality.

---

## Automated Testing via AI Routines

An AI routine that controls an enemy can equally control a simulated player. The same state
machine logic, navigation system, and decision making can be pointed at the player character
to create a bot that plays the game automatically.

### Use Cases

**Stress testing combat** — spawn a bot player and a large number of enemies and let them
run for an extended period. Crashes and errors surface without manual play.

**Balance testing** — run the bot through a level repeatedly and record statistics. Average
damage taken, dash uses per encounter, time to clear a room. Outliers indicate balance problems.

**Regression testing** — after significant code changes, run the bot through affected areas
and compare statistics to previous runs.

**Pathfinding verification** — a bot attempting to navigate every area of the level will
quickly expose places where enemies or the player get stuck.

**Combat system verification** — automated testing can confirm that the combo loop activates
correctly, nano contagion spreads to the right targets, and i-frames activate and deactivate
at the correct moments.

### Key Advantage
No separate testing codebase is required. Enemy AI systems and test bots share the same
logic pointed in different directions. Systems built for gameplay double as quality assurance tools.

---

## Patrol Drone — First Enemy

### Concept
The first enemy the player encounters. Simple, readable, non-threatening alone. Teaches the dash interaction early at minimal cost.

---

### Visual Design
**Body:** Tall and narrow central column. Soft white plastic with thin engraved detail lines. Reads cleanly against the dark arcology palette.

**Legs:** Four legs, tall and narrow. Crab-like stance and movement. Sharp toes — the attack surface. At target pixel height legs will be approximately 2-3 pixels wide — four legs keeps the silhouette readable at small sizes.

**Face:** Dead center — a bright red circular lens surrounded by a chrome circular bracket. Single focal point. The player's eye goes immediately to the red lens, which is also where the danger communicates from. Good design economy — the visual focal point and the threat read from the same place.

**Color language:** Soft white and chrome against dark blues, greens, and purples of the arcology. High contrast without being visually complex. Reads clearly at combat distance.

---

### Movement
Crab-like lateral movement. The tall narrow body moves above the legs without rotating — the legs do the directional work while the central column stays upright. At the cavalier oblique camera angle the leg movement will be very readable from above, the body will read as a vertical column.

---

### Attack — Leg Jab
One leg facing the player lifts and jabs forward with the sharp toe. The lifting leg breaks the crab movement pattern — a readable tell that an attack is incoming.

**Damage:** Minimal. This enemy is an introduction, not a threat.

**Dash interaction:**
- Dashing into the jab during the active frames knocks the player back and cancels the dash
- Teaches early that dashing is not unconditionally safe
- Some attacks punish committed dashes — this is the first lesson

---

### Dash Punishment — Design Note
The patrol drone introduces the dash punishment mechanic at minimal cost. The knockback is small, the damage is low, the lesson is gentle.

Harder enemies scale this interaction significantly:
- Larger enemies have attacks that deal more damage on a blocked dash
- The lesson taught cheaply by the patrol drone is paid off harshly by later enemies
- Players who learn to read attack tells early are rewarded later
- Players who dash carelessly are punished progressively harder

This is a difficulty curve that lives in the combat system rather than in enemy health values. The player gets smarter or they get punished.

---

### Role in the Game
- First combat encounter — sets expectations for the combat system
- Teaches: dashing is not always safe, attacks have readable tells
- Low threat alone, moderate threat in groups
- Visually establishes the corporate security aesthetic — clean, manufactured, clinical. The arcology's maintenance drones repurposed or redeployed as security assets.
