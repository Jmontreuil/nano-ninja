# Visual Systems

---

## Canvas Layers

### Overview
Godot supports up to 128 CanvasLayers, numbered -128 to 127. Lower numbers render behind
higher numbers.

```
-128 to -1    →    background layers
0             →    default world layer
1 to 127      →    foreground and UI layers
```

### Key Properties

**`layer`** — Z order of the canvas layer, -128 to 127.

**`motion_scale`** — Vector2 controlling parallax speed relative to the camera. The core
parallax tool:
- `Vector2(0, 0)` — fixed to screen, does not move
- `Vector2(0.5, 0.5)` — moves at half camera speed, background parallax
- `Vector2(1, 1)` — moves exactly with camera, normal world objects
- `Vector2(1.5, 1.5)` — moves faster than camera, foreground parallax

**`motion_offset`** — Vector2 adding a fixed pixel offset independent of camera movement.
Useful for slow atmospheric drift effects. Animatable for additional camera drama.

**`follow_viewport_enabled`** — boolean controlling whether the layer follows the camera
(world elements) or stays fixed to the screen (UI). Set deliberately on every layer.

**`follow_viewport_scale`** — scales the layer relative to the viewport when
follow_viewport_enabled is true. Creates depth through scale difference.

**`transform`** — full Transform2D giving direct control over the layer's position, rotation,
and scale. Animatable via AnimationPlayer or Tween. Enables rotating or scaling entire layers
during special moves or dramatic moments.

**`custom_viewport`** — assigns a specific Viewport to the layer. Enables picture in picture
effects. Candidate for nano computer terminal interface display.

**`visible`** — hides everything on the layer simultaneously. The VisualEffectsManager
autoload can toggle entire visual layers with one line of code.

### Capabilities

**Animating layer properties** — any CanvasLayer property can be keyframed in AnimationPlayer
or driven by Tween. Camera punch-in during combat threshold simultaneously adjusts foreground
motion_scale and background motion_offset for unified dramatic effect.

**Shaders per layer** — a shader applied to a CanvasGroup node on a layer affects everything
on that layer simultaneously. Full screen nano surge desaturation effect lives on its own
layer, toggled independently.

**Independent coordinate spaces** — each layer has its own coordinate system. UI on fixed
layers is positioned relative to screen. World elements on following layers are positioned
in world space.

### Limitations

**No blending modes between layers** — Multiply, Screen, and other blend modes are not
available as layer properties. Blending effects between layers require shader work.

**No per layer lighting** — Godot's 2D lighting affects the entire world regardless of layer.
Independent lighting per layer requires shader intervention.

**CanvasGroup performance** — applying shaders to entire layers requires Godot to render that
layer to a separate texture first. Monitor how many full layer shaders run simultaneously.

### Recommended Layer Stack for This Game

```
CanvasLayer -10   motion_scale 0.2    →    distant city skyline background
CanvasLayer -5    motion_scale 0.5    →    mid background atmosphere
CanvasLayer -1    motion_scale 0.8    →    near background wall details
CanvasLayer 0     motion_scale 1.0    →    game world — floor, player, enemies
CanvasLayer 1     motion_scale 1.2    →    mid foreground details
CanvasLayer 2     motion_scale 1.5    →    close foreground pipes and rafters
CanvasLayer 3     motion_scale 1.0    →    atmospheric particles and effects
CanvasLayer 5                         →    full screen shader effects
CanvasLayer 10    fixed to screen     →    HUD and UI
CanvasLayer 11    fixed to screen     →    pause menu
CanvasLayer 12    fixed to screen     →    screen transitions and fades
```

Gaps between numbers are intentional — room to insert new layers later without renumbering.

---

## Foreground Graphics and Z Index

### Z Index
Z index is a property every Node2D has. Higher Z index renders in front of lower Z index.

- Floor tiles: Z index -1
- Player: Z index 0
- Foreground pipes and rafters: Z index 1

Multiple objects can share the same Z index — Godot resolves draw order among same-Z objects
by their position in the scene tree. Nodes lower in the tree draw in front of nodes higher up.

### Examining Z Index in Godot
- **Inspector** — shows Z index value of any selected node, editable directly
- **Remote Scene Tree** — pause the running game and inspect every live node's current Z index

### YSort
A property enabled on a Node2D that automatically sorts its children by their Y position
on screen. Objects lower on screen render in front of objects higher on screen. Essential
for top down games — a character walking behind a crate automatically renders behind it.
Eliminates manual Z index management for world objects.

### Foreground Alpha Fade
When the player moves under a foreground element, an Area2D detects the overlap and fades
the element's alpha so the player remains visible beneath it. The foreground object still
renders in front — it becomes partially transparent to keep the player readable. Triggered
by signal.

---

## Normal Maps and Advanced Lighting

### Normal Maps in 2D
Normal maps are textures that encode surface direction per pixel, allowing Godot's 2D
lighting system to calculate physically accurate light interaction with flat sprites.

Applied via CanvasTexture in Godot 4, which bundles diffuse texture and normal map together
as a single material on a Sprite2D. Every sprite intended to interact with dynamic lighting
should have a corresponding normal map.

Normal maps must be created externally. Recommended tools:
- **Laigter** — free open source dedicated 2D normal map generator
- **SpriteIlluminator** — dedicated 2D normal map generator
- **Sprite DLight** — feed in a sprite, generates normal map from shape
- Photoshop and Krita can generate normal maps from height maps via plugins

### Channel Packing
Multiple maps can be stored in channels of one image file — for example, normal map data in
RGB and an emission mask in the alpha channel. The shader reads `texture.rgb` for normal data
and `texture.a` for emission. Two maps, one file.

