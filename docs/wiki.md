# Cyberpunk Ninja — Project Wiki

> This document covers the Game Design Document, Godot reference notes, and project workflow. It is intended to live in your GitHub repository as a navigable reference. Use the table of contents to jump between sections.

-----

## Table of Contents

1. [Game Design Document](#game-design-document)
- [Story and Narrative](#story-and-narrative)
- [Core Mechanics](#core-mechanics)
- [Combat System](#combat-system)
- [Upgrade System](#upgrade-system)
- [Nano and Antimatter Systems](#nano-and-antimatter-systems)
- [Progression and Stages](#progression-and-stages)
- [Challenge Tiers and Hard Mode](#challenge-tiers-and-hard-mode)
- [Endless and Tower Mode](#endless-and-tower-mode)
- [Procedural Generation](#procedural-generation)
- [Design Philosophy](#design-philosophy)
1. [Godot Reference](#godot-reference)
- [Engine Overview](#engine-overview)
- [Node System](#node-system)
- [TileMap](#tilemap)
- [Input System](#input-system)
- [Visual Tools and Rendering](#visual-tools-and-rendering)
- [IDE and GitHub Workflow](#ide-and-github-workflow)
1. [Discussion Queue](#discussion-queue)
1. [Session Log](#session-log)

-----

# Game Design Document

-----

## Story and Narrative

### Setting

A cyberpunk world. You play as a ninja infiltrating a powerful corporation to recover a MacGuffin — the nature of which is to be defined. The corporation controls media, military, and scientific research. By the end of the game you will have saved the day and lost everything publicly, or proven yourself to the world — depending on how you play.

### Opening Sequence

**End of Stage 1 — The Sewers**
The mission goes wrong. The commander hovers over your fading body and says:

> *“Give this one to the egg heads. I bet they can have fun with this one.”*

Fade to black.

**Awakening — Stage 2 Opening**
You come to amidst fragmented flashbacks of training — serene, calm, distant. Slowly surgical commotion bleeds in. Doctors and soldiers shouting about a control chip not holding. Then silence.

You wake in an empty room. Unconscious bodies are scattered around you. You have no memory of how they got there. You try to stand. You collapse.

You are within range of the facility’s automated nano AI. It reads your chip input and stabilises you. This is how you survive. This is also how the game begins to open up — your physical proximity to nano computers gates what you can access, upgrade, and learn. The chip’s range does not expand. You must navigate the environment to reach new terminals.

### Narrative Threads

**The Chip**
The control chip implanted in your neck has more power than anyone anticipated — including you. The unconscious bodies on waking suggest the chip failure was violent. The player and the character share the same unanswered question: *did you do that? Are they dead?*

The chip raises a persistent thematic question about dependency and augmentation. The most capable version of the player — the one who completes the hardest challenge — never needed it at all.

**The Corporation**
The corporation you infiltrated in Stage 1 is the same one now holding you. The commander’s handoff wasn’t a rescue — you were passed along as an interesting specimen. You are not a prisoner of war. You are a research subject.

**The Scientists**
The scientists working on you become relevant later. The research conducted during your captivity leads to the creation of clone enemies — nano androids, matter projections of you, created from data gathered during your time on the table. You are fighting copies of yourself.

**The Lab Simulator**
The endless mode simulator isn’t something the corporation gave you access to. You are an escaped captive exploiting their own infrastructure against them. Every training session is an act of defiance.

**The Antimatter Question**
Antimatter is the most effective counter to clone enemies — it destabilises their matter projection matrix directly. But the clones are made from you. The player may need to confront what it means to annihilate copies of themselves. This thread is to be developed narratively.

**Defeated by a Little Pup**
To be developed.

### Endings

**Normal Ending**
You defeat the aging CEO and recover the MacGuffin. The media frames it as a ninja assassinating a helpless old man. You saved the day. Nobody knows. You are shamed and forced to live in exile.

A commentary on media, power, and narrative control — doing the right thing is not always recognised. Victory without vindication.

**Hard Mode Ending**
Completing the gauntlet challenge triggers the activation of a massive mech on top of a ruined building. Defeating it reveals you to the world as the true hero. The triumphant ending must be earned, not found.

**Tier 4 — Hidden Ending**
To be developed. Triggered by saving all collectibles AND forfeiting all upgrade points simultaneously. The game recognises total commitment. Something nobody will find by accident.

-----

## Core Mechanics

### The Dash

The dash is the player’s primary movement tool and the game’s central resource. In its base form the player has a single dash. Every use is a decision — spending it on a combat approach means not having it for environmental navigation a moment later.

The dash is shared between combat and traversal. This tension is intentional and is the defining constraint of the base game experience.

**Dash Refresh**
A successful attack opens a reward window during which the dash refreshes. Staying in the combat loop means staying mobile. Breaking the loop — missing an attack, taking a hit — costs you both safety and movement.

### Nano Computer Terminals

Your chip communicates with the facility’s nano AI infrastructure. Physical proximity to terminals gates story progression and upgrade access. The chip’s range does not expand — you navigate to the terminals, not the other way around. Exploration is mechanical progression, not just aesthetic.

### The Collectible Resource

A finite item found throughout the game. Spending it unlocks chip upgrades. Saving all of it instead unlocks a secret final boss. The player faces this choice from the moment the resource is introduced in Stage 2.

### Matter Defeated

A stat tracked separately from regular kills. Destroying a clone — a matter projection of yourself — is a categorically different act from defeating a human enemy. This stat may feed into mechanics and is narratively significant.

-----

## Combat System

### Overview

A dual stick combat system. The left stick controls movement. The right stick controls gestural attack inputs. The combat loop is: approach → strike → reward window → relaunch.

### The Combat Loop

**Phase 1 — Movement**
The player performs a right stick gesture, modified by shoulder buttons, to dash or jump toward a target. The approach direction and angle are tracked. This is the anticipation phase — commitment to a direction and an angle.

**Phase 2 — The Strike**
At arrival or during movement, the player inputs an attack. Attacks use Street Fighter style directional inputs — quarter circles, arcs, directional combinations — performed with the right stick. The gesture defines the attack.

**Phase 3 — The Reward Window**
A successful hit opens a brief window. Inside it: i-frames (temporary invulnerability), and a dash refresh. This enables combo chaining — relaunch the loop immediately. The window is the skill expression moment. Recognising and acting on it quickly sustains the chain.

**Breaking the Loop**
Missing an attack, mistiming the window, or taking a hit ends the chain and leaves the player exposed. The loop being both offensive and defensive means staying aggressive is also the safest strategy for skilled players.

### Gestural Input and Relative Direction

Move inputs are defined relative to the approach vector, not absolute controller directions. A move that is “down then forward” in the player’s local frame of reference is translated into absolute stick coordinates based on the direction of approach.

This means the same gesture always feels the same regardless of which direction the player came from. The move grammar is spatial and intuitive rather than memorised and absolute.

Approach angle may also modify or unlock specific move variants — a downward approach version and a horizontal approach version of the same input producing different outcomes.

### Shoulder Buttons

Used as modifiers and phase triggers. Specific roles to be developed. Options include distinguishing the anticipation and release phases, categorising gestures as movement or attack, or triggering special moves.

### The Parry

Triggered by a timed shoulder input. Deliberate and reactive — distinct from the gestural attack system. The parry:

- Blocks an incoming attack
- Applies nano directly to the attacker — the chip converts the impact into a nano injection
- If the attacker is already nano-loaded, triggers immediate detonation spreading to nearby enemies
- Builds the shared nano charge meter
- In hard mode specifically, acts as the skill-based defensive lifeline replacing upgrade-based offense

### Clone Combat

Clone enemies are matter projections of the player created from research conducted during captivity. They:

- Move like the player
- Parry like the player
- Are weighted toward countering the player’s most frequently used moves — the game tracks combat history and adjusts clone behaviour accordingly
- Require variation, misdirection, and timing — spamming any combo will be countered
- Interact differently with nano — partial immunity or unique reactions, to be developed
- Are vulnerable to antimatter — which destabilises their projection matrix directly

Fighting clones is a dance of movement and timing. A fundamentally different combat problem from fighting human enemies.

-----

## Upgrade System

### Overview

All upgrades are delivered via the chip implant using the finite collectible resource. The player can eventually unlock everything and become fully powered. Early choices are meaningful and identity-defining but never permanent — refund stations allow free respeccing at any time.

Upgrades should change behaviour and mindset, not just numbers. Small but meaningful choices, not minor percentage increases.

### Refund Stations

Located at designated points in the environment. Free to use. Exist so players never feel locked into choices, never feel locked out of the hard mode challenge, and always feel free to experiment.

### Upgrade Paths

**Movement and Dodge**

- Base: single dash
- First upgrade: cooldown reset and multiple dashes — changes the player’s relationship with the entire game
- Further upgrades to be developed
- Completing the game with a single dash is an intended challenge

**Damage and Knockback**

- Upgrades for juggling and armor breaking
- Knockback as a combat tool for repositioning enemies and extending combos
- Further upgrades to be developed

**Nano Effects**

- See [Nano and Antimatter Systems](#nano-and-antimatter-systems)

**Antimatter**

- See [Nano and Antimatter Systems](#nano-and-antimatter-systems)

-----

## Nano and Antimatter Systems

> **Repository reference:** [`/scripts/nano/`](../tree/main/scripts/nano) | [`/scripts/antimatter/`](../tree/main/scripts/antimatter)

### The Conceptual Split

Two distinct combat philosophies built into the same system.

**Nano** is biological and systemic. It spreads, corrupts, and builds over time. It works with and through living and electronic systems. Patient, cascading, networked. The hacker’s toolkit.

**Antimatter** is physics-based and absolute. It annihilates on contact. No buildup, no spreading, immediate and terminal. The weapon you’re not supposed to have.

In a room full of enemies nano turns the battlefield into a managed cascade. Antimatter turns a single target into nothing. Different tools for different problems — and different philosophies about what kind of fighter you are.

### Nano Effects

**Nano Corrosion**
Eats through armor over time. Synergises with the knockback and armor break upgrade path. Particularly effective as a setup tool before a heavy knockback combo.

**Nano Swarm**
A damage over time cloud released on hit or deployed as a standalone ability. Spreads to nearby enemies on kill. Good for clustered groups.

**Nano Trace**
Marks an enemy. Enhances subsequent attacks against marked targets. Network effects: two marked enemies near each other amplify damage between them. Three or more creates a feedback loop. Rewards thinking about the whole room rather than one target.

**Nano Overload**
A charged effect that detonates after a threshold of nano buildup. Triggers smaller explosions on nearby enemies. Chain detonations cascade through nano-loaded groups. A patient player sets up the chain before triggering it.

**Nano Heal**
Passive regeneration or burst heal tied to combat performance. Rewards sustained engagement.

### Nano Interactions

Different nano types interact with each other — corrosion plus swarm produces compound effects neither achieves alone. Stacking multiple types and hitting thresholds triggers automatic emergent effects. The system rewards experimentation and knowledge of the interaction table.

### The Contagion System

Inspired by Cyberpunk 2077’s quickhacking contagion. Effects spread from killed or critically hit enemies to nearby enemies. Special moves can create building and spreading effects. The goal is for skilled players to feel like a force multiplier — one well-placed action cascades through a group.

### Parry and Nano

A successful parry applies nano directly to the attacker. If the attacker is already nano-loaded, the parry triggers immediate detonation spreading to nearby enemies.

The full contagion chain: **parry → apply nano → contagion spreads → meter fills → nano burst detonates everything simultaneously.**

### The Nano Charge Meter

Built by successful parries. When full, triggers a nano burst — a room-wide pulse that applies the current active nano type to every enemy present simultaneously. In a room full of enemies this is the power fantasy moment. The meter rewards defensive skill with explosive offensive payoff.

### Antimatter

- Natural counter to matter projection clone enemies — destabilises their construction directly
- Feeds a separate charge mechanic potentially tied to the Matter Defeated stat
- Immediate and unambiguous — no setup, no spreading, just annihilation
- Narratively weighted: the clones are made from you. Antimatter destroys copies of yourself.

### Nano in Hard Mode

Without upgrades nano builds slower and the burst is less explosive. But the parry still feeds the meter. Hard mode nano is a slow burn — carefully cultivated rather than splashed around. The hard mode player has a different, more deliberate relationship with the nano system.

### Visual and Audio Design Notes

- Each nano type needs a distinct visual language — battlefield state must be readable at a glance
- Nano spread and detonation chains need satisfying, distinct audio design
- Nano interaction with boss enemies to be developed — partial immunity, different thresholds, unique reactions

-----

## Progression and Stages

### Stage 1 — The Sewers

Teaches basic combat, the core movement loop, and the dash as a resource. No upgrades. The player learns the game in its most constrained form. Ends with capture.

### Stage 2 — The Surgical Lab

The player awakens with the chip implanted. The stage teaches each upgrade path by giving the player the first node of each before the stage ends — double dash, knockback, and nano respectively. The collectible resource is introduced here. The player immediately faces the choice of spending or saving.

Navigation to nano computer terminals gates further story and upgrade access. The environment is a mechanical obstacle as well as an aesthetic one.

### Later Stages

To be developed.

-----

## Challenge Tiers and Hard Mode

### The Four Tiers

**Tier 1 — Normal Run**
Spend your upgrades. Enjoy the power fantasy. See the bittersweet exile ending. The intended experience for most players.

**Tier 2 — Secret Boss Run**
Hoard all collectibles. Spend nothing. Face the final boss underpowered but not stripped bare. Tests patience and resource discipline over the entire game. Unlocks the secret final boss.

**Tier 3 — Gauntlet Run**
Voluntarily forfeit all upgrade points. Single dash. No upgrades. The game locks into gauntlet state — irreversible for that run. Tests pure mechanical mastery. Unlocks the mech boss and the true hero ending.

The parry is the hard mode lifeline. Skill-based defense replaces upgrade-based offense. The nano system still functions, building slowly through successful parries. The challenge is meaningful because the cost is real.

**Tier 4 — The Hidden Layer**
Save every collectible AND forfeit all upgrades simultaneously. The game recognises total commitment. Unlocks something nobody will find by accident. To be developed.

The barrier to entry for all challenge tiers is commitment and courage, not hidden knowledge or grinding. Everyone can attempt them. Few will finish.

### Hard Mode Design Notes

- The single dash constraint matters most in the spaces between combat — navigation, positioning, choosing when to engage
- A skilled player who stays in the combat loop effectively never runs out of dash because they keep refreshing it on successful hits
- The parry gives a skill-based defensive option that doesn’t cost the dash — hard mode is active and skillful, not just cautious rationing
- The nano burst from parry chains gives the hard mode player occasional moments of genuine power — cultivated and earned

-----

## Endless and Tower Mode

### Framing

In-universe: a combat simulator in the lab. The player is not a guest — they are an escaped captive exploiting their captors’ own infrastructure. Every session is an act of defiance.

### Modes

**Stage Select**
Player chooses which environment or enemy composition to run. Curated options with distinct challenges.

**Random Mode**
Procedurally selected stages and enemy combinations. Maximum replayability.

**Endless Mode**
The full power fantasy destination. A fully upgraded player can wreck rooms indefinitely as a reward for mastery. This is where the upgrade system pays off completely.

**Tower Mode**
Structured escalating challenge for players who want meaningful progression within the mode rather than pure endless play.

### Procedural Modifier System

Each run in endless or tower mode draws a random set of modifiers that change the rules. Examples:

- No parry available
- Nano effects spread twice as fast
- Antimatter only
- Clones only
- Double dash from the start
- Nano meter starts full
- Matter Defeated multiplier active

Modifiers are simple to implement but dramatically change how each run feels. They create variety without requiring new content and give experienced players a constantly shifting challenge.

-----

## Procedural Generation

### Design Principle

Procedural generation is a tool, not a goal. Hand-crafted story, procedural replayability. Know which serves which purpose.

### Where Procedural Generation Is Used

- **Endless and tower mode** — hand-crafted components assembled procedurally. Designed pieces, dynamic arrangement. Feels designed rather than random.
- **Enemy group composition** — encounter budgets define room difficulty, specific enemies selected from a pool. Fresh on replays without disrupting designed experience.
- **Nano combinations in endless mode** — each run seeds different active nano types or starting upgrade nodes. Forces adaptation.
- **Clone behaviour** — weighted toward countering the player’s most used moves. Tracks combat history and adjusts dynamically.
- **Procedural modifiers** — random run conditions in endless and tower mode.

### Where Procedural Generation Is Not Used

- **Main story stages** — entirely hand-crafted. Narrative pacing and environmental storytelling require authorial control.
- **Boss fights** — authored experiences with specific rhythms and meanings. Never randomised.

-----

## Design Philosophy

- The dash is a resource shared between combat and navigation — every use is a decision
- Combat skill is rewarded with navigation currency — successful hits refresh the dash
- The single dash constraint matters most between combats, not during them
- The first upgrade doesn’t just increase power — it changes the player’s relationship with the game’s core mechanic
- Upgrades should change behaviour and mindset, not just numbers
- Small but meaningful choices — not minor percentage increases
- Allow players to grow their own way — personal identity through upgrade path
- Player can eventually unlock everything and become ultra powered, but early choices shape the journey
- Refund freedom ensures players explore freely rather than playing cautiously
- Hard mode barrier is commitment not gatekeeping — everyone can try, few will finish
- The most powerful version of the character never needed the chip — narrative and mechanical design aligned
- The normal ending is a commentary on media, power, and narrative control
- The triumphant ending must be earned, not found
- Games are a power fantasy — if the player puts in the work they should be able to absolutely wreck rooms
- Earned power is more satisfying than given power — the system rewards mastery with spectacle
- Hand-crafted story, procedural replayability — know which tool serves which goal

-----

# Godot Reference

-----

## Engine Overview

Godot is a free, open-source game engine owned by a nonprofit foundation. No licensing fees or royalties regardless of revenue. The source code is publicly available.

**Renderers**
Godot 4 offers three rendering backends:

- **Compatibility** — lightweight, wide hardware support, ideal for 2D projects
- **Forward+** — high-end 3D rendering
- **Mobile** — middle ground

For a 2D top-down game, Compatibility is the right choice.

**GDScript**
Godot’s built-in scripting language. Python-like syntax, deeply integrated with the engine, excellent for 2D development. The right choice for this project. C# is also supported for developers coming from Unity.

**Open Source Advantage**
No risk of pricing changes like Unity’s 2023 controversy. Community governed. The full engine source is available to read if you need to understand how something works under the hood.

-----

## Node System

### Core Concept

Everything in Godot is built from nodes. A node is a single building block with a specific job. Nodes are combined into scenes. Scenes can contain other scenes. This is called **composition**.

### The Scene Tree

Nodes are arranged in a hierarchy. Every scene has one root node. Children inherit position, visibility, and other properties from their parents. Moving the root moves all children automatically.

### Scenes and Instancing

A scene is a reusable collection of nodes saved as a file. Drop a scene into another scene and you create an **instance**. Change the original scene and all instances update. Player, enemies, bullets, UI elements — each gets its own scene, instanced wherever needed.

### Key Node Types for This Project

|Node |Purpose |
|---------------------|--------------------------------------------------------------------------|
|`CharacterBody2D` |Physics body for player and enemies — handles movement and collision |
|`Area2D` |Detects overlap without physical collision — hitboxes, hurtboxes, triggers|
|`CollisionShape2D` |Defines the actual collision shape — always paired with physics bodies |
|`Sprite2D` |Draws an image — separate from physics |
|`AnimationPlayer` |Manages animations via keyframe timeline |
|`AnimationTree` |State machine for smooth animation transitions |
|`Camera2D` |Follows the player, supports smoothing and screen shake |
|`AudioStreamPlayer2D`|Positional audio — fades with distance |
|`TileMap` |Paints game world from tile grid |
|`GPUParticles2D` |Particle effects — explosions, sparks, nano visuals |
|`RayCast2D` |Line of sight, ground detection |

### Scripts and Nodes

Every node type is a class. Attaching a GDScript to a node extends that class. A script on `CharacterBody2D` inherits all its movement and collision methods automatically. The node type you choose shapes what your script is capable of.

### Signals

Godot’s system for nodes to communicate without direct dependency. A node broadcasts a signal (“my health changed”) and other nodes listen and respond. The broadcaster doesn’t need to know listeners exist.

Essential for keeping code clean as the project grows. The player script doesn’t reach out to the health bar — it emits a signal and the health bar responds.

### Player Scene Example

```
Player (CharacterBody2D) ← script attached here
├── Sprite (Sprite2D)
├── CollisionShape (CollisionShape2D)
├── AnimationPlayer (AnimationPlayer)
├── AnimationTree (AnimationTree)
├── Camera (Camera2D)
├── Hurtbox (Area2D)
│ └── CollisionShape (CollisionShape2D)
├── WeaponPivot (Node2D) ← rotates to aim
│ ├── WeaponSprite (Sprite2D)
│ └── Hitbox (Area2D)
│ └── CollisionShape (CollisionShape2D)
├── FootstepAudio (AudioStreamPlayer2D)
├── SFXPlayer (AudioStreamPlayer2D)
└── InteractionDetector (Area2D)
└── CollisionShape (CollisionShape2D)
```

-----

## TileMap

### Overview

TileMap paints the game world using a grid of tiles from a spritesheet. Efficient for both performance and level design workflow.

### TileSet

Defines the collection of available tiles. Godot slices a spritesheet into tiles based on the size you specify (e.g. 16x16 or 32x32 pixels). Organisation of the spritesheet matters — related tiles grouped together make palette navigation easier.

### Terrain System (Autotiling)

Define terrain sets that describe how tiles connect to neighbours. Paint with a terrain brush and Godot automatically selects the correct variant — corners, edges, and interior pieces — based on surrounding tiles. Saves significant manual work and produces cleaner results.

### Layers

Multiple layers within a single TileMap node. Typical setup for a top-down game: ground layer, detail layer, wall layer, roof layer. Each layer has independent z-ordering.

### Collision Per Tile

Collision shapes defined directly on tiles in the TileSet. Wall tiles have solid collision, floor tiles don’t — without placing separate collision nodes for every wall. Diagonal tiles can have diagonal collision shapes.

### Custom Data

Attach arbitrary data to tile types — slow terrain, hazard tiles, footstep sound category. Game code reads tile data at runtime and responds. Level design information lives in the TileMap itself.

### Animated Tiles

Individual tiles can cycle through frames automatically — water, lava, torches, grass. Defined in the TileSet, handled automatically by the TileMap.

-----

## Input System

### Input Map

Rather than checking for specific keys, define named **actions** in Project Settings → Input Map. Check actions in code instead of physical inputs. A keyboard key and a controller button can both trigger the same action. Code never needs to know which physical input fired.

### Dual Stick Input

**Left stick — movement:**

```gdscript
var move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
```

**Right stick — aim/gesture:**

```gdscript
var aim_direction = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
```

`get_vector` returns a normalised Vector2 with deadzone handling built in.

### Deadzone

Physical sticks drift slightly when released. The deadzone ignores small central inputs to prevent unintended movement. Configured per action in the Input Map. Essential for good controller feel.

### Detecting Input Device

```gdscript
func _input(event):
if event is InputEventJoypadMotion or event is InputEventJoypadButton:
# controller active — show controller prompts
elif event is InputEventKey or event is InputEventMouseButton:
# keyboard active — show keyboard prompts
```

Track most recently used device to update UI prompts dynamically.

### Relative Gesture Input

For this project, right stick gestures are translated relative to the approach vector rather than absolute controller directions. Technically: rotate raw stick input by the inverse of the approach angle before pattern matching. `Vector2` has built-in rotation methods in Godot.

-----

## Visual Tools and Rendering

### The Viewport

Interactive visual representation of the current scene. Click and drag nodes to position, rotate, and scale them directly.

### The Inspector

Shows every property of the selected node — position, scale, color, physics properties. Edit directly without code. Most game tuning happens here first.

### AnimationPlayer Editor

Visual keyframe timeline. Keyframe any property of any node — position, rotation, sprite frame, visibility, custom variables. Trigger events at specific frames via signals (e.g. enable hitbox at frame 4 of attack animation).

### AnimationTree

Visual state machine graph for managing complex animation logic. Smooth transitions between animations based on conditions. Essential for a polished action game with many animation states.

### 2D Lighting

- `PointLight2D` — radiates from a point, like a torch
- `DirectionalLight2D` — distant light like sunlight
- **Normal maps** — give lighting system surface direction information, simulating depth on flat sprites
- `CanvasModulate` — tints the entire scene, used for darkness with lights punching through

### Post Processing (WorldEnvironment)

- **Glow** — bloom on bright areas, adds atmosphere
- **Tonemapping** — controls how light range maps to screen, affects overall visual feel
- **Color Correction** — applies a color grade lookup table to the entire scene, establishes visual identity

### Shaders

Programs running on the GPU controlling exactly how pixels are drawn. Written in Godot’s shading language (similar to GLSL). Common uses for this project:

- Outline shader for enemy highlighting
- Hit flash (briefly turns character white on damage)
- Dissolve effect on clone destruction
- Nano visual effects — spreading corruption, glowing traces
- Antimatter annihilation visual

Visual Shader Editor available for node-based shader creation without writing code directly.

### Particles

- `GPUParticles2D` — runs on GPU, handles large numbers efficiently — explosions, nano clouds, antimatter bursts
- `CPUParticles2D` — runs on processor, broader hardware compatibility

### Canvas Layers

`CanvasLayer` assigns nodes to rendering layers with independent camera transforms. Game world on one layer, HUD on another. Health bars don’t scroll off screen when the camera moves.

-----

## IDE and GitHub Workflow

### The Three Tools

- **Godot** — your workshop. Build scenes, run the game, manage assets.
- **IDE (Google Antigravity)** — your workbench. Write and edit GDScript files.
- **GitHub** — your filing cabinet. Every version of every file, forever.

All three tools work on the same folder of files on your computer.

### Godot and IDE Together

Godot has a basic code editor built in but a dedicated IDE is a better writing environment. Configure Godot to open scripts in your external IDE automatically: **Editor Settings → Text Editor → External**.

Both tools watch the same files. Save in the IDE, click play in Godot — changes are already there. Always save before testing.

### Git Workflow

**Commit often.** Small commits with meaningful messages. “fixed player sliding on walls” not “fixed stuff.”

**Branches.** Create a branch to try something risky. Merge it back if it works. Delete it if it doesn’t. Main project stays safe.

**Typical session:**

1. Open project in Godot and IDE
1. Write code in IDE, save
1. Test in Godot
1. Repeat
1. At a good stopping point — commit with a descriptive message, push to GitHub

### Linking Wiki to Project Files

In-folder `README.md` files render automatically when browsing GitHub. Add a README to each scripts folder explaining what the scripts do and linking back to relevant wiki sections.

**Example structure:**

```
/scripts
/nano ← README.md explains nano system, links to Nano wiki section
/antimatter ← README.md explains antimatter, links to Antimatter wiki section
/combat ← README.md explains combat loop, links to Combat wiki section
/player ← README.md explains player scene structure
/enemies ← README.md explains enemy types including clones
```

-----

# Discussion Queue

Topics to cover in future sessions, in rough priority order:

1. How enemy AI works in Godot
1. Working with a game controller during development
1. Sprite creation and art tools
1. Shaders
1. Normal maps
1. Plugins and effects libraries
1. Combos and moves
1. Signals in depth
1. Resources
1. Autoloads / Singletons
1. Scene switching and level loading
1. Saving and loading game data
1. Physics layers and masks in depth
1. RayCast2D
1. Physics body types
1. Audio bus system
1. Control node family in depth
1. Building menus, HUDs, and dialogue systems
1. Screenshake, hitpause, and game feel techniques
1. Procedural generation basics in Godot
1. Optimization and performance

-----

# Session Log

### Session 1 — February 22 2026

**Topics covered:**

- What an IDE is and how to use one — layout, workflow, tips
- How Godot, an IDE, and GitHub work together
- Godot overview — history, industry position, open source model
- Node system in depth — composition, scene tree, instancing, signals, key node types
- Visual development tools — viewport, inspector, AnimationPlayer, AnimationTree, shader editor, particles, canvas layers
- Rendering and post processing — renderers, 2D lighting, normal maps, WorldEnvironment effects, shaders
- TileMap in depth — TileSet, terrain autotiling, layers, collision per tile, custom data, animated tiles
- Player character node tree — interactive diagram created
- Input system — Input Map, dual stick input, deadzone, device detection, relative gesture input
- Building 2D action games — game feel, player movement, combat systems, projectiles, level design, UI
- Procedural generation — where it fits and where it doesn’t for this project

**Game design developed:**

- Full game concept established — cyberpunk ninja, corporate infiltration, chip implant upgrades
- Complete opening sequence and narrative threads
- Dual stick gestural combat system with relative input space
- Combat loop — approach, strike, reward window, relaunch
- Parry system with nano interaction
- Nano system — five effect types, contagion, charge meter, nano burst
- Antimatter system — conceptual split with nano, clone counter
- Four challenge tiers including hidden layer
- Endless and tower mode with procedural modifier system
- Full design philosophy documented

-----

*Last updated: Session 1 — February 22 2026*
*Next session: Continue discussion queue from item 1*
