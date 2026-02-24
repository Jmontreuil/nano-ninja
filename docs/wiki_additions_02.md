# Wiki Additions — Session February 23 2026

---

## Visual Scale Design

### Reference Scale
Based on reference screenshot analysis — small character in a large world approach.

- Character occupies approximately 3-4% of screen height
- Environment objects are 2-6 times the character's size
- Tile size target: 64x64 pixels
- Character sprite target: approximately 32x48 pixels
- Collision shape: approximately 60-70% of sprite size for nimble feel
- Camera2D zoom: approximately 0.5 to 0.7 for reference scale feel

The player reads as nimble and precise against massive industrial surroundings.
A lone ninja dwarfed by corporate architecture built at machine scale, not
human scale. The environment intimidates by scale alone.

### David vs Goliath Philosophy
Scale is a visual concept used deliberately throughout the game. The size
relationship between the player and the world is a storytelling tool — the
small character against vast spaces, enormous enemies, and imposing
architecture communicates the narrative without words.

As the visual language develops, layering and scale should remain a constant
lens. The camera, the layer stack, the scale of enemies and environments are
active tools, not passive settings.

### Dynamic Camera System
The Camera2D zoom and position are used actively during both combat and
storytelling to emphasize scale relationships.

**Combat effectiveness thresholds** — the camera punches in when the player
crosses a combo or skill threshold. The zoom makes combat feel intimate and
intense precisely when the player is excelling. Zoom is lerped smoothly so
the transition feels dynamic. The game acknowledges exceptional play with
a cinematic response.

The camera punching in during a combo threshold simultaneously adjusts the
motion_scale of foreground layers to amplify the parallax depth effect and
shifts the motion_offset of background layers for additional drama. Scale,
depth, and camera work are considered together as a unified system.

**Vast spaces** — the camera zooms way out in large open environments to
emphasize vastness. Emerging from a tight corridor into a massive corporate
atrium pulls the camera back to reveal full scale. Scale contrast between
spaces creates emotional rhythm.

**Boss and large enemy reveals** — camera pulls back on first encounter
with large enemies and bosses, emphasizing their scale relative to the
player. The mech reveal on the ruined rooftop is a specific candidate for
a dramatic pull back moment.

**Claustrophobic tight spaces** — tight corridors push the camera in,
increasing tension. Emerging into open spaces releases it.

**Story beat camera work** — the opening sequence, surgical lab awakening,
and ending cutscenes use keyframed Camera2D zoom and position via
AnimationPlayer for precise authored cinematic moments.

**Zoom range:** approximately 0.3 (vast reveal) to 1.0 (tight combat punch in)

---

## Foreground Graphics and Z Index

### Z Index
Z index is a property every Node2D has. Higher Z index renders in front
of lower Z index.

- Floor tiles: Z index -1
- Player: Z index 0
- Foreground pipes and rafters: Z index 1

Multiple objects can share the same Z index — Godot resolves draw order
among same-Z objects by their position in the scene tree. Nodes lower in
the tree draw in front of nodes higher up.

No hard limit on object count per Z index. The practical limit is
performance rather than a system cap.

### Examining Z Index in Godot
- **Inspector** — shows Z index value of any selected node, editable directly
- **Remote Scene Tree** — the primary debugging tool. Pause the running game
  and inspect every live node's current Z index value and rendering order
- No dedicated visual layer stack panel exists — Z index is managed numerically

### YSort
YSort is a property enabled on a Node2D that automatically sorts its
children by their Y position on screen. Objects lower on screen render
in front of objects higher on screen. Essential for top down games —
a character walking behind a crate automatically renders behind it,
walk in front and they render in front. Eliminates manual Z index
management for world objects.

### Foreground Alpha Fade
When the player moves under a foreground element, an Area2D detects the
overlap and fades the element's alpha so the player remains visible beneath
it. The foreground object still renders in front — it becomes partially
transparent to keep the player readable. Triggered by signal.

Foreground elements reinforce the scale concept — pipes and rafters
rendering over the player momentarily emphasize the small character
in a large world.

---

## Canvas Layers

### Overview
Godot supports up to 128 CanvasLayers, numbered -128 to 127. Lower numbers
render behind higher numbers.

```
-128 to -1    →    background layers
0             →    default world layer
1 to 127      →    foreground and UI layers
```

### Key Properties

**`layer`** — Z order of the canvas layer, -128 to 127.

**`motion_scale`** — Vector2 controlling parallax speed relative to the camera.
The core parallax tool:
- `Vector2(0, 0)` — fixed to screen, does not move
- `Vector2(0.5, 0.5)` — moves at half camera speed, background parallax
- `Vector2(1, 1)` — moves exactly with camera, normal world objects
- `Vector2(1.5, 1.5)` — moves faster than camera, foreground parallax

