# Wiki Additions — Session February 23 2026 (Part 4)

---

## Spider Tank — Complex Enemy Case Study

### Concept
A multi-legged mechanical enemy where each leg is an independent target.
The body is partitioned into separate meshes rather than relying on a
sprite sheet, enabling dynamic animation and phase based destruction.

### Why Partitioned Meshes Over Sprite Sheets
Sprite sheets pre-draw every frame — a partitioned mesh approach with
AnimationPlayer keyframes individual node rotations in real time.
Benefits:
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
│   ├── Turret (Node2D) ← rotates independently to aim
│   │   ├── Sprite2D
│   │   └── GunBarrel (Node2D)
│   │       ├── Sprite2D
│   │       └── Marker2D (projectile spawn point)
│   └── Cockpit (Area2D) ← weak point, exposed in final phase only
│       ├── Sprite2D
│       └── CollisionShape2D
│
├── LegAssembly_FL (LegAssembly.tscn instanced) ← front left
├── LegAssembly_FR (LegAssembly.tscn instanced) ← front right
├── LegAssembly_ML (LegAssembly.tscn instanced) ← mid left
├── LegAssembly_MR (LegAssembly.tscn instanced) ← mid right
├── LegAssembly_RL (LegAssembly.tscn instanced) ← rear left
└── LegAssembly_RR (LegAssembly.tscn instanced) ← rear right
```

### LegAssembly.tscn — The Reusable Leg Scene

```
Hip (Node2D) ← root, attachment point to body
├── Sprite2D
└── UpperLeg (Node2D)
    ├── Sprite2D
    └── LowerLeg (Node2D)
        ├── Sprite2D
        └── Foot (Node2D)
            ├── Sprite2D
            ├── CollisionShape2D (physical contact)
            └── Area2D (targetable hitbox — independent of physics)
                └── CollisionShape2D
```

Built once, instanced six times. Change the leg scene and all six
instances update simultaneously.

### Inverse Kinematics
Godot 4's SkeletonModification2D system with FABRIK (Forward And Backward
Reaching Inverse Kinematics) handles procedural leg placement. Rather than
manually keyframing each position, each foot has a target position and IK
calculates the correct joint angles automatically. Legs plant themselves
realistically as the tank moves, adjusting to terrain beneath them.

### Leg as Independent Target
Each leg manages its own health and destruction independently:

```gdscript
# LegAssembly.gd
signal leg_destroyed

var leg_health = 30
var is_destroyed = false

func take_damage(amount):
    if is_destroyed:
        return
    leg_health -= amount
    if leg_health <= 0:
        destroy_leg()

func destroy_leg():
    is_destroyed = true
    leg_destroyed.emit()
    $Foot/Area2D.monitoring = false
    # Play destruction animation
    # Spawn persistent particles
    # Disable IK target
```

The spider tank root listens for leg_destroyed signals from all six legs
and responds — changing movement, altering attack patterns, triggering
phase transitions.

### Phase Progression via Leg Count
Each phase threshold is the leg_destroyed counter reaching a number.
The phase system already designed for boss structure handles this naturally.

- **6 legs** — fast, aggressive, full mobility
- **4 legs** — begins limping, movement asymmetric and slower,
  attack patterns shift to compensate
- **2 legs** — barely mobile, becomes more dangerous at range,
  heavier weapons deployed
- **0 legs** — collapses, cockpit weak point exposed, final phase begins

### Z Index for Leg Rendering
Front legs render in front of the body, rear legs render behind it.
Managed per instance — front assemblies get higher Z index than the body,
rear assemblies get lower. The body sits between them, creating visual
depth and the illusion of three dimensionality.

### Visual Opportunity
With normal maps per segment and rim lighting catching edges, each leg
section catches light independently as the tank moves. Joints show depth
through normal mapping. Combat damage — missing legs, sparking joints,
exposed wiring — reads clearly because each piece is a separate visual
element with its own shader state.

---

## Shader Resources

### Primary Resources

**godotshaders.com** — the main community shader library. Free shaders
for personal and commercial use. Every shader is open source and readable
— a learning resource as much as a library. First stop for any shader need.

**GDQuest Godot Shaders GitHub repository** — a large library of free
open source shaders with playable demos for each one. High quality and
well documented. All source code available under MIT license. GDQuest is
one of the most respected Godot education and resource channels.

**Shader-Lib** — a visual shader node library that adds extra nodes to
Godot's built in visual shader editor. Supports Godot 4.2 and above.
Directly relevant to the visual shader experimentation planned for early
development.

**The Godot Shaders Bible** — a learning resource written by a senior
technical artist with extensive industry experience. Covers shader
fundamentals through to complex effects including cloud simulation,
stylized shading, and screen space post processing. Recommended when
ready to go deeper on shader writing beyond the visual editor.

### Notes on the Ecosystem
No single paid marketplace exists for Godot shaders the way Unity's
Asset Store does. The ecosystem is younger but growing fast and almost
everything is MIT licensed — full freedom to read, modify, and ship
custom versions. This aligns with the goal of creating custom presets
from existing starting points.

For the specific visual goals of this game — rim lighting, normal map
interaction, scene wide color grading, nano effects — godotshaders.com
and the GDQuest repository between them provide starting points for
almost everything. The visual shader editor then allows combining and
modifying them without writing code from scratch.

---

## Design Pillars Addition — Boss Phase Design

### Boss Encounters Should Change Phase to Phase
Each phase of a boss encounter should feel distinct from the previous one
while adhering to a specific mechanical identity that defines that boss.
Phases are not just health thresholds — they are distinct gameplay
experiences united by a consistent thematic mechanic.

**The Spider Tank as the Model:**
The specific mechanic is legs. Legs are the main obstacle throughout
the entire encounter. The tank changes its attack patterns, movement
speed, and aggression based on how many legs remain — but legs are always
the focus. The player always knows what they are doing and why.

Each phase should ask a different question of the player using the same
mechanical language:
- Phase 1 asks: can you navigate a fast moving threat and identify targets?
- Phase 2 asks: can you adapt to unpredictable asymmetric movement?
- Phase 3 asks: can you deal with a stationary but heavily armed threat?
- Phase 4 asks: can you finish a vulnerable target before it recovers?

The mechanic is consistent. The expression of it changes.

**Apply to All Boss Encounters:**
- CEO final boss — each phase strips away a layer of corporate protection,
  the specific mechanic is exposure and vulnerability increasing as
  defenses are removed
- Hard mode mech — phases tied to the gauntlet challenges completed,
  the specific mechanic is the player's own excellence arming the enemy
- Secret boss — mechanic to be defined, but must have a consistent
  mechanical identity across all phases
