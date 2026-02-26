# Art Direction and Visual Identity

---

## Color Direction and Mood Board

### Color Philosophy
Rich dark base tones — deep blue, purple, and green suggesting a cold corporate world.
Bright striking accents — orange, pink, and yellow representing energy, combat, and chaos
cutting through the darkness.

The world is dark and controlled. The player is the bright disruptive element.

- **Dark blues and purples** — the world, the corporation, the architecture, the shadows
- **Greens and teals** — technology, nano effects, terminal screens, the chip interface
- **Orange, pink, and yellow** — combat energy, nano bursts, chaos in a cold environment

### Tone
Cyberpunk ninja with genuine thematic weight — not aesthetic only. The themes of dependency,
augmentation, corporate power, and media narrative are present in the mechanics and the
story simultaneously.

---

## Technical Art References

### Primary Screenshot and Reference Databases
Resources for building a technical art reference collection. Intended for studying
perspective, scale, sprite structure, and visual language — not for style or creative direction.

**MobyGames** (mobygames.com) — the most comprehensive screenshot database available.
Search any game, filter by platform, download high quality screenshots. Free to browse.

**Giant Bomb** (giantbomb.com) — excellent screenshot library with good platform and genre filtering.

**GameFAQs** (gamefaqs.gamespot.com) — user submitted screenshots spanning early console
generations through modern releases.

**The Spriters Resource** (spriters-resource.com) — the primary resource for sprite sheet
research. Contains extracted sprite sheets from almost every game ever made, organised by
platform and game. Shows exactly how sprite sheets are structured across different eras and
how directional animation sets are organised. Bookmark immediately.

---

## Games by Era — Technical Study Reference

A reference list for studying oblique perspective, character to environment scale, 2D action
game visual language, and sprite structure. Intended as a technical study collection.

### NES
- **The Legend of Zelda** — foundational oblique perspective in action games, character to
  environment scale, readable tile based world
- **Contra** — character scale and readability in dense environments
- **Ikari Warriors** — early oblique perspective twin stick style layout

### SNES
- **The Legend of Zelda: A Link to the Past** — the gold standard oblique perspective
  reference for this era. Study the angle, the tile structure, the character to environment
  scale, and how height is communicated through sprite layering
- **Secret of Mana** — oblique perspective with detailed environmental objects and strong
  foreground and background separation
- **Final Fight** — character scale and readability during dense combat

### PlayStation / N64 Era
- **Diablo** — oblique perspective at higher resolution, atmospheric lighting in 2D space,
  how darkness and light create depth
- **Baldur's Gate Dark Alliance** — character scale in a detailed oblique environment

### Modern Pixel Art
- **Hades** — study the perspective angle, character to environment scale, and how detailed
  sprite work reads during fast combat
- **Dead Cells** — character readability during fast movement and combat, how effects and
  particles read against detailed backgrounds
- **Enter the Gungeon** — oblique perspective in a tight environment, character and enemy
  scale, how bullet patterns read visually
- **Hotline Miami** — extreme camera distance, very small character scale, how readability
  is maintained at low sprite resolution

### Notes on Study Method
When studying these references look specifically at:
- The implied camera angle — how steep is the perspective?
- What faces of objects are visible — top only, or top and front?
- Character size relative to tiles and environment objects
- How height is communicated through sprite overlap and layering
- How foreground elements render over characters
- How lighting and shadow suggest depth in a flat image

---

## Visual Scale Design

### Reference Scale
- Character occupies approximately 3-4% of screen height
- Environment objects are 2-6 times the character's size
- Tile size target: 64x64 pixels
- Character sprite target: approximately 32x48 pixels
- Collision shape: approximately 60-70% of sprite size for nimble feel
- Camera2D zoom: approximately 0.5 to 0.7 for reference scale feel

The player reads as nimble and precise against massive industrial surroundings. A lone ninja
dwarfed by corporate architecture built at machine scale, not human scale.

### David vs Goliath Philosophy
Scale is a visual concept used deliberately throughout the game. The size relationship between
the player and the world is a storytelling tool — the small character against vast spaces,
enormous enemies, and imposing architecture communicates the narrative without words.