**`motion_offset`** — Vector2 adding a fixed pixel offset independent of
camera movement. Useful for slow atmospheric drift effects or subtle
layer alignment corrections. Animatable for additional camera drama.

**`follow_viewport_enabled`** — boolean controlling whether the layer
follows the camera (world elements) or stays fixed to the screen (UI).
Set deliberately on every layer.

**`follow_viewport_scale`** — scales the layer relative to the viewport
when follow_viewport_enabled is true. Creates depth through scale
difference as well as movement difference.

**`transform`** — full Transform2D giving direct control over the layer's
position, rotation, and scale as a whole. Animatable via AnimationPlayer
or Tween. Enables rotating or scaling entire layers during special moves
or dramatic story moments.

**`offset`** — applied before the camera transform rather than after.
For precise world space alignment.

**`custom_viewport`** — assigns a specific Viewport to the layer rather
than the default screen. Enables picture in picture effects and rendering
scenes within scenes. Candidate for nano computer terminal interface
display — a separate rendered view shown on a screen within the world.

**`visible`** — hides everything on the layer simultaneously. The
VisualEffectsManager autoload can toggle entire visual layers with
one line of code.

### Capabilities

**Animating layer properties** — any CanvasLayer property can be keyframed
in AnimationPlayer or driven by Tween. Camera punch-in during combat
threshold simultaneously adjusts foreground motion_scale and background
motion_offset for unified dramatic effect.

**Shaders per layer** — a shader applied to a CanvasGroup node on a layer
affects everything on that layer simultaneously. Full screen nano surge
desaturation effect lives on its own layer, toggled independently.

**Independent coordinate spaces** — each layer has its own coordinate
system. UI on fixed layers is positioned relative to screen. World
elements on following layers are positioned in world space.

### Limitations

**No blending modes between layers** — Multiply, Screen, and other blend
modes are not available as layer properties. Blending effects between
layers require shader work.

**No per layer lighting** — Godot's 2D lighting affects the entire world
regardless of layer. Independent lighting per layer requires shader
intervention.

**CanvasGroup performance** — applying shaders to entire layers requires
Godot to render that layer to a separate texture first. Monitor how many
full layer shaders run simultaneously.

**Transform isolation** — nodes on a CanvasLayer do not inherit transforms
from nodes on other layers. Each layer is its own isolated transform space.

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

Gaps between numbers are intentional — room to insert new layers later
without renumbering.

---

## Advanced Visual Effects — Normal Maps, Rim Lighting,
and Scene Wide Stylistic Shaders

### Normal Maps in 2D
Normal maps are textures that encode surface direction per pixel, allowing
Godot's 2D lighting system to calculate physically accurate light
interaction with flat sprites. Stone floors gain bumps and grooves that
catch light dynamically. Enemy armor reflects light accurately as
characters move.

Applied via CanvasTexture in Godot 4, which bundles diffuse texture and
normal map together as a single material on a Sprite2D. Every sprite
intended to interact with dynamic lighting should have a corresponding
normal map.

Normal maps must be created externally. Recommended tools:
- **Laigter** — free open source dedicated 2D normal map generator
- **SpriteIlluminator** — dedicated 2D normal map generator
- **Sprite DLight** — feed in a sprite, generates normal map from shape
- Photoshop and Krita can generate normal maps from height maps via plugins

### Channel Packing
Godot's shader system provides direct access to individual color channels
of any texture. Multiple maps can be stored in channels of one image file —
for example, normal map data in RGB and an emission mask in the alpha channel.
The shader reads `texture.rgb` for normal data and `texture.a` for emission.
Two maps, one file. Standard professional technique, natively supported.

### Rim Lighting
Rim lighting catches the edge of a subject with light, creating a glowing
silhouette that separates characters from dark backgrounds. Unlike a flat
outline shader, rim lighting is physically motivated — it responds
dynamically to light source positions and character movement.

Implemented by reading normal map data and brightening pixels whose surface
normals point away from the camera but toward a light source — exactly the
edge pixels.

Application: players and enemies subtly glow along their silhouette edges,
separating them from the dark corporate environment. Rim color shifts to
reflect game state — nano active, i-frames, clone alert.

### Scene Wide Stylistic Shader Effects
Special moves and high combo thresholds trigger scene wide effects that
temporarily transform how the entire game looks.

**Nano surge** — nano burst fires, entire scene briefly desaturates, only
nano-colored elements retain and intensify their color. Duration:
approximately one second.

**Combo threshold shift** — reaching a high combo count gradually shifts
color grading toward a more saturated, high contrast, painterly look.
The world responds to skill level visually.

**Matter projection reveal** — when clones spawn, a screen wide ripple
emanates from their spawn point. The environment briefly shows the
mathematical grid underlying the matter replication system before
snapping back to normal.

