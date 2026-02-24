# Wiki Additions — Session February 23 2026 (Part 8)

---

## Tilemap Depth Illusion — Faking Layered Depth in 2D

### Core Principle
Distant objects appear smaller, move less relative to the camera,
are slightly desaturated, cooler in color, lower in contrast, and
less detailed. Applying these cues independently and simultaneously
to background TileMap layers produces convincing depth without 3D
rendering.

### Scaling to Fake Parallax
Scale TileMap layers down slightly on distant CanvasLayers combined
with slower motion_scale:

```
CanvasLayer -2  motion_scale 0.3  TileMap scale 0.85  ← far background
CanvasLayer -1  motion_scale 0.6  TileMap scale 0.92  ← mid background
CanvasLayer  0  motion_scale 1.0  TileMap scale 1.0   ← gameplay layer
CanvasLayer  1  motion_scale 1.2  TileMap scale 1.05  ← close foreground
```

Scale reduction on distant layers makes them appear physically further
away. Combined with slower motion_scale the effect reads as convincing
parallax depth.

### Atmospheric Perspective via Color Correction
Distant objects appear desaturated, cooler in color, and lower in
contrast due to atmospheric haze. Applied per CanvasLayer via shader:

```
Far background  →  desaturated 30%, blue shifted, contrast reduced
Mid background  →  desaturated 15%, slight blue shift
Gameplay layer  →  full color and contrast
Foreground      →  slightly warmer, full saturation
```

Subtle is more convincing than heavy handed. The shift does not need
to be dramatic to read as depth.

### Fake Depth of Field via Blur Shader
A gaussian blur shader applied to background CanvasLayers approximates
depth of field — the eye reads blurred elements as further away
automatically.

```
Far background   →  blur radius 3-4px
Mid background   →  blur radius 1-2px
Gameplay layer   →  no blur
Foreground       →  optional slight blur
```

Combines with color correction — distant geometry is simultaneously
desaturated, color shifted, and blurred. Three independent depth cues
firing simultaneously.

### Layered Tile Density
Background layers use simpler lower density tile arrangements.
Foreground layers are more detailed and complex. The eye reads detail
density as proximity — sparse geometry feels distant, dense detailed
geometry feels close. A technique borrowed from traditional animation.

### Light and Shadow as Depth Cue
PointLight2D nodes on the gameplay layer cast light that does not
reach background layers unless specifically configured. Background
geometry sitting in relative darkness while the gameplay layer is lit
pushes the background further away perceptually. A subtle ambient glow
on the far background — slightly different color from gameplay lighting —
reinforces the separation.

### The Hub Vertical Room — Applied Example
For a large vertical room with doors on a lower and upper level:

```
Far background   →  blurred, desaturated distant arcology interior
Mid background   →  structural columns and piping, scaled down
Near background  →  close wall detail, normal color and contrast
Gameplay         →  walkable platforms, both door levels, player
Foreground       →  structural elements in front of player
```

The player standing at a lower door looking up at the upper doors has
the full vertical space rendered with depth cues at every layer. The
room reads as genuinely tall rather than a flat vertical rectangle.
