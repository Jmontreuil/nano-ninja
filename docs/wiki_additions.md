# Wiki Additions — Session February 22 2026

---

## Hard Mode — Gauntlet Trigger and Environmental Design

### The Overcharge Trigger
Activating hard mode is framed in-universe as overcharging the matter replication
system. The player is not simply forfeiting their upgrades — they are weaponising
the corporation's own infrastructure against itself. The building becomes hostile
to everyone, including the player. This gives the mechanical sacrifice narrative
weight: you are not just choosing to be weaker, you are choosing to destabilise
everything.

### The Environmental Gauntlet
With the matter replication system overloaded, the building itself becomes the
gauntlet. Matter projections destabilise unpredictably, environmental hazards
activate, and the structure begins coming apart. The final mech fight takes place
on top of the ruined building and includes a significant environmental challenge
component — the arena itself is dangerous, not just the mech.

### CEO Mech Progression
Rather than the gauntlet being a single brutal sprint, it is a structured narrative
journey. The CEO starts in a basic suit — relatively vulnerable. Each challenge
completed in the gauntlet feeds the in-game narrative of the suit being developed
around him in real time. Engineers scramble, components are rushed into place, the
corporation throws everything at containing you.

Each completed challenge adds a new phase to the final fight:
- Complete no challenges — the final boss is manageable
- Complete some challenges — the fight escalates
- Complete all challenges — face the fully realised mech, the hardest possible version

The difficulty scales with how much of the gauntlet the player completes rather
than being binary. The narrative justification is built in — the player watches
the boss get stronger as they fight through the building.

**Thematic note:** The harder you push through the gauntlet, the more formidable
you make your final opponent. Your own excellence arms your enemy.

### Opt-Out Options
Players who trigger the gauntlet may want a way out. Options under consideration:

- **Point of no return warning** — a clear confirmation screen before the overcharge
  locks in, with language like "the matter replication system is destabilising —
  there is no return from this." No mid-gauntlet exit, but no accidental triggers.
- **Surrender with cost** — players can exit via pause menu at any time, but doing
  so permanently costs upgrade points for that run. Quitting is possible but not free.
- **Physical in-world exit** — an in-universe emergency terminal somewhere in the
  gauntlet that stabilises the system and ends the run. Quitting requires navigating
  to it under pressure, keeping immersion intact.
- **Natural off-ramps** — stabilisation zones between gauntlet sections where the
  player can choose to continue or stand down. No penalty, framed as a tactical
  decision rather than giving up.

Preferred direction: options 3 and 4 are most consistent with the design philosophy
that the barrier is commitment, and even the exit should require something from the
player rather than being a simple menu button.

---

## Enemy AI

### The State Machine
Every enemy is always in exactly one state at a time. The state machine decides
which state the enemy is in and what they do while in it. Each state is self
contained and predictable.

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

When the player enters either zone a signal fires and the enemy transitions states.
No manual distance checking required every frame.

### Line of Sight
Detection zones alone feel dumb — an enemy detecting you through a wall breaks
immersion. RayCast2D solves this by shooting an invisible line from the enemy
toward the player. If the ray hits a wall before reaching the player, the enemy
cannot see them and will not react. Combined with detection zones this produces
enemies that only chase you when they can actually see you.

### Navigation
Godot's built in NavigationAgent2D handles pathfinding automatically. Rather than
moving in a straight line and getting stuck on walls, enemies calculate a path
around obstacles. A NavigationRegion2D defined in each level tells Godot where
enemies are allowed to walk.

### Clone Enemies — A Special Case
Clone enemies do not use traditional state machine AI. They use a reactive system
that mirrors the player's own capabilities — dashing, parrying, reading inputs.
Their behaviour is driven by a frequency table that tracks how often the player
uses each move and weights defensive responses accordingly. A player who dashes
left repeatedly will face a clone that anticipates left dashes. Simple data,
eerily intelligent behaviour.

---

## Automated Testing via AI Routines

