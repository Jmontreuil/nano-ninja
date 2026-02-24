# Godot Technical Reference

---

## Engine Overview

Godot is a free, open-source game engine owned by a nonprofit foundation. No licensing fees
or royalties regardless of revenue. The source code is publicly available.

### Renderers
Godot 4 offers three rendering backends:
- **Compatibility** — lightweight, wide hardware support, ideal for 2D projects
- **Forward+** — high-end 3D rendering
- **Mobile** — middle ground

For a 2D top-down game, Compatibility is the right choice.

### GDScript
Godot's built-in scripting language. Python-like syntax, deeply integrated with the engine,
excellent for 2D development. The right choice for this project. C# is also supported for
developers coming from Unity.

### Open Source Advantage
No risk of pricing changes like Unity's 2023 controversy. Community governed. The full engine
source is available to read if you need to understand how something works under the hood.

---

## Node System

### Core Concept
Everything in Godot is built from nodes. A node is a single building block with a specific
job. Nodes are combined into scenes. Scenes can contain other scenes. This is **composition**.

### The Scene Tree
Nodes are arranged in a hierarchy. Every scene has one root node. Children inherit position,
visibility, and other properties from their parents. Moving the root moves all children automatically.

### Scenes and Instancing
A scene is a reusable collection of nodes saved as a file. Drop a scene into another scene
and you create an **instance**. Change the original scene and all instances update. Player,
enemies, bullets, UI elements — each gets its own scene, instanced wherever needed.

### Key Node Types for This Project

| Node | Purpose |
|------|---------|
| `CharacterBody2D` | Physics body for player and enemies — handles movement and collision |
| `Area2D` | Detects overlap without physical collision — hitboxes, hurtboxes, triggers |
| `CollisionShape2D` | Defines the actual collision shape — always paired with physics bodies |
| `Sprite2D` | Draws an image — separate from physics |
| `AnimationPlayer` | Manages animations via keyframe timeline |
| `AnimationTree` | State machine for smooth animation transitions |
| `Camera2D` | Follows the player, supports smoothing and screen shake |
| `AudioStreamPlayer2D` | Positional audio — fades with distance |
| `TileMap` | Paints game world from tile grid |
| `GPUParticles2D` | Particle effects — explosions, sparks, nano visuals |
| `RayCast2D` | Line of sight, ground detection |

### Scripts and Nodes
Every node type is a class. Attaching a GDScript to a node extends that class. A script on
`CharacterBody2D` inherits all its movement and collision methods automatically.

### Signals
Godot's system for nodes to communicate without direct dependency. A node broadcasts a
signal ("my health changed") and other nodes listen and respond. The broadcaster doesn't
need to know listeners exist.

Essential for keeping code clean as the project grows. The player script doesn't reach out
to the health bar — it emits a signal and the health bar responds.

### Player Scene Example

```
Player (CharacterBody2D) ← script attached here
├── Sprite (Sprite2D)
├── CollisionShape (CollisionShape2D)
├── AnimationPlayer (AnimationPlayer)
├── AnimationTree (AnimationTree)
├── Camera (Camera2D)
├── Hurtbox (Area2D)
│   └── CollisionShape (CollisionShape2D)
├── WeaponPivot (Node2D)
│   ├── WeaponSprite (Sprite2D)
│   └── Hitbox (Area2D)
│       └── CollisionShape (CollisionShape2D)
├── FootstepAudio (AudioStreamPlayer2D)
├── SFXPlayer (AudioStreamPlayer2D)
└── InteractionDetector (Area2D)
    └── CollisionShape (CollisionShape2D)
```

---

## TileMap

### Overview
TileMap paints the game world using a grid of tiles from a spritesheet. Efficient for both
performance and level design workflow.

### TileSet
Defines the collection of available tiles. Godot slices a spritesheet into tiles based on
the size you specify (e.g. 16x16 or 32x32 pixels). Organisation of the spritesheet matters —
related tiles grouped together make palette navigation easier.

### Terrain System (Autotiling)
Define terrain sets that describe how tiles connect to neighbours. Paint with a terrain brush
and Godot automatically selects the correct variant — corners, edges, and interior pieces —
based on surrounding tiles. Saves significant manual work.

