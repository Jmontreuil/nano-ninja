# Shaders

---

## Overview

Shaders are small programs that run on the GPU and determine the final color of every pixel
on screen. They are how visual polish and effects are achieved without affecting game logic.

Shaders are not optional polish for this game — they are central to communicating game events
and defining visual identity. The nano contagion spread, matter projection destabilisation,
and chip interface effects all depend on shader work. Visuals and mechanics should reinforce
each other.

### Two Types
**Vertex shaders** — run per vertex, control position and shape. Used for wobble, wave, and
distortion effects on geometry.

**Fragment shaders** — run per pixel, control color. Where most 2D game effects live.

### In Godot
Shaders are attached to a ShaderMaterial which is assigned to a node. Godot has a visual
shader editor that builds effects by connecting nodes in a graph rather than writing code
directly — a good entry point before writing shader code by hand.

Shaders can be toggled on and off at runtime by swapping materials, toggling shader parameters,
or replacing shaders entirely while the game is running.

---

## Shader Effects Planned for This Game

**Hit flash** — briefly replaces all sprite colors with a solid color on damage. High game
feel payoff for minimal code. Good first shader to write.

**Outline** — colored border around sprites. Used to highlight enemies, interactive objects,
or player states.

**Dissolve with glowing particles** — uses noise texture to disintegrate a sprite pixel by
pixel. As the sprite dissolves, glowing particles shoot off and fade out. Planned for matter
projection clone death animations.

**Glow and bloom** — bright areas bleed light into surrounding pixels. Central to the neon
color palette and visual identity.

**Screen distortion** — warps screen pixels outward on impact. Planned for nano burst
detonation and major combat events.

**Scanlines** — subtle CRT overlay reinforcing the cyberpunk aesthetic.

**Color correction** — lookup table applied globally to unify the game's color grading.
Ensures the dark base tones and neon accents feel intentional and consistent.

---

## Scene-Wide Stylistic Effects

**Nano surge** — nano burst fires, entire scene briefly desaturates, only nano-colored
elements retain and intensify their color. Duration: approximately one second.

**Combo threshold shift** — reaching a high combo count gradually shifts color grading toward
a more saturated, high contrast, painterly look.

**Matter projection reveal** — when clones spawn, a screen wide ripple emanates from their
spawn point. The environment briefly shows the mathematical grid underlying the matter
replication system.

---

## Procedural Effects

**Noise based effects** — Godot's built in FastNoiseLite generates organic patterns used for
dissolve shaders, nano spread visuals, and terrain variation.

**Shader based procedural animation** — surfaces animated mathematically rather than frame
by frame. Nano corruption spreading across an enemy, a matter projection flickering as it
destabilises, electricity crackling along a surface — all generated in real time.

**Procedural particle behaviour** — noise functions drive particle movement for organic,
unpredictable nano swarm effects that feel alive.

---

## Shader Masks — Layering Noise

Multiple noise textures combined in a shader produce organic masks with large scale structure
and fine surface detail — the classic fractal noise octave pattern.

```glsl
uniform sampler2D noise_a;    // large scale, slow — base shape
uniform sampler2D noise_b;    // medium scale, medium speed — variation
uniform sampler2D noise_c;    // small scale, fast — surface detail
uniform float threshold;
uniform sampler2D screen_texture : hint_screen_texture;

void fragment() {
    float n1 = texture(noise_a, UV * 1.0 + TIME * 0.02).r;
    float n2 = texture(noise_b, UV * 3.0 + TIME * 0.05).r * 0.5;
    float n3 = texture(noise_c, UV * 8.0 + TIME * 0.1).r  * 0.25;

    float combined = (n1 + n2 + n3) / 1.75;
    float mask = smoothstep(threshold - 0.1, threshold + 0.1, combined);

    vec4 original = texture(screen_texture, SCREEN_UV);
    vec4 effect = [your effect here];
    COLOR = mix(original, effect, mask);
}
```

### Externally Building Mask Textures
- **Krita** — free open source, paint greyscale masks by hand, export as PNG
- **Aseprite** — already in the workflow for sprites, good for pixelated masks
- **Godot NoiseTexture2D** — generates noise masks procedurally inside Godot without external tools

---

## Fragment Shader Fundamentals

### Godot Built-In Variables

`UV` — pixel position within the texture, (0,0) top-left to (1,1) bottom-right.

`TEXTURE` — the sprite's texture. Sample with `texture(TEXTURE, UV)`.

`COLOR` — the output. Whatever is assigned here is what the pixel becomes.

`FRAGCOORD` — actual screen position in pixels. Used for dithering and screen-space effects.

`TIME` — seconds since the shader started. Used to animate effects.

`SCREEN_UV` — pixel position on the full screen. Used to sample the screen texture.

---

## Pixel Art Shader Pipeline

### The Core Problem
Procedural shaders look like procedural shaders — smooth, floaty, digital — because they
operate in screen space at full resolution with smooth interpolation. The solution is to
make the shader think in pixel art terms.