An AI routine that controls an enemy can equally control a simulated player. The
same state machine logic, navigation system, and decision making can be pointed
at the player character to create a bot that plays the game automatically.

### Use Cases

**Stress testing combat** — spawn a bot player and a large number of enemies and
let them run for an extended period. Crashes and errors surface without manual play.

**Balance testing** — run the bot through a level repeatedly and record statistics.
Average damage taken, dash uses per encounter, time to clear a room. Outliers
indicate balance problems.

**Regression testing** — after significant code changes, run the bot through
affected areas and compare statistics to previous runs. Unexpected spikes in
damage taken or failure rates may indicate something was accidentally broken.

**Pathfinding verification** — a bot attempting to navigate every area of the
level will quickly expose places where enemies or the player get stuck.

**Combat system verification** — automated testing can confirm that the combo loop
activates correctly, nano contagion spreads to the right targets, and i-frames
activate and deactivate at the correct moments.

### Key Advantage
No separate testing codebase is required. Enemy AI systems and test bots share the
same logic pointed in different directions. Systems built for gameplay double as
quality assurance tools.

---

## Promotional Idle Game — Future Project

A standalone free web game built from systems already developed for the main game.
Intended as a side project to return to when a break from main development is needed.

### Concept
Repackage the automated combat testing routines and wave system into an idle game
where players unlock upgrades by killing waves of enemies. Passively generates
upgrade currency while away, encouraging return visits.

### Why It Makes Sense
- No new systems required — wave combat, upgrade paths, and nano contagion already
  exist in the main game
- Automated testing bots already play the game — minimal additional work to make
  this presentable
- Free web games are shareable and discoverable in ways a Steam page is not
- Low friction engagement loop keeps the game in players' heads between sessions

### What It Includes
- Nano contagion system
- Upgrade paths
- Wave based combat
- Simplified inputs suitable for web and keyboard play

### What It Deliberately Excludes
- Gestural stick combat system
- Dash movement system
- Story and narrative
- These remain exclusive to the full game — the gap gives players a reason to buy

### Intent
Promotional tool that lets players experience the game's identity before purchasing.
Not a priority — return to this when a change of pace from main development is needed.

---

## Mood Board

### Color Direction
Rich dark base tones — deep blue, purple, and green suggesting a cold corporate
world. Bright striking accents — orange, pink, and yellow representing energy,
combat, and chaos cutting through the darkness.

The world is dark and controlled. The player is the bright disruptive element.

- Dark blues and purples — the world, the corporation, the architecture, the shadows
- Greens and teals — technology, nano effects, terminal screens, the chip interface
- Orange, pink, and yellow — combat energy, nano bursts, chaos in a cold environment

### Color Palette References
![Cyberpunk dark palette](images/moodboard/palette-01.jpg)
![Neon accent palette](images/moodboard/palette-02.jpg)
![Jewel tone palette](images/moodboard/palette-03.jpg)

### Tone References
![Tone reference 01](images/moodboard/tone-01.jpg)
![Tone reference 02](images/moodboard/tone-02.jpg)

### Character References
![Character reference 01](images/moodboard/character-01.jpg)
![Character reference 02](images/moodboard/character-02.jpg)

### Environment References
![Environment reference 01](images/moodboard/environment-01.jpg)
![Environment reference 02](images/moodboard/environment-02.jpg)

---

## Shaders

Shaders are small programs that run on the GPU and determine the final color of
every pixel on screen. They are how visual polish and effects are achieved without
affecting game logic.

### Two Types
**Vertex shaders** — run per vertex, control position and shape. Used for wobble,
wave, and distortion effects on geometry.

**Fragment shaders** — run per pixel, control color. Where most 2D game effects live.

### Shader Effects Planned for This Game

**Hit flash** — briefly replaces all sprite colors with a solid color on damage.
High game feel payoff for minimal code. Good first shader to write.

**Outline** — colored border around sprites. Used to highlight enemies, interactive
objects, or player states.

