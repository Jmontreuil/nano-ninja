# Phase 0.5 — Visual Exploration Session Plan
*Nano Ninja — Session Guide*

> This plan drives the Phase 0.5 work. Each session has a single clear goal and a
> specific deliverable that goes into `docs/visual_bible.md`. Phase 0.5 is complete
> when the visual bible exists and every value in it is locked by experiment rather
> than assumption.

Reference document: [phase-05-overview.md](phase-05-overview.md)

---

## Session 1 — Cinema 4D Camera Rig

**Goal:** Lock the cavalier oblique angle and build the master camera rig.

**Work:**
- [ ] Set up Cinema 4D scene with orthographic camera
- [ ] Test receding axis at 55°, 57°, 60°
- [ ] Render a stand-in cube at each angle
- [ ] Bring renders into Aseprite at game pixel scale — read which angle feels right
- [ ] Place reference images from Hades side by side — calibrate against target
- [ ] Lock the angle. Build `master_camera_rig.c4d`:
  - Orthographic camera at locked angle
  - Ground plane reference
  - Stand-in cube for scale
  - Directional light — upper left, angle to be decided this session
- [ ] Lock light angle. Document both values.

**Deliverable:** `master_camera_rig.c4d` saved. Cavalier oblique angle and light angle written into `docs/visual_bible.md`.

---

## Session 2 — Pixel Art Shader Pipeline

**Goal:** Implement and validate all five pixel art shader techniques in Godot.

**Work:**
- [ ] Create `scenes/test/shader_test.tscn` — dedicated test scene, never shipped
- [ ] Implement technique 1: **Pixelation** — UV snapped to pixel grid before sampling
- [ ] Implement technique 2: **Palette restriction** — hard steps between defined palette colors
- [ ] Define the game palette — test colors against the art direction brief (dark corporate world, bright combat accents). Export as shader uniforms.
- [ ] Implement technique 3: **Hand-painted noise** — paint first test texture in Aseprite at pixel resolution. Import. Use in shader.
- [ ] Implement technique 4: **Dithering** — Bayer matrix ordered dither instead of smooth alpha
- [ ] Implement technique 5: **Framerate quantization** — TIME snapped to 12fps
- [ ] Run validation test: screenshot shader frame beside sprite frame at same zoom. Do they read as the same visual language?
- [ ] Define and lock pixel size constant.
- [ ] Package all techniques as reusable shader includes.
- [ ] Note: document decisions for the potential shader asset pack

**Deliverable:** Five techniques implemented and validated. Pixel size constant locked. Game palette locked. All written into `docs/visual_bible.md`.

---

## Session 3 — Scaling System and Floor Transitions

**Goal:** Establish and lock the zoom range and player scale values per floor tier.

**Starting values to experiment from:**

| Floor level | Camera zoom | Player scale |
|-------------|-------------|--------------|
| Lower | 0.7 | 0.85 |
| Mid (neutral) | 1.0 | 1.0 |
| Upper | 1.4 | 1.15 |

**Work:**
- [ ] Set up `FloorTransitionManager` in a test scene with three floor zones
- [ ] Test camera-tied mode — scale and zoom change simultaneously
- [ ] Test independent tween mode — separate durations and easing curves
- [ ] Tune zoom range: does the lower floor feel appropriately vast? Does upper feel intimate?
- [ ] Validate the smallness feeling at the lowest zoom — player dwarfed by environment
- [ ] Validate enemy readability — would a roughly 48px enemy still read clearly at all zoom levels?
- [ ] Lock tween duration and easing curves
- [ ] Lock zoom values and player scale values per tier
- [ ] Lock the camera-tied vs independent decision and export setting

**Deliverable:** Zoom range locked. Player scale values locked. Tween mode locked. All written into `docs/visual_bible.md`. Test scene archived or saved as reference.

---

## Session 4 — Character Pixel Height Decision

**Goal:** Lock the player character's pixel height.

> This session depends on Session 3 being complete — zoom range must be established
> before pixel height is decided.

**Candidates:** 32px, 40px, 48px

**Work:**
- [ ] Place stand-in rectangles at each candidate height in the test scene
- [ ] Run at all zoom levels — which height maintains combat readability at maximum zoom-in?
- [ ] Run at minimum zoom — does the character read against large empty environment?
- [ ] Test smallness feeling: character against a large wall section and open floor area
- [ ] Make mirroring decision: draw all 8 directions for player, mirror acceptable for secondary enemies
- [ ] Lock the value. Calculate Cinema 4D render scale (height × 10 recommended).
- [ ] Calculate sprite sheet dimensions for player

**Deliverable:** Character pixel height locked. Render scale multiplier calculated. Mirroring decision recorded. All written into `docs/visual_bible.md`.

---

## Session 5 — Normal Map Pipeline Test

**Goal:** Validate that normal maps work correctly at the locked camera angle before committing them to production.

> This session depends on Session 1 (locked camera angle) and Session 4 (character height).

**Work:**
- [ ] Render a simple character stand-in from Cinema 4D at the locked angle
- [ ] Generate its normal map from the same Cinema 4D scene
- [ ] Import diffuse sprite and normal map into Godot via CanvasTexture
- [ ] Place a PointLight2D at several positions around the sprite
- [ ] Move the light in real time — observe surface response on front faces and top faces
- [ ] Test at all zoom levels from Session 3 — observe behavior during the kind of transition the floor system produces
- [ ] Establish dual render pass workflow as confirmed pipeline or flag issues

**Deliverable:** Normal map test documented in `docs/visual_bible.md`. Dual render pass pipeline confirmed (or adjusted based on findings). Investment priorities noted (front faces high value, top faces low).

---

## Session 6 — Visual Bible Compilation

**Goal:** Compile all locked values from Sessions 1–5 into `docs/visual_bible.md`.

**Work:**
- [ ] Create `docs/visual_bible.md` if it doesn't exist
- [ ] Populate all sections with locked values:
  - Cavalier oblique angle in degrees
  - Light angle in Cinema 4D
  - `master_camera_rig.c4d` parameter notes
  - Character pixel height
  - Cinema 4D render scale multiplier
  - Game palette — all colors with hex values
  - Pixel size constant
  - Shader animation framerate (12fps target)
  - Camera zoom range per floor tier
  - Player scale per floor tier
  - Tween mode (camera-tied vs independent)
  - Tween duration and easing curves
  - Drop shadow convention
  - Mirroring decision
  - Normal map pipeline findings
  - District tone mapping signatures (placeholder — developed during level production)
  - CanvasLayer stack with motion_scale values
- [ ] Review: is every value in the visual bible a locked result rather than an assumption?
- [ ] Push visual_bible.md to GitHub wiki

**Deliverable:** `docs/visual_bible.md` complete. Phase 0.5 is done. Phase 1 prototype is built inside a defined visual framework.

---

## Milestone Condition

Phase 0.5 is complete when:

> The visual bible exists and every value in it was locked by experiment, not assumption.
> Phase 1 level building begins inside a fixed visual framework with no provisional values.

---

*Generated from `docs/visual/phase-05-overview.md` — February 25 2026*