### Technique 1 — Pixelation
Quantize UV coordinates to match the pixel art grid:

```glsl
uniform float pixel_size = 4.0;

void fragment() {
    vec2 snapped_uv = floor(UV / pixel_size) * pixel_size;
    COLOR = texture(TEXTURE, snapped_uv);
}
```

### Technique 2 — Palette Restriction
Map output values to specific hand-chosen palette colors:

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

### Technique 3 — Hand Painted Noise Textures
Paint the noise texture by hand in Aseprite or Krita on a pixel art grid. A hand-painted
64x64 pixel greyscale texture tiling across the sprite looks like someone drew it because
someone did.

### Technique 4 — Dithering Instead of Alpha Blending

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

### Technique 5 — Animate at Sprite Framerate
```glsl
uniform float animation_fps = 12.0;

void fragment() {
    float snapped_time = floor(TIME * animation_fps) / animation_fps;
    float noise_val = texture(noise_texture, UV + snapped_time * 0.1).r;
}
```

### The Composited Pipeline Shader
All five techniques in a single shader. One float — `effect_threshold` — drives the entire
effect from game signals:

```glsl
shader_type canvas_item;

uniform float pixel_size = 4.0;
uniform float anim_fps = 12.0;
uniform sampler2D noise_tex;
uniform float effect_threshold : hint_range(0.0, 1.0) = 0.0;

uniform vec4 color_dark   : source_color = vec4(0.1, 0.05, 0.3, 1.0);
uniform vec4 color_mid    : source_color = vec4(0.2, 0.6,  0.9, 1.0);
uniform vec4 color_bright : source_color = vec4(1.0, 0.4,  0.1, 1.0);

const float bayer[16] = float[16](
     0.0,  8.0,  2.0, 10.0,
    12.0,  4.0, 14.0,  6.0,
     3.0, 11.0,  1.0,  9.0,
    15.0,  7.0, 13.0,  5.0
);

void fragment() {
    float t = floor(TIME * anim_fps) / anim_fps;
    vec2 snapped_uv = floor(UV / pixel_size) * pixel_size;
    vec4 original = texture(TEXTURE, snapped_uv);
    float noise_val = texture(noise_tex, snapped_uv * 0.5 + t * 0.05).r;
    noise_val = floor(noise_val * 4.0) / 4.0;

    vec4 effect_color;
    if (noise_val < 0.33) {
        effect_color = color_dark;
    } else if (noise_val < 0.66) {
        effect_color = color_mid;
    } else {
        effect_color = color_bright;
    }

    int bx = int(FRAGCOORD.x) % 4;
    int by = int(FRAGCOORD.y) % 4;
    float dither_threshold = bayer[by * 4 + bx] / 16.0;
    float mask = step(dither_threshold,
        clamp(noise_val - (1.0 - effect_threshold), 0.0, 1.0));

    COLOR = mix(original, effect_color, mask);
}
```

`effect_threshold` is driven from game signals — nano spread strength, hit flash intensity,
transition progress. As it increases from 0 to 1 the effect advances across the sprite using
dithered edges, palette colors, and pixelated noise.

### The Practical Validation Test
Screenshot a frame of the shader alongside a frame of the sprite animation at the same zoom
level. If the shader reads as part of the same visual language — same palette, same pixel
size, same edge character — the pipeline is working.

---

## Shader Resources and Tools

**godotshaders.com** — community library of free open source shaders. Every shader is
readable and tweakable. A learning resource as much as a plugin library. Bookmark immediately.

**Krita** — free and open source. Paint greyscale masks by hand, export as PNG.

**Aseprite** — already in the workflow for sprites. Greyscale pixel art masks exported as PNG.

**Substance Designer** — industry standard for procedural texture and mask generation via
node graph. More powerful than hand painting for mathematically precise procedural masks.

**Godot NoiseTexture2D** — generates noise masks procedurally inside Godot:

```gdscript
var noise = FastNoiseLite.new()
noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
noise.frequency = 0.05
noise.fractal_octaves = 4

var noise_tex = NoiseTexture2D.new()
noise_tex.noise = noise
noise_tex.seamless = true

node_shader_material.set_shader_parameter("mask_texture", noise_tex)
```

### Importing External Masks into Godot
Drag PNG into the filesystem panel. In the Import tab:
- Texture type: Texture2D
- Disable compression for precise greyscale values
- Enable Mipmaps only if viewed at varying zoom levels
- Assign as shader uniform in Inspector or via code

---

## Experimentation Session — Early Development Task
Before committing to a final art style, spend dedicated time in Godot's visual shader editor:
- Get comfortable with the visual shader editor interface
- Experiment with glow, outline, and color correction effects
- Layer multiple shader effects to find combinations that define the game's unique look
- Establish the visual language for nano effects separately
- Define a color grading baseline that reflects the mood board direction

Defining a strong visual identity early prevents costly rework later.