**Dissolve with glowing particles** — uses noise texture to disintegrate a sprite
pixel by pixel. As the sprite dissolves, glowing particles shoot off and fade out.
Planned for matter projection clone death animations. Particles are GPUParticles2D
emitted during the dissolve with neon palette colors, fading over their lifetime.

**Glow and bloom** — bright areas bleed light into surrounding pixels. Central to
the neon color palette and visual identity.

**Screen distortion** — warps screen pixels outward on impact. Planned for nano
burst detonation and major combat events.

**Scanlines** — subtle CRT overlay reinforcing the cyberpunk aesthetic.

**Color correction** — lookup table applied globally to unify the game's color
grading. Ensures the dark base tones and neon accents feel intentional and consistent.

### Overall Rendering Effects to Experiment With
Beyond individual sprite shaders, spend time experimenting with scene-wide
rendering effects including:

- Global bloom and glow intensity
- Color grading and lookup tables
- Scanline and screen texture overlays
- Screen space distortion
- Vignette and edge darkening
- Light and shadow interaction with the 2D lighting system
- Layering multiple post processing effects simultaneously

### Procedural Effects
Procedural effects are generated mathematically rather than drawn by hand:

- **Noise based effects** — Godot's built in FastNoiseLite generates organic patterns
  used for dissolve shaders, nano spread visuals, and terrain variation
- **Shader based procedural animation** — surfaces animated mathematically rather
  than frame by frame. Nano corruption spreading across an enemy, a matter projection
  flickering as it destabilises, electricity crackling along a surface — all generated
  in real time with no art assets required
- **Procedural particle behaviour** — noise functions drive particle movement for
  organic, unpredictable nano swarm effects that feel alive
- **Runtime texture generation** — textures generated in code using noise, useful
  for unique floor patterns in procedurally assembled endless mode rooms

Procedural visuals reinforce the narrative — nano is alive and organic, matter
projections are unstable and mathematical. Procedural effects communicate both
qualities better than hand animated sprites.

### In Godot
Shaders are attached to a ShaderMaterial which is assigned to a node. Godot has
a visual shader editor that builds effects by connecting nodes in a graph rather
than writing code directly — a good entry point before writing shader code by hand.

Shaders can be toggled on and off at runtime by swapping materials, toggling shader
parameters, or replacing shaders entirely while the game is running. A single
keyboard shortcut can toggle the nano visual layer during development for fast
before and after comparison.

### Notes
Shaders are not optional polish for this game — they are central to communicating
game events and defining visual identity. The nano contagion spread, matter
projection destabilisation, and chip interface effects all depend on shader work.

Visuals and mechanics should reinforce each other. The way nano spreads should
look like it is spreading. The way a matter projection destabilises should look
unstable and mathematical. Shader work is communicating systems to the player,
not decoration.

### Early Development Task — Visual Experimentation
Before committing to a final art style, spend dedicated time in Godot's visual
shader editor exploring layered visual effects. Goals:

- Get comfortable with the visual shader editor interface
- Experiment with glow, outline, and color correction effects
- Layer multiple shader effects to find combinations that define the game's unique look
- Experiment with overall rendering effects as a complete visual stack
- Establish the visual language for nano effects separately
- Define a color grading baseline that reflects the mood board direction
- Explore procedural effects for nano and matter projection visuals

Defining a strong visual identity early prevents costly rework later.

---

## Persistent Physical Particles

### Concept
Physical particles are RigidBody2D scenes spawned during combat rather than
purely visual GPU particles. They exist in the physics world — they collide,
tumble, stack, and can be pushed by the player. Neither the particles nor the
player can damage each other. They are purely physical atmosphere.

### Triggered by Combat
Particles are not just death effects — they are a byproduct of skilled play.
Different moves create different particles:
- Nano moves leave glowing organic debris that pulses softly
- Heavy knockback moves send larger chunks skittering across the floor
- Clone deaths scatter matter projection fragments that shimmer and fade slowly
- Each move has a visual signature that persists in the environment