### Rim Lighting
Rim lighting catches the edge of a subject with light, creating a glowing silhouette that
separates characters from dark backgrounds. Implemented by reading normal map data and
brightening pixels whose surface normals point away from the camera but toward a light source.

Application: players and enemies subtly glow along their silhouette edges, separating them
from the dark corporate environment. Rim color shifts to reflect game state — nano active,
i-frames, clone alert.

### Scene Wide Stylistic Shader Effects

**Nano surge** — nano burst fires, entire scene briefly desaturates, only nano-colored
elements retain and intensify their color. Duration: approximately one second.

**Combo threshold shift** — reaching a high combo count gradually shifts color grading toward
a more saturated, high contrast, painterly look.

**Matter projection reveal** — when clones spawn, a screen wide ripple emanates from their
spawn point. The environment briefly shows the mathematical grid underlying the matter
replication system.

**Strike flash** — major attacks produce a single frame color shift on impact.

### The Complete Visual Stack
1. Base sprites with normal maps — surface detail and physical light response
2. Dynamic Light2D nodes — environmental lighting with accurate shadows
3. Rim lighting shader — character separation from background
4. Baseline color correction — dark corporate palette established globally
5. Bloom and glow — nano and combat light sources amplified
6. Combo and special move shader effects — temporary palette overrides
7. Screen space distortion — major impacts and nano burst detonations
8. Scanline overlay — subtle CRT texture reinforcing cyberpunk aesthetic

---

## Tilemap Depth Illusion — Faking Layered Depth in 2D

### Core Principle
Distant objects appear smaller, move less relative to the camera, are slightly desaturated,
cooler in color, lower in contrast, and less detailed. Applying these cues independently and
simultaneously to background TileMap layers produces convincing depth.

### Scaling to Fake Parallax

```
CanvasLayer -2  motion_scale 0.3  TileMap scale 0.85  ← far background
CanvasLayer -1  motion_scale 0.6  TileMap scale 0.92  ← mid background
CanvasLayer  0  motion_scale 1.0  TileMap scale 1.0   ← gameplay layer
CanvasLayer  1  motion_scale 1.2  TileMap scale 1.05  ← close foreground
```

### Atmospheric Perspective via Color Correction

```
Far background  →  desaturated 30%, blue shifted, contrast reduced
Mid background  →  desaturated 15%, slight blue shift
Gameplay layer  →  full color and contrast
Foreground      →  slightly warmer, full saturation
```

### Fake Depth of Field via Blur Shader

```
Far background   →  blur radius 3-4px
Mid background   →  blur radius 1-2px
Gameplay layer   →  no blur
Foreground       →  optional slight blur
```

### Layered Tile Density
Background layers use simpler lower density tile arrangements. Foreground layers are more
detailed and complex. The eye reads detail density as proximity.

### Light and Shadow as Depth Cue
PointLight2D nodes on the gameplay layer cast light that does not reach background layers
unless specifically configured. Background geometry sitting in relative darkness while the
gameplay layer is lit pushes the background further away perceptually.

---

## Persistent Physical Particles

### Concept
Physical particles are RigidBody2D scenes spawned during combat rather than purely visual
GPU particles. They exist in the physics world — they collide, tumble, stack, and can be
pushed by the player.

### Triggered by Combat
Different moves create different particles:
- Nano moves leave glowing organic debris that pulses softly
- Heavy knockback moves send larger chunks skittering across the floor
- Clone deaths scatter matter projection fragments that shimmer and fade slowly

### Visual Chaos as Skill Indicator
The better you play, the more spectacular the environment looks. A room covered in glowing
debris after a fight is a visual trophy. The room tells the story of the fight.

### Scene Structure
Each particle is its own lightweight RigidBody2D scene:

```
Particle.tscn
├── RigidBody2D (root)
├── Sprite2D (particle visual)
└── CollisionShape2D (physics shape)
```

No AI, no damage logic, no scripts beyond basic physics and a fade out timer.

### Performance Management
- A cap on total active particles prevents accumulation from impacting performance
- When the cap is reached, the oldest particles begin fading out
- Each particle has a maximum lifetime after which it fades regardless of cap status
- Visual particles (GPUParticles2D) handle large burst effects
- Physical RigidBody2D particles are reserved for meaningful persistent pieces

---

## Floor Transitions — Architecture and Player Scaling

### How Player Scaling Works
Camera zoom tweening combined with player scale tweening sells the illusion of the player
moving closer to or further from the camera. Background layers shifting motion_scale
simultaneously reinforces the depth change.

```gdscript
func transition_to_upper_floor():
    var tween = create_tween().set_parallel()
    tween.tween_property(camera, "zoom", Vector2(1.4, 1.4), DURATION)
    tween.tween_property(player, "scale", Vector2(1.15, 1.15), DURATION)
    tween.tween_method(
        func(val): lower_layer.motion_scale = Vector2(val, val),
        1.0, 0.7, DURATION
    )
```

### Multi-Tier Scaling

```
Lower floor    →  camera zoom 0.7,  player scale 0.85
Stair middle   →  camera zoom 1.0,  player scale 1.0   ← neutral point
Upper floor    →  camera zoom 1.4,  player scale 1.15
```

### Scene Scaling System Design
Two modes of operation should be supported and easily toggled:

**Camera-tied scaling** — player scale is driven directly by camera zoom. Scale and zoom
are locked together and change simultaneously.

**Independent tween control** — player scale and camera zoom are separate tweens with their
own durations, easing curves, and target values.

```gdscript
@export var exp_tie_scale_to_camera : bool = true
```

See [floor-transitions.md](../technical/floor-transitions.md) for the full FloorTransitionManager implementation.
