# Wiki Additions — Session February 23 2026 (Part 10)

---

## Pixel Art Shader Pipeline

### The Core Problem
Procedural shaders look like procedural shaders — smooth, floaty, digital
— because they operate in screen space at full resolution with smooth
interpolation. Sprite work looks like sprite work because it is pixel
aligned, has hard edges, operates on a grid, and has the character of
something hand touched.

The solution is to make the shader think in pixel art terms.

### Technique 1 — Pixelation
Quantize UV coordinates to match the pixel art grid. If sprites are on
a 4x4 pixel grid the shader snaps to the same grid. Quantize the noise
value to a small number of discrete steps simultaneously:

```glsl
uniform float pixel_size = 4.0;

void fragment() {
    // Snap UV to pixel grid
    vec2 pixelated_uv = floor(UV * (1.0 / pixel_size)) * pixel_size;
    
    // Sample noise at quantized coordinates
    float noise_val = texture(noise_texture, pixelated_uv + TIME * 0.02).r;
    
    // Quantize noise value to discrete steps
    float steps = 4.0;
    noise_val = floor(noise_val * steps) / steps;
}
```

Result: the effect moves and changes in pixel-sized jumps rather than
smooth continuous motion. It looks drawn rather than generated.

### Technique 2 — Palette Restriction
Smooth procedural effects blend through thousands of colors. Pixel art
uses a restricted palette. Map output values to specific hand-chosen
palette colors rather than interpolating freely:

```glsl
uniform vec4 color_a = vec4(0.1, 0.05, 0.3, 1.0);  // dark purple
uniform vec4 color_b = vec4(0.2, 0.6,  0.9, 1.0);  // bright blue
uniform vec4 color_c = vec4(1.0, 0.4,  0.1, 1.0);  // orange accent

void fragment() {
    float val = [noise or mask value];
    
    vec4 color;
    if (val < 0.33) {
        color = color_a;
    } else if (val < 0.66) {
        color = color_b;
    } else {
        color = color_c;
    }
    
    COLOR = mix(original, color, mask);
}
```

Hard steps between palette colors rather than smooth gradients. Transitions
happen in discrete jumps exactly like hand-painted pixel art animation.

### Technique 3 — Hand Painted Noise Textures
Instead of generated noise, paint the noise texture by hand in Aseprite
or Krita on a pixel art grid. A hand-painted 64x64 pixel greyscale
texture tiling across the sprite looks like someone drew it because
someone did.

The shader still drives animation and threshold logic — but the texture
it reads from has the character of hand work. Scrolling a hand-painted
texture over a sprite produces an effect that reads as an animated pixel
art overlay rather than a procedural system.

For nano spread — a hand-painted organic texture in the game's pixel art
resolution defines the spread boundary. The nano looks drawn into the
world rather than computed over it.

### Technique 4 — Dithering Instead of Alpha Blending
Pixel art transparency is handled with dithering — alternating pixels of
two colors in a checkerboard or ordered pattern — not smooth alpha.
Applying this to shader transitions makes them read as pixel art:

```glsl
float dither_matrix[16] = float[16](
     0.0,  8.0,  2.0, 10.0,
    12.0,  4.0, 14.0,  6.0,
     3.0, 11.0,  1.0,  9.0,
    15.0,  7.0, 13.0,  5.0
);

void fragment() {
    int x = int(FRAGCOORD.x) % 4;
    int y = int(FRAGCOORD.y) % 4;
    float threshold = dither_matrix[y * 4 + x] / 16.0;
    
    float alpha = step(threshold, effect_strength);
    COLOR = mix(original, effect_color, alpha);
}
```

A nano spread advancing with dithered edges looks like animated pixel art.
The spread boundary has the characteristic pixel checkerboard pattern
rather than a smooth antialiased edge.

### Technique 5 — Animate at Sprite Framerate
Shaders update every frame at 60fps — smooth continuous motion. Pixel
art animations run at 8, 12, or 24fps. Quantize TIME to match:

```glsl
uniform float animation_fps = 12.0;

void fragment() {
    float snapped_time = floor(TIME * animation_fps) / animation_fps;
    float noise_val = texture(noise_texture, UV + snapped_time * 0.1).r;
}
```

The shader updates in discrete frame steps matching the sprite animation
rate. Nano spread advancing at 12fps looks like part of the same animated
world as the sprites around it.

### The Full Pipeline — Applied to Nano Spread
All five techniques combined:
1. Hand-painted noise texture in Aseprite at pixel art resolution
2. UV coordinates quantized to pixel grid size
3. Noise value quantized to small number of discrete steps
4. Output mapped to palette colors with hard steps
5. Edges handled with ordered dithering, not smooth alpha
6. TIME quantized to match sprite animation framerate

Each technique individually nudges the shader toward sprite work.
All five together produce something that sits inside the pixel art world
rather than floating over it.

### The Practical Validation Test
Screenshot a frame of the shader alongside a frame of the sprite
animation. View at the same zoom level. If the shader reads as part of
the same visual language — same palette, same pixel size, same edge
character — the pipeline is working. If it looks like a filter applied
over sprite work, one of the five techniques above is still missing.

---

## Scene Scaling System — Manager Design Notes

### What the Manager Should Do
The floor transition scaling system benefits from flexibility built in
from the start. Two modes of operation should be supported and easily
toggled:

**Camera-tied scaling** — player scale is driven directly by camera zoom.
Scale and zoom are locked together and change simultaneously. Simpler
and automatic but less control over the relationship between the two.

**Independent tween control** — player scale and camera zoom are separate
tweens with their own durations, easing curves, and target values. More
control, allows interesting timing like the camera arriving before the
player scale resolves or vice versa.

A boolean export toggle switches between modes:

```gdscript
@export var exp_tie_scale_to_camera : bool = true
```

When true, player scale is derived from camera zoom automatically.
When false, independent tween values are used.

### Experimentation Notes
This system should be built early and treated as a dedicated
experimentation session before levels are built around it. The right
feel will not be obvious until played with in real time. Variables to
tune during experimentation:

- The zoom range between floor tiers (0.7 to 1.4 is a starting point)
- Whether player scale change is subtle or pronounced
- Tween duration — faster feels more dynamic, slower feels more cinematic
- Easing curve — ease in out feels natural, linear feels mechanical,
  ease out feels like arriving somewhere
- Whether the camera leads the player scale or follows it
- Whether a slight camera rotation tween (1-2 degrees) during transition
  adds cinematic quality

Treat the first session with this system as pure play. Tune values,
compare feels, commit nothing until something is clearly right.

---

## Side Tasks Added

- **Pixel art shader pipeline experimentation** — dedicated session to
  build and tune the five pixel art shader techniques before visual
  development begins in earnest. Foundational to the game's visual
  identity. Do before Phase 2 level building.

- **Scaling system experimentation** — dedicated session with the
  FloorTransitionManager to establish the correct zoom range, player
  scale values, tween settings, and camera-tie behaviour. Foundational
  to how levels are designed. Do before hub room is built.