---

## Dynamic Camera System

**Combat effectiveness thresholds** — the camera punches in when the player crosses a combo
or skill threshold. The zoom makes combat feel intimate and intense precisely when the player
is excelling. The game acknowledges exceptional play with a cinematic response.

The camera punching in simultaneously adjusts the `motion_scale` of foreground layers to
amplify the parallax depth effect and shifts the `motion_offset` of background layers for
additional drama.

**Vast spaces** — the camera zooms way out in large open environments to emphasize vastness.
Emerging from a tight corridor into a massive corporate atrium pulls the camera back to reveal
full scale.

**Boss and large enemy reveals** — camera pulls back on first encounter with large enemies,
emphasizing their scale relative to the player.

**Claustrophobic tight spaces** — tight corridors push the camera in, increasing tension.

**Story beat camera work** — opening sequence, surgical lab awakening, and ending cutscenes
use keyframed Camera2D zoom and position via AnimationPlayer for precise authored cinematic moments.

**Zoom range:** approximately 0.3 (vast reveal) to 1.0 (tight combat punch in)

---

## Cavalier Oblique Projection

### What It Is
Cavalier oblique is a drawing projection where the front face of an object is drawn true to scale with no distortion, and the receding depth axis is drawn at a consistent angle also at true scale with no foreshortening. The word cavalier means the depth axis is drawn at full scale — distinguishing it from cabinet oblique which draws depth at half scale.

### Why Pixel Art Uses It
Cavalier oblique keeps all lines either perfectly horizontal, perfectly vertical, or at a consistent diagonal. No converging perspective lines. No foreshortening. No lines at awkward angles that don't sit cleanly on a pixel grid.

In pixel art every line is made of individual pixels. Lines must follow clean ratios — 1:1, 2:1, 1:2 — to produce smooth consistent diagonals. Cavalier oblique naturally produces lines at these clean ratios. The floor plane typically uses 2:1 — two pixels across for every one pixel up on the receding axis.

### How It Differs From Isometric
Isometric uses a strict mathematical relationship — all three axes equal length, separated by 120 degrees. Everything must align to the grid. Walls go at 30 degrees. The grid governs everything.

Cavalier oblique has no such constraint. Walls are perfectly vertical. Characters face the camera directly. The floor recedes at whatever angle is chosen. This freedom is what Hades exploits — depth feeling of isometric without being locked to the isometric grid.

### The Angle Choice
The receding axis angle is the primary decision. Common choices:

```
30 degrees     →  shallower recession, more floor plane, wider and open
45 degrees     →  classic cavalier, balanced, Zelda SNES angle
55-60 degrees  →  Hades-adjacent, more front face, taller characters
```

For a dash-heavy movement game with vertical storytelling and tall character silhouettes, 55-60 degrees is the recommended starting range. Experiment and lock before any art is produced.

### The Drop Shadow Convention
Objects in cavalier oblique can appear to float above the floor plane. The fix is a soft blob shadow placed directly beneath every object, perpendicular to the floor plane — not a cast shadow at an angle, but a grounding shadow that tells the eye where the object's base meets the floor. Hades uses this on all characters. Lock this as a production convention applied to every sprite.

---

## Art Pipeline — Cinema 4D to Pixel Art

### Overview
The player is a 3D artist comfortable in Cinema 4D. This is a significant workflow advantage. The 3D-to-pixel-art pipeline solves the hardest problems in pixel art production — volume, foreshortening, lighting consistency, proportion accuracy across animation frames — and delivers a correct foundation for the pixel art layer to build on.

This is the same approach Supergiant used for Hades characters: 3D models rendered at the game's camera angle, hand-painted line work applied over the render.

### The Core Pipeline

```
Cinema 4D                         Aseprite
──────────────────────────────────────────────────────
Model asset                  →    Trace or paint over render
Rig and pose (characters)    →    Add pixel art line work
Set locked camera angle      →    Apply palette restriction
Render diffuse pass          →    Clean up and refine
Render normal map pass       →    Final sprite / normal map
Export sprite sheet          →    Import to Godot
```