### Layers
Multiple layers within a single TileMap node. Typical setup for a top-down game: ground
layer, detail layer, wall layer, roof layer. Each layer has independent z-ordering.

### Collision Per Tile
Collision shapes defined directly on tiles in the TileSet. Wall tiles have solid collision,
floor tiles don't — without placing separate collision nodes for every wall.

### Custom Data
Attach arbitrary data to tile types — slow terrain, hazard tiles, footstep sound category.
Game code reads tile data at runtime and responds.

### Animated Tiles
Individual tiles can cycle through frames automatically — water, lava, torches, grass.
Defined in the TileSet, handled automatically by the TileMap.

---

## Input System

### Input Map
Rather than checking for specific keys, define named **actions** in Project Settings →
Input Map. Check actions in code instead of physical inputs. A keyboard key and a controller
button can both trigger the same action.

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
Physical sticks drift slightly when released. The deadzone ignores small central inputs to
prevent unintended movement. Configured per action in the Input Map.

### Detecting Input Device
```gdscript
func _input(event):
    if event is InputEventJoypadMotion or event is InputEventJoypadButton:
        pass  # controller active — show controller prompts
    elif event is InputEventKey or event is InputEventMouseButton:
        pass  # keyboard active — show keyboard prompts
```

Track most recently used device to update UI prompts dynamically.

### Relative Gesture Input
Right stick gestures are translated relative to the approach vector rather than absolute
controller directions. Rotate raw stick input by the inverse of the approach angle before
pattern matching. `Vector2` has built-in rotation methods in Godot.

---

## Visual Tools and Rendering

### The Viewport
Interactive visual representation of the current scene. Click and drag nodes to position,
rotate, and scale them directly.

### The Inspector
Shows every property of the selected node — position, scale, color, physics properties.
Edit directly without code. Most game tuning happens here first.

### AnimationPlayer Editor
Visual keyframe timeline. Keyframe any property of any node — position, rotation, sprite
frame, visibility, custom variables. Trigger events at specific frames via signals.

### AnimationTree
Visual state machine graph for managing complex animation logic. Smooth transitions between
animations based on conditions. Essential for a polished action game with many animation states.

### 2D Lighting
- `PointLight2D` — radiates from a point, like a torch
- `DirectionalLight2D` — distant light like sunlight
- **Normal maps** — give lighting system surface direction information, simulating depth on
  flat sprites
- `CanvasModulate` — tints the entire scene, used for darkness with lights punching through

### Post Processing (WorldEnvironment)
- **Glow** — bloom on bright areas, adds atmosphere
- **Tonemapping** — controls how light range maps to screen
- **Color Correction** — applies a color grade lookup table to the entire scene

### Canvas Layers
`CanvasLayer` assigns nodes to rendering layers with independent camera transforms. Game
world on one layer, HUD on another. Health bars don't scroll off screen when the camera moves.

See [visual-systems.md](../visual/visual-systems.md) for the full canvas layer reference.

---

## IDE and GitHub Workflow

### The Three Tools
- **Godot** — your workshop. Build scenes, run the game, manage assets.
- **IDE (Google Antigravity)** — your workbench. Write and edit GDScript files.
- **GitHub** — your filing cabinet. Every version of every file, forever.

All three tools work on the same folder of files on your computer.

### Godot and IDE Together
Configure Godot to open scripts in your external IDE automatically:
**Editor Settings → Text Editor → External**

Both tools watch the same files. Save in the IDE, click play in Godot — changes are already
there. Always save before testing.

### Git Workflow
Commit often. Small commits with meaningful messages. "fixed player sliding on walls" not
"fixed stuff."

**Typical session:**
1. Open project in Godot and IDE
2. Write code in IDE, save
3. Test in Godot
4. Repeat
5. At a good stopping point — commit with a descriptive message, push to GitHub

See [development-workflow.md](development-workflow.md) for the full git branching reference.

### Linking Wiki to Project Files
In-folder `README.md` files render automatically on GitHub. Add a README to each scripts
folder explaining what the scripts do and linking back to relevant wiki sections.
