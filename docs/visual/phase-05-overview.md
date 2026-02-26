# Phase 0.5 — Visual Foundation Sprint
*Nano Ninja — Pre-Production Visual Reference*

---

## Purpose

Establish the visual grammar of the game before anything is built on top of it. Every decision made here becomes an assumption the rest of the project rests on. Changing these values after art production begins is expensive — changing them before costs only time.

Phase 0.5 is complete when the visual bible exists and every value in it is locked by experiment rather than assumption.

---

## Goals Before Moving to Phase 1

- [ ] Cavalier oblique angle decided, tested, and locked
- [ ] Character pixel height decided, tested, and locked
- [ ] Game palette defined and locked as shader uniforms
- [ ] Pixel size constant locked and consistent across all shaders
- [ ] Pixel art shader pipeline validated — shader output reads as sprite work
- [ ] Camera zoom range per floor tier settled and documented
- [ ] Cinema 4D master camera rig built and verified at game pixel scale
- [ ] Dual render pass pipeline tested — diffuse and normal map
- [ ] Normal map angle test run — behaviour at locked camera angle documented
- [ ] Drop shadow convention established and applied to test assets
- [ ] Scaling system feel confirmed — smallness feeling holds at all zoom levels
- [ ] Visual bible `docs/visual_bible.md` created and all values populated

---

## The Camera — Cavalier Oblique

Front faces drawn true to scale. Depth axis recedes at a consistent angle at true scale. Walls are perfectly vertical. Characters face the camera directly. No isometric grid constraint.

**Angle range under consideration:** 55–60 degrees
**Reference:** Hades sits at approximately this range — steep enough for spatial clarity, shallow enough to preserve character front face and height

**The decision affects:**
- How much floor plane is visible during combat
- How tall characters appear relative to the environment
- How much front face architecture shows — essential for vertical storytelling

**Drop shadow convention:** A soft blob shadow placed directly beneath every object, perpendicular to the floor plane. Grounds objects in the projection. Applied to every sprite without exception.

---

## Character Pixel Height

**Under consideration:** 32px, 40px, 48px

| Height | Character feel | Detail budget | Environment scale |
|--------|---------------|---------------|-------------------|
| 32px | Very small, classic pixel art | Tight | Very large world feel |
| 40px | Small, readable | Moderate | Large world feel |
| 48px | Present, expressive | Good | World still feels large |

**Recommendation:** 48px — the game is fast and gesture expressive. Nano effects, weapon trails, and attack animations need pixels to work with. The smallness feeling is preserved by the environment scale and zoom system, not the pixel height alone.

**Cinema 4D render scale at 48px:** 480px tall at 10x — recommended render multiplier.

**This value locks:** sprite sheet dimensions, hitbox sizes, tile scale relationship, all enemy heights, UI scale. Cannot change after art production begins.

---

## Pixel Art Shader Pipeline

Five techniques applied together make shaders read as sprite work rather than screen-space effects:

1. **Pixelation** — UV coordinates snapped to pixel grid before sampling
2. **Palette restriction** — output mapped to hard palette steps, no smooth blends
3. **Hand-painted noise textures** — painted in Aseprite at pixel art resolution
4. **Dithering** — Bayer matrix ordered dither instead of smooth alpha blending
5. **Framerate quantization** — TIME snapped to sprite animation fps (12fps target)

**Validation test:** Screenshot a shader frame alongside a sprite frame at the same zoom. If they read as the same visual language the pipeline is working.

---

## The Cinema 4D Pipeline

3D model → orthographic render at locked angle → pixel art paintover in Aseprite

**Master camera rig** (`master_camera_rig.c4d`) — built once, inherited by every asset scene:
- Orthographic projection — no perspective distortion
- Camera at locked cavalier oblique angle
- Directional light at locked angle — upper left conventional
- Ground plane and stand-in cube for scale reference

**Dual render pass per asset:**
- Diffuse pass — flat ambient, clean form for painting over
- Normal map pass — generated from geometry, imported directly to Godot

Normal maps drive PointLight2D response in Godot. Front-facing surfaces respond well at this angle. Top faces and floor surfaces respond minimally — invest normal map detail on character fronts and wall faces.

---

## Scaling System

The floor transition system tweens camera zoom and player scale as the player moves between floor levels. The zoom range and player scale values are tuned during Phase 0.5.

**Starting values to experiment from:**

| Floor level | Camera zoom | Player scale |
|-------------|-------------|--------------|
| Lower | 0.7 | 0.85 |
| Mid (neutral) | 1.0 | 1.0 |
| Upper | 1.4 | 1.15 |

**Two modes to test:**
- Camera-tied — player scale derived directly from zoom, changes simultaneously
- Independent tween — separate durations and easing curves for each

**Validation:** The smallness feeling must hold at the smallest zoom level. Enemy and character sprites must remain readable at all zoom levels.

---

## Visual References

| Game | What it demonstrates |
|------|---------------------|
| Hades | Target camera angle, character height vs environment, dynamic lighting |
| Children of Morta | Pixel art execution at this angle, dark atmosphere, tile density |
| Transistor | Technological city architecture, scale relationships, neon lighting |
| Sword & Sworcery | Spare pixel art language, color temperature per environment |

---

## Output — Visual Bible

`docs/visual_bible.md` is the deliverable of Phase 0.5. It contains every locked value:

- Cavalier oblique angle in degrees
- Character pixel height
- Game palette — all colors with hex values
- Pixel size constant
- Shader animation framerate
- Camera zoom range per floor tier
- Player scale range per floor tier
- District tone mapping signatures per arcology level
- CanvasLayer stack with motion_scale values
- Drop shadow convention
- Cinema 4D camera rig values and light angle
- Sprite render scale multiplier
- Normal map pipeline notes

*Until the visual bible exists all visual decisions are provisional.*