### The Master Camera Rig
Built once, inherited by every subsequent asset scene. Contains:
- Orthographic camera — not perspective. Perspective produces converging lines that fight the cavalier oblique convention. Orthographic renders at true scale with no depth distortion.
- Camera positioned at locked cavalier oblique angle
- Ground plane reference
- Stand-in cube to verify projection at pixel scale
- Directional light at game's locked light angle — upper left conventional for pixel art

Save as `master_camera_rig.c4d`. Never modify after locking. Every character, enemy, prop, and tile scene opens with this camera rig as its foundation.

### Dual Render Pass Pipeline
Each asset produces two renders from the same scene:

**Diffuse pass** — flat ambient lighting, no directional shadows. Gives the cleanest form base to paint over. Pure shape information.

**Normal map pass** — Cinema 4D renders surface normals directly from the geometry. Imported into Godot as the normal map texture. Drives PointLight2D response in the game engine.

The same model that produces the sprite also produces its normal map. No hand-painting normals. Physically grounded lighting response in Godot because it came from real surface geometry.

### Character Pipeline
1. Build character model in Cinema 4D
2. Rig with standard joints
3. Pose each animation keyframe — idle, dash, attack, land, etc.
4. Rotate character to each of the eight directions
5. Render every combination from the locked camera
6. Result: complete reference sheet for every frame from every angle, correctly foreshortened, correctly proportioned, consistently lit
7. Pixel art work in Aseprite traces this foundation — style and surface decoration rather than solving perspective from scratch

### Cinema 4D Specific Notes
- Physical or Arnold renderer for clean orthographic renders
- Procedural modelling tools suited for arcology architecture
- MoGraph useful for repeated structural elements — pipes, conduits, panel arrays
- Standard joint rigs sufficient for character animation poses

---

## Character Pixel Height

### Reference — Children of Morta
Characters in Children of Morta sit at approximately 32-40 pixels tall at game resolution. This is a common and well-tested height for action games at the cavalier oblique angle. It communicates body posture, weapon position, and movement direction clearly while keeping characters small relative to the environment.

### The Case for 48 Pixels
Children of Morta's characters work at 32-40px because the combat is relatively slow and deliberate. This game is faster and more gesture expressive. A ninja performing quarter-circle attacks with visible weapon trails and nano effects may benefit from slightly more detail budget.

48 pixels tall:
- More detail budget for armour, weapons, and nano effects
- Attack animations more readable at higher speed
- Weapon trails and effects have more pixels to work with
- Silhouette remains small against environment — smallness feeling preserved

### The Zoom System Interaction
Character pixel height and the camera zoom range from Phase 0.5 work together. A 32px character at 1.4x zoom reads similarly to a 44px character at 1.0x zoom. Establish zoom range before locking pixel height — they are interdependent decisions.

### Pixel Budget at 48 Pixels
```
Head       →  8-10 pixels
Torso      →  16-18 pixels
Legs       →  14-16 pixels
```
Enough resolution for readable armour panels, a distinct weapon silhouette, nano effect overlays, and directional clarity across eight sprite directions.

### Cinema 4D Render Scale at 48 Pixels
- At 10x render scale: 480px tall render
- At 8x render scale: 384px tall render

Either is workable in Aseprite. 10x recommended for maximum paint detail that reduces cleanly.

### Decision Process — How to Lock Pixel Height
1. Complete Phase 0.5 camera rig and zoom range experiments first
2. Place stand-in sprites at candidate heights — 32px, 40px, 48px
3. Test at all zoom levels in the zoom range
4. Test at maximum negative space — character against large empty environment
5. Test at minimum zoom — does the character read clearly at closest camera distance?
6. Lock the value that best serves both smallness feeling and combat readability simultaneously
7. Document in `docs/visual_bible.md` — this value cannot change after art production begins

### What Locks With This Decision
- Cinema 4D render scale multiplier
- Sprite sheet dimensions
- Hitbox and hurtbox sizes relative to sprite
- Environment tile scale relationship
- All enemy character heights relative to player
- UI element scale relationship to characters