**Strike flash** — major attacks produce a single frame color shift on
impact. Communicates the weight of the hit before any other feedback.

### Ray Cast Lighting for Accurate Highlights
Godot's Light2D nodes with shadow casting enabled produce physically
accurate shadows based on collision geometry. Normal maps add surface
detail to how shadows and highlights fall on every surface.

LightOccluder2D attached to enemies means combat light flashes cast real
shadows in the environment for their duration. Every normal mapped surface
responds correctly to the light position of the impact.

Point2D lights placed dynamically at attack origins during special moves
create a frame of accurate environmental lighting that reinforces the
physical impact of the action.

### The Complete Visual Stack
Layered in order:

1. Base sprites with normal maps — surface detail and physical light response
2. Dynamic Light2D nodes — environmental lighting with accurate shadows
3. Rim lighting shader — character separation from background
4. Baseline color correction — dark corporate palette established globally
5. Bloom and glow — nano and combat light sources amplified
6. Combo and special move shader effects — temporary palette overrides
7. Screen space distortion — major impacts and nano burst detonations
8. Scanline overlay — subtle CRT texture reinforcing cyberpunk aesthetic

---

## Development Workflow — Git Branching

### The Core Principle
The main branch always contains the stable working version of the game.
Experimental ideas live on separate branches and never touch main until
they are proven to work.

### The Branching Workflow

**Create a branch:**
```
git checkout -b descriptive-branch-name
```

**Build and test freely on that branch.**

**If it works — merge into main:**
```
git merge descriptive-branch-name
```

**If it doesn't work — delete the branch, main is untouched:**
```
git branch -d descriptive-branch-name
```

### Practical Example — Combat Camera Experimentation
Rather than building one camera approach and overwriting it to try
something different, run multiple branches simultaneously:

- `camera-threshold-zoom` — zoom triggered by combo thresholds
- `camera-velocity-zoom` — zoom responds to player movement speed
- `camera-combat-zones` — defined areas of the level trigger zoom changes

Switch between branches to compare approaches directly before committing
to one direction and merging into main.

### In Antigravity
The branch indicator at the bottom of the window lets you create and
switch branches without using the terminal.

### When to Branch
- Testing any new mechanic or system before committing
- Camera feel experiments
- Visual shader experiments
- Risky refactors — restructuring existing code safely
- Any idea where a safe fallback position is needed

### Notes
Branch names should be descriptive enough to know what they contain
weeks later. `camera-combat-zoom-experiment` is useful.
`test-branch-3` is not.

---

## Endless Mode — Narrative Framing

### Corporate Simulator and Hacked Mode
The default simulator is corporate and sterile. Environments are clean,
options are predictable, enemy configurations are standardised. It feels
like a training tool designed by committee.

A rebellious young scientist working at the corporation secretly embedded
a hacked mode into the simulator — chaotic, unpredictable, and nothing
like anything the corporation intended.

Two unlock options under consideration:
- Finding a hidden access code somewhere in the game environment
  through exploration
- Completing the sterile corporate simulator unlocks it as a reward

Once unlocked, hacked mode enables full procedural chaos — random
modifiers, unexpected enemy combinations, environments the corporation
would never have approved.

---

## Environmental Storytelling and Characters

### Approach
Characters are revealed through discovered objects — notes, emails,
photographs, activated items — rather than cutscenes or dialogue dumps.
The world has a life that exists independently of the player's presence.

Activating or examining an object can trigger a brief thought from the
player character. Example: finding a photograph triggers "the family
in this photo looks happy." Objects carry emotional weight without
exposition.

### The Young Scientist
Unsure about working for a large corporation. Quietly rebellious spirit.
Created the hacked simulator mode as a small personal act of defiance —
something unauthorised buried inside corporate infrastructure.

Revealed entirely through what they left behind — notes, emails, small
objects in the lab environment. Their arc is told without them ever
appearing on screen.

---

## Discussion List — Updated

1. How enemy AI works in Godot
2. Working with a game controller during development
3. Sprite creation and art tools
4. Shaders
5. Normal maps
6. Plugins and effects libraries
7. Combos and moves
8. Signals in depth
9. Resources
10. Autoloads / Singletons
11. Scene switching and level loading
12. Saving and loading game data
13. Physics layers and masks in depth
14. RayCast2D
15. Physics body types
16. Audio bus system
17. Control node family in depth
18. Building menus, HUDs, and dialogue systems
19. Screenshake, hitpause, and game feel techniques
20. Procedural generation basics in Godot
21. Optimization and performance
22. Art direction and tone
23. Accessibility — colorblindness support, user definable color wheel
    with presets, research reference games with strong accessibility options
24. Matter replication system — narrative and mechanical role revisited
25. Nano system without antimatter — redesigning the combat upgrade path
26. Player voice — how the game addresses the player, second vs third
    person perspective, including thoughts from the player character
