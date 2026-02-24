# Business and Revenue

---

## Revenue Strategy — Passive Income Offshoots

### The Core Principle
Every system built for the game is a potential standalone product. Technical work done during
development is billable twice — once as part of the game, once as a marketable asset.

### Platforms
**itch.io** — developer-friendly, no gatekeeping, good for experimental and niche products.
**Godot Asset Library** — the primary channel for Godot-specific tools. High discoverability
among the primary target audience.
**Gumroad** — simple, creator-friendly storefronts for digital products.

---

## The Pixel Art Shader Tool — Asset Pack

The pixel art shader pipeline developed for this game is a standalone commercial product.

### What It Is
Most shader marketplaces are dominated by 3D shaders and stylized rendering for Unity and
Unreal. Pixel art specific shader work for Godot is a genuinely underserved niche.

The game development itself is R&D for the product — by the time the game ships the pipeline
will be battle-tested in a real production context.

### What the Pack Includes

**Core shader file** — the composited pipeline shader with fully documented uniforms and
inline comments explaining each technique.

**Hand-painted noise textures** — a library of textures painted in Aseprite at different
pixel art resolutions. Organic spread, mechanical grid, water stain, decay, energy burst.
Each has distinct visual character and produces different effect shapes.

**Palette presets** — named palette configurations matching common pixel art color directions.
Dark cyberpunk, warm industrial, cold clinical, high contrast. Loaded as ShaderMaterial presets.

**GDScript helper class** — wraps the shader material and exposes clean functions:

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

**Documentation with visual examples** — each uniform explained with before and after
screenshots at different values. What each noise texture looks like at different thresholds.
Palette preset previews.

The shader alone is a technique. The documented toolkit with presets and helper classes is
a product with clear value and ease of use.

---

## Promotional Idle Game

A standalone free web game built from systems already developed for the main game. Intended
as a side project to return to when a break from main development is needed.

### Concept
Repackage the automated combat testing routines and wave system into an idle game where
players unlock upgrades by killing waves of enemies. Passively generates upgrade currency
while away, encouraging return visits.

### Why It Makes Sense
- No new systems required — wave combat, upgrade paths, and nano contagion already exist
  in the main game
- Automated testing bots already play the game — minimal additional work to make this presentable
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
Promotional tool that lets players experience the game's identity before purchasing. Not a
priority — return to this when a change of pace from main development is needed.

---

## IP and Long-Term Strategy

The game, the shader pack, and the idle game are all deliverables from the same development
process. Each one builds the others:

- The game validates the shader pipeline in a real production context
- The shader pack is the game's visual R&D packaged and sold
- The idle game uses the game's automated systems as a promotional surface

Development of any one of these advances all three.
