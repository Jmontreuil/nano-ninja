# Wiki Additions — Session February 23 2026 (Part 12)

---

## Fragment Shaders — Fundamentals and Pixel Art Pipeline

### What a Fragment Shader Is
A fragment shader is a program that runs once per pixel, every frame,
on the GPU. Not once per sprite, not once per node — once per pixel.
On a 1280x720 screen that is 921,600 executions per frame, running in
parallel across thousands of GPU cores simultaneously.

The shader receives information about the current pixel and outputs one
value: what color that pixel should be. Everything a fragment shader does
is in service of computing that final color.

```glsl
void fragment() {
    COLOR = texture(TEXTURE, UV);  // simplest shader — show the texture
}
```

### Godot Built In Variables

`UV` — current pixel's position within the texture. Ranges from (0,0)
at top-left to (1,1) at bottom-right. Primary way to know where you are
on the sprite.

`TEXTURE` — the sprite's texture. Sample with `texture(TEXTURE, UV)` to
get the original pixel color at any UV position.

`COLOR` — the output. Whatever is assigned here is what the pixel becomes.
A vec4 — red, green, blue, alpha.

`FRAGCOORD` — the pixel's actual screen position in pixels. Absolute
screen coordinates rather than relative UV. Used for screen-space effects
and for the dither matrix position lookup.

`TIME` — seconds since the shader started running. Used to animate effects.

`SCREEN_UV` — pixel position on the full screen rather than within the
sprite. Used to sample the screen texture for post-processing effects.

---

### Technique 1 — Pixelation in the Fragment Shader
Snap UV to a grid before sampling. Every pixel within a block reads from
the same texture coordinate — producing a blocky pixelated look that
matches the pixel art grid:

```glsl
uniform float pixel_size = 4.0;

void fragment() {
    vec2 snapped_uv = floor(UV / pixel_size) * pixel_size;
    COLOR = texture(TEXTURE, snapped_uv);
}
```

### Technique 2 — Palette Restriction in the Fragment Shader
Map each pixel to its nearest palette entry. The palette is defined as
an array of vec4 colors in the shader. Output is always one of the
defined palette colors — nothing else:

```glsl
uniform vec4 palette[8];
uniform int palette_size = 8;

vec4 nearest_palette_color(vec4 input_color) {
    float min_dist = 999.0;
    vec4 nearest = palette[0];
    for (int i = 0; i < palette_size; i++) {
        float dist = distance(input_color.rgb, palette[i].rgb);
        if (dist < min_dist) {
            min_dist = dist;
            nearest = palette[i];
        }
    }
    return nearest;
}

void fragment() {
    vec4 original = texture(TEXTURE, UV);
    COLOR = nearest_palette_color(original);
}
```

### Technique 3 — Dithering in the Fragment Shader
Use FRAGCOORD to look up a position in the Bayer matrix. The `step()`
function produces 0 or 1 — no gradient, just on or off. Whether a pixel
is on or off depends on its screen position and the effect value:

```glsl
const float bayer[16] = float[16](
     0.0,  8.0,  2.0, 10.0,
    12.0,  4.0, 14.0,  6.0,
     3.0, 11.0,  1.0,  9.0,
    15.0,  7.0, 13.0,  5.0
);

void fragment() {
    int bx = int(FRAGCOORD.x) % 4;
    int by = int(FRAGCOORD.y) % 4;
    float threshold = bayer[by * 4 + bx] / 16.0;
    
    float effect_value = [0-1 value driving the effect];
    float dithered = step(threshold, effect_value);
    
    COLOR = mix(original_color, effect_color, dithered);
}
```

### Technique 4 — Framerate Quantization in the Fragment Shader
Snap TIME to discrete steps matching the sprite animation rate. Every
pixel sees the same quantized time — the entire effect updates
simultaneously in frame steps:

```glsl
uniform float anim_fps = 12.0;

void fragment() {
    float snapped_time = floor(TIME * anim_fps) / anim_fps;
    // use snapped_time wherever TIME would be used
}
```