### Visual Chaos as Skill Indicator
The better you play, the more spectacular the environment looks. A room
covered in glowing debris after a fight is a visual trophy. The room tells
the story of the fight without a score screen.

New particles colliding with existing ones sends them skittering. A room
mid-fight becomes increasingly chaotic as debris accumulates. At high levels
of play the environment becomes visually spectacular — rewarding mastery
with spectacle.

### Scene Structure
Each particle is its own lightweight RigidBody2D scene:

```
Particle.tscn
├── RigidBody2D (root)
├── Sprite2D (particle visual)
└── CollisionShape2D (physics shape)
```

No AI, no damage logic, no scripts beyond basic physics and a fade out timer.
Keeping the scene lightweight is critical for performance.

### Performance Management
- A cap on total active particles prevents accumulation from impacting performance
- When the cap is reached, the oldest particles begin fading out
- Each particle has a maximum lifetime after which it fades regardless of cap status
- Visual particles (GPUParticles2D) handle large burst effects
- Physical RigidBody2D particles are reserved for the meaningful persistent pieces

---

## Plugins and Third Party Libraries

### Where to Find Plugins
- **Godot Asset Library** — built directly into the editor (AssetLib tab). Browse,
  download, and install without leaving Godot.
- **GitHub** — many plugins live independently and are installed by dropping them
  into the project's `addons` folder.

Almost everything worth using is MIT licensed — readable, modifiable, and shippable
as your own version. This is the tweaking freedom needed for custom presets.

### Recommended Plugins for This Project

**Beehave** — open source behaviour tree plugin for enemy AI. More powerful and
flexible than a basic state machine for complex enemies like clones. MIT licensed.

**Phantom Camera** — smooth camera transitions and cinematic effects. Relevant for
the opening cutscene and combat camera work. Open source.

**Dialogic** — visual dialogue system for building conversations and cutscenes.
Relevant for story sequences. Highly customisable.

**GUT (Godot Unit Test)** — testing framework for writing automated tests in
GDScript. Pairs directly with the automated combat testing system.

**Aseprite Wizard** — imports Aseprite animation files directly into Godot with
all frames intact. Essentially mandatory for pixel art workflows.

**2D Destructible Objects** — divides sprites into blocks and makes them explode
physically. Adaptable for the persistent particle debris system.

**Gaea** — open source procedural generation addon using a visual graph system.
MIT licensed. Relevant for endless mode room assembly.

### Shader Resources
**godotshaders.com** — a community library of free open source shaders. Every
shader is readable and tweakable. A learning resource as much as a plugin library.
Bookmark immediately.

---

## Multi-Stage Bosses and Attack Points

### Concept
Large enemies and bosses have multiple attack points that activate in stages.
Example: vents open after an attack cycle to waste heat, and the player must
destroy each one to progress to the next phase.

### Scene Structure
A vent or attack point is its own scene file, instanced into the boss scene.
This follows the core Godot philosophy — build once, instance everywhere.

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

### Why Instance Vent as Its Own Scene
- Build the vent once and instance it as many times as needed
- Change the vent scene and every boss that uses it updates automatically
- The vent can be opened and edited in isolation without touching the boss
- Different bosses across the game share the same Vent.tscn
- The boss scene stays clean and readable

### Phase Progression via Signals
Each vent emits a signal when destroyed. The AttackCycleManager listens for all
of them and counts. When the count matches the required number, the phase advances.
Each vent does not know about the others — clean, modular, easy to extend.

### Phase Transitions
Each phase transition is a dramatic visual beat — the boss staggers, the screen
shakes, new components reveal themselves, music shifts. Shader work is central
here: color grading shifting to indicate a new dangerous state, vents glowing
with increasing intensity, screen distortion on transition.

### Scaling to Other Enemy Types
The same system scales down to elite enemies. Clone enemies could have specific
attack points — hit the legs to slow, hit the arms to prevent parrying. A system
designed for bosses works elegantly at smaller scale.

---