---

### The Composited Pipeline Shader
All five techniques in a single shader. One float — `effect_threshold`
— drives the entire effect from game signals:

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
    // 1. Quantize time to animation framerate
    float t = floor(TIME * anim_fps) / anim_fps;

    // 2. Snap UV to pixel grid
    vec2 snapped_uv = floor(UV / pixel_size) * pixel_size;

    // 3. Sample original texture at snapped coordinates
    vec4 original = texture(TEXTURE, snapped_uv);

    // 4. Sample noise at pixelated coordinates
    float noise_val = texture(noise_tex, snapped_uv * 0.5 + t * 0.05).r;

    // 5. Quantize noise to discrete steps
    noise_val = floor(noise_val * 4.0) / 4.0;

    // 6. Map noise value to palette colors with hard steps
    vec4 effect_color;
    if (noise_val < 0.33) {
        effect_color = color_dark;
    } else if (noise_val < 0.66) {
        effect_color = color_mid;
    } else {
        effect_color = color_bright;
    }

    // 7. Dither the blend between original and effect
    int bx = int(FRAGCOORD.x) % 4;
    int by = int(FRAGCOORD.y) % 4;
    float dither_threshold = bayer[by * 4 + bx] / 16.0;
    float mask = step(dither_threshold,
        clamp(noise_val - (1.0 - effect_threshold), 0.0, 1.0));

    COLOR = mix(original, effect_color, mask);
}
```

`effect_threshold` is driven from game signals — nano spread strength,
hit flash intensity, transition progress. As it increases from 0 to 1
the effect advances across the sprite using dithered edges, palette
colors, and pixelated noise. The whole pipeline fires from one number.

---

### The Pixel Art Shader Tool — Product Structure

The shader is the engine. The tool is the package:

**Core shader file** — the composited pipeline shader with fully
documented uniforms and inline comments explaining each technique.

**Hand-painted noise textures** — a library of textures painted in
Aseprite at different pixel art resolutions and organic characters.
Organic spread, mechanical grid, water stain, decay, energy burst.
Each has distinct visual character and produces different effect shapes.

**Palette presets** — named palette configurations matching common
pixel art color directions. Dark cyberpunk, warm industrial, cold
clinical, high contrast. Loaded as ShaderMaterial presets.

**GDScript helper class** — wraps the shader material and exposes clean
functions other systems call without needing to know shader uniform names:

```gdscript
# pixel_art_effect.gd
class_name PixelArtEffect
extends Node

@onready var node_shader : ShaderMaterial

func apply_effect(strength: float, duration: float = 0.0):
    if duration > 0.0:
        var tween = create_tween()
        tween.tween_method(
            func(val): node_shader.set_shader_parameter(
                "effect_threshold", val),
            0.0, strength, duration
        )
    else:
        node_shader.set_shader_parameter("effect_threshold", strength)

func set_palette(palette_name: String):
    var palette = PaletteLibrary.get_palette(palette_name)
    node_shader.set_shader_parameter("color_dark",   palette.dark)
    node_shader.set_shader_parameter("color_mid",    palette.mid)
    node_shader.set_shader_parameter("color_bright", palette.bright)

func set_noise(noise_name: String):
    var tex = NoiseLibrary.get_texture(noise_name)
    node_shader.set_shader_parameter("noise_tex", tex)
```

**Documentation with visual examples** — each uniform explained with
before and after screenshots at different values. What each noise texture
looks like at different thresholds. Palette preset previews.

This package is what other developers purchase. The shader alone is a
technique. The documented toolkit with presets and helper classes is a
product with clear value and ease of use.

### Asset Pack Positioning
Most shader marketplaces are dominated by 3D shaders and stylized
rendering for Unity and Unreal. Pixel art specific shader work for
Godot is a genuinely underserved niche. The game development itself
is R&D for the product — by the time the game ships the pipeline will
be battle-tested in a real production context. Platforms: itch.io,
Godot Asset Library, Gumroad.
