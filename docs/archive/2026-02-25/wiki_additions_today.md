
# Wiki Additions — Session February 25 2026

---

## Art Direction — Cavalier Oblique Projection

### What It Is
Cavalier oblique is a drawing projection where the front face of an
object is drawn true to scale with no distortion, and the receding
depth axis is drawn at a consistent angle also at true scale with no
foreshortening. The word cavalier means the depth axis is drawn at
full scale — distinguishing it from cabinet oblique which draws depth
at half scale.

### Why Pixel Art Uses It
Cavalier oblique keeps all lines either perfectly horizontal, perfectly
vertical, or at a consistent diagonal. No converging perspective lines.
No foreshortening. No lines at awkward angles that don't sit cleanly
on a pixel grid.

In pixel art every line is made of individual pixels. Lines must follow
clean ratios — 1:1, 2:1, 1:2 — to produce smooth consistent diagonals.
Cavalier oblique naturally produces lines at these clean ratios. The
floor plane typically uses 2:1 — two pixels across for every one pixel
up on the receding axis.

### How It Differs From Isometric
Isometric uses a strict mathematical relationship — all three axes equal
length, separated by 120 degrees. Everything must align to the grid.
Walls go at 30 degrees. The grid governs everything.

Cavalier oblique has no such constraint. Walls are perfectly vertical.
Characters face the camera directly. The floor recedes at whatever angle
is chosen. This freedom is what Hades exploits — depth feeling of
isometric without being locked to the isometric grid.

### The Angle Choice
The receding axis angle is the primary decision. Common choices:

```
30 degrees  →  shallower recession, more floor plane, wider and open
45 degrees  →  classic cavalier, balanced, Zelda SNES angle
55-60 degrees  →  Hades-adjacent, more front face, taller characters
```

For a dash-heavy movement game with vertical storytelling and tall
character silhouettes, 55-60 degrees is the recommended starting range.
Experiment and lock before any art is produced.

### The Distortion Problem and Convention
Cavalier oblique draws depth at true scale — physically incorrect since
distant objects appear smaller in reality. This produces a slight
floating quality. Pixel art solves this through convention — players
accept the projection because decades of games have trained them to read
it. The distortion becomes invisible when applied consistently.

Inconsistent application — some elements following cavalier rules, others
not — is immediately visible and breaks the world's coherence. The angle
must be locked and applied to every asset without exception.

### The Drop Shadow Convention
Objects in cavalier oblique can appear to float above the floor plane.
The fix is a soft blob shadow placed directly beneath every object,
perpendicular to the floor plane — not a cast shadow at an angle, but
a grounding shadow that tells the eye where the object's base meets
the floor. Hades uses this on all characters. Lock this as a production
convention applied to every sprite.

---

## Art Pipeline — Cinema 4D to Pixel Art

### Overview
The player is a 3D artist comfortable in Cinema 4D. This is a
significant workflow advantage. The 3D-to-pixel-art pipeline solves
the hardest problems in pixel art production — volume, foreshortening,
lighting consistency, proportion accuracy across animation frames —
and delivers a correct foundation for the pixel art layer to build on.

This is the same approach Supergiant used for Hades characters: 3D
models rendered at the game's camera angle, hand-painted line work
applied over the render.

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
The most important Cinema 4D scene. Built once, inherited by every
subsequent asset scene. Contains:

- Orthographic camera — not perspective. Perspective produces
  converging lines that fight the cavalier oblique convention.
  Orthographic renders at true scale with no depth distortion.
- Camera positioned at locked cavalier oblique angle
- Ground plane reference
- Stand-in cube to verify projection at pixel scale
- Directional light at game's locked light angle — upper left
  conventional for pixel art

Save as `master_camera_rig.c4d`. Never modify after locking.
Every character, enemy, prop, and tile scene opens with this
camera rig as its foundation.

### Render Resolution
Decide sprite pixel dimensions first — how many pixels tall is the
player character at game resolution. Render at a multiple of that size.

Recommended: render height = game pixel height × 10

A 32px tall game sprite renders at 320px. Provides a large clean
base to paint over that reduces correctly to target pixel size.

### Dual Render Pass Pipeline
Each asset produces two renders from the same scene:

**Diffuse pass** — flat ambient lighting, no directional shadows.
Gives the cleanest form base to paint over. Pure shape information.

**Normal map pass** — Cinema 4D renders surface normals directly
from the geometry. Imported into Godot as the normal map texture.
Drives PointLight2D response in the game engine.

The same model that produces the sprite also produces its normal map.
No hand-painting normals. Physically grounded lighting response in
Godot because it came from real surface geometry.

### Character Pipeline
For the player character with eight directional sprites across multiple
animation states:

1. Build character model in Cinema 4D
2. Rig with standard joints
3. Pose each animation keyframe — idle, dash, attack, land, etc.
4. Rotate character to each of the eight directions
5. Render every combination from the locked camera
6. Result: complete reference sheet for every frame from every angle,
   correctly foreshortened, correctly proportioned, consistently lit
7. Pixel art work in Aseprite traces this foundation — style and
   surface decoration rather than solving perspective from scratch

Production speed difference versus pure 2D is substantial.

### Environment Pipeline
1. Build architectural geometry in Cinema 4D — walls, floors, pipes,
   structural elements
2. Set the locked camera
3. Render the scene
4. Use render as foundation for pixel art tiles or painted backgrounds
5. All tiles share the same projection — consistency from the pipeline
   rather than from discipline

For modular tilesets: build one tile in 3D, render at game pixel scale,
use as pixel art foundation. Every tile in the set shares the same
projection automatically.

### Consistent Lighting Across All Assets
Set up the directional light in Cinema 4D once. Every asset rendered
under the same light has consistent shadow direction and intensity.
The game reads as a unified world because every sprite was lit by the
same virtual light source. Lock the light angle in the visual bible.

### Cinema 4D Specific Notes
- Physical or Arnold renderer for clean orthographic renders
- Procedural modelling tools suited for arcology architecture
- MoGraph useful for repeated structural elements — pipes, conduits,
  panel arrays
- Standard joint rigs sufficient for character animation poses
- No complex simulation or dynamics required

---

## Art Pipeline — Normal Maps at Cavalier Oblique Angle

### The Fundamental Tension
Normal maps are designed around the assumption that the viewer is looking
at a surface more or less face-on. The normal map encodes surface detail
— bumps, grooves, panel lines — that react to light as if those details
have real depth. At a flat frontal angle this works beautifully. At a
steep overhead angle the relationship between encoded normals and the
viewer's perspective starts to break down.

At 55-60 degrees the front face of characters and environments is still
partially facing the viewer — normal maps will work there. The top face
is nearly perpendicular to the camera. Light hitting the top face from
the side will produce correct responses. Light hitting it from above
will produce very little response because the surface is already facing
the light source directly.

---

### What Will Work Well
**Front-facing surfaces** — character torsos, wall faces, door panels,
anything with a front face toward the camera — will respond to normal
maps exactly as expected. Panel lines on armour, surface texture on
walls, carved detail on architecture will all catch light dynamically
as PointLight2D nodes move.

This is where normal maps matter most for this game. The character's
front face is the primary read surface. Normal map detail there —
armour plating, nano circuitry patterns, fabric folds — will look
compelling under dynamic lighting.

---

### What Will Be Subtle or Invisible
**Top faces of objects** — floors, tops of crates, horizontal surfaces
— will show minimal normal map response at this camera angle. The
normals are pointing almost directly at the camera, which means they
are pointing almost directly away from most lateral light sources.
Dynamic lighting on floor surfaces will be driven more by diffuse
texture and light color than by normal map detail.

This is acceptable — floor surfaces are read as floor, not as detailed
surfaces. The visual interest lives on vertical surfaces and characters,
which is exactly where normal maps perform best at this angle.

---

### The Unknown — Floor Transitions and Zoom
How normal maps perform during floor transitions is genuinely
unpredictable until tested. As camera zoom changes the player's apparent
relationship to light sources shifts. Normal map response will shift
dynamically as that happens.

This could be spectacular — surface detail catching light differently
at different zoom levels, reinforcing the sense of moving through space.
Or it could produce inconsistent results that need tuning. Unknown until
real assets are in Godot with real lights.

---

### The Phase 0.5 Normal Map Test
Before committing to the full normal map pipeline for every asset, run
one focused test during Phase 0.5:

- [ ] Render a simple character stand-in from Cinema 4D at locked angle
- [ ] Generate its normal map from the same scene
- [ ] Import diffuse sprite and normal map into Godot
- [ ] Place a PointLight2D at several positions around the sprite
- [ ] Move the light in real time — watch how the surface responds
- [ ] Test at multiple zoom levels to observe behaviour during
      the kind of transition the floor system will produce
- [ ] Document findings in `docs/visual_bible.md`

This single test will reveal more about actual normal map performance
at this angle than any amount of theoretical analysis. Run it before
normal maps are used on any production asset.

---

### Summary — Where to Invest Normal Map Detail
Based on the angle analysis:

**High value — invest detail here:**
- Character front faces — torso, arms, visible armour panels
- Wall faces — architectural detail, panel lines, surface texture
- Door and transition surfaces — visible front face geometry
- Enemy front faces — readable at combat distance

**Low value — minimal detail needed:**
- Floor surfaces — top face, minimal light response
- Tops of crates and props — top face, minimal light response
- Ceiling geometry — rarely visible, not worth detailed normals

**Unknown until tested:**
- Character top surfaces during steep zoom
- Floor transition response during zoom tween
- Foreground element response close to camera

---

## Art Direction — Character Pixel Height

### Reference — Children of Morta
Characters in Children of Morta sit at approximately 32-40 pixels tall
at game resolution. This is a common and well-tested height for action
games at the cavalier oblique angle. It communicates body posture,
weapon position, and movement direction clearly while keeping characters
small relative to the environment.

### Why This Height Works at This Angle
At 32-40 pixels tall a character has enough vertical resolution to
communicate the things that matter for combat readability:
- Silhouette reads as a person with a weapon
- Direction of facing is clear
- Attack animations read correctly
- Dash movement and direction is readable

What this height cannot show: fine facial detail, intricate costume
decoration, subtle body language. At this size those things are implied
rather than rendered. Every pixel is doing visible work.

### The Environment Scale Relationship
At this character height the environment reads as larger than the
character — floor tiles, wall sections, and architectural elements are
significantly larger. This is intentional and directly serves the design:

- David vs Goliath scale pillar — the player feels small against
  corporate and machine scale architecture
- Negative space levels — the player dwarfed by the arcology's vastness
- The building feels like it owns the space — the player navigates
  through it rather than dominating it

A larger character — 64 pixels tall — would feel like the world is
built around them. A smaller character feels like they are inside
something much bigger.

### The Case for 48 Pixels
Children of Morta's characters work at 32-40px because the combat is
relatively slow and deliberate. This game is faster and more gesture
expressive. A ninja performing quarter-circle attacks with visible
weapon trails and nano effects may benefit from slightly more detail
budget.

48 pixels tall is a common middle ground:
- More detail budget for armour, weapons, and nano effects
- Attack animations more readable at higher speed
- Weapon trails and effects have more pixels to work with
- Silhouette remains small against environment — smallness feeling preserved

### The Zoom System Interaction
Character pixel height and the camera zoom range from Phase 0.5 work
together. The zoom system means the character appears larger when the
camera is closer — so base pixel height is not the only factor
determining how large the character reads.

A 32px character at 1.4x zoom reads similarly to a 44px character
at 1.0x zoom. The zoom range needs to be established before pixel
height is locked — they are interdependent decisions.

### Pixel Budget at 48 Pixels
At 48 pixels tall the character has roughly:
```
Head       →  8-10 pixels
Torso      →  16-18 pixels
Legs       →  14-16 pixels
```
Enough resolution for readable armour panels, a distinct weapon
silhouette, nano effect overlays, and directional clarity across
eight sprite directions.

### Cinema 4D Render Scale at 48 Pixels
At 10x render scale: 480px tall render
At 8x render scale: 384px tall render

Either is workable in Aseprite. 10x recommended for maximum paint
detail that reduces cleanly.

### Decision Process — How to Lock Pixel Height
1. Complete Phase 0.5 camera rig and zoom range experiments first
2. Place a stand-in sprite at candidate heights — 32px, 40px, 48px
3. Test at all zoom levels in the zoom range
4. Test at maximum negative space — character against large empty
   environment, does the smallness feeling hold?
5. Test at minimum zoom — does the character read clearly at the
   closest camera distance?
6. Lock the value that best serves both the smallness feeling and
   combat readability simultaneously
7. Document in `docs/visual_bible.md` — this value cannot change
   after art production begins

### What Locks With This Decision
Once pixel height is locked the following are also locked:
- Cinema 4D render scale multiplier
- Sprite sheet dimensions
- Hitbox and hurtbox sizes relative to sprite
- Environment tile scale relationship
- All enemy character heights relative to player
- UI element scale relationship to characters

Changing pixel height after art production begins means redrawing
every character sprite from scratch.

---

## Visual Information — Where It Lives

### Current State
Visual design information is distributed across several documents.
The full picture requires reading multiple sources:

**`docs/visual_bible.md`** ← primary visual reference, to be created
in Phase 0.5. Will contain all locked visual decisions:
- Pixel size constant
- Game palette with hex values
- Cavalier oblique angle
- Cinema 4D camera rig values and light angle
- Character pixel height
- Sprite render scale multiplier
- Shader animation framerate
- Camera zoom range per floor tier
- Player scale range per floor tier
- District tone mapping signatures
- CanvasLayer stack with motion_scale values
- Drop shadow convention
- Normal map pipeline values

**`docs/design_pillars.md`** — visual philosophy and intention.
Color direction, scale relationships, visual identity principles.
Not technical values — the why behind visual decisions.

**Wiki — Art Direction page** — reference analysis, camera angle
theory, cavalier oblique, Cinema 4D pipeline, character height
discussion, inspiration references.

**Wiki — Visual Systems page** — canvas layers, parallax, Z-index,
normal maps, tilemap depth, shader techniques.

**Wiki — Shaders page** — pixel art shader pipeline, fragment shader
fundamentals, noise techniques, floor transition shaders.

**`docs/inspiration.md`** — reference images and visual touchstones.

### The Gap
The visual bible does not exist yet. Until Phase 0.5 is complete
all visual decisions are provisional. The wiki pages capture the
theory and the options. The visual bible will capture the locked
values once experimentation confirms them.

### Recommendation
When visual questions arise during development, check in this order:
1. `visual_bible.md` — is this value already locked?
2. Design pillars — what principle governs this decision?
3. Wiki Art Direction or Visual Systems — what does the theory say?
4. If still unresolved — add to Phase 0.5 experiment list

---

## Enemies — Patrol Drone (First Enemy)

### Concept
The first enemy the player encounters. Simple, readable, non-threatening
alone. Teaches the dash interaction early at minimal cost.

---

### Visual Design
**Body:** Tall and narrow central column. Soft white plastic with thin
engraved detail lines. Reads cleanly against the dark arcology palette.

**Legs:** Four legs, tall and narrow. Crab-like stance and movement.
Sharp toes — the attack surface. At target pixel height legs will be
approximately 2-3 pixels wide — four legs keeps the silhouette readable
at small sizes.

**Face:** Dead center — a bright red circular lens surrounded by a
chrome circular bracket. Single focal point. The player's eye goes
immediately to the red lens, which is also where the danger communicates
from. Good design economy — the visual focal point and the threat read
from the same place.

**Color language:** Soft white and chrome against dark blues, greens,
and purples of the arcology. High contrast without being visually
complex. Reads clearly at combat distance.

---

### Movement
Crab-like lateral movement. The tall narrow body moves above the legs
without rotating — the legs do the directional work while the central
column stays upright. At the cavalier oblique camera angle the leg
movement will be very readable from above, the body will read as a
vertical column.

---

### Attack — Leg Jab
One leg facing the player lifts and jabs forward with the sharp toe.
The lifting leg breaks the crab movement pattern — a readable tell that
an attack is incoming.

**Damage:** Minimal. This enemy is an introduction, not a threat.

**Dash interaction:**
- Dashing into the jab during the active frames knocks the player back
  and cancels the dash
- Teaches early that dashing is not unconditionally safe
- Some attacks punish committed dashes — this is the first lesson

---

### Dash Punishment — Design Note
The patrol drone introduces the dash punishment mechanic at minimal
cost. The knockback is small, the damage is low, the lesson is gentle.

Harder enemies scale this interaction significantly:
- Larger enemies have attacks that deal more damage on a blocked dash
- The lesson taught cheaply by the patrol drone is paid off harshly
  by later enemies
- Players who learn to read attack tells early are rewarded later
- Players who dash carelessly are punished progressively harder

This is a difficulty curve that lives in the combat system rather than
in enemy health values. The player gets smarter or they get punished.

---

### Role in the Game
- First combat encounter — sets expectations for the combat system
- Teaches: dashing is not always safe, attacks have readable tells
- Low threat alone, moderate threat in groups
- Visually establishes the corporate security aesthetic — clean,
  manufactured, clinical. The arcology's maintenance drones repurposed
  or redeployed as security assets.

---

## Combat — Dash Anticipation and Charge State

### The Concept
The dash is not a press-to-go input. It is a draw-and-release. The
player pulls back on the stick, the character reads the intent and
holds tension, the dash fires on release. The anticipation is part
of the input.

This aligns with the gestural, embodied input philosophy and the Skate
reference — in Skate you load tricks through stick position before
executing. The anticipation is not a delay, it is a commitment.

**Input method:** Flick and release. No button. The stick motion is
the entire input — pull back to charge, release to fire.

---

### Mechanical Possibilities
Hold duration opens a design space:

**Brief hold** — acknowledges intent, plays anticipation animation,
fires standard dash on release. Visual read improves, mechanic unchanged.

**Longer hold** — builds charge, modifies the dash. Options include:
- More distance or speed
- More invulnerability frames
- More damage on the arrival strike
- More spectacular visual effect on execution

**Overcharge** — held too long. Either fires automatically or applies
a penalty. Overcommitment having a cost is interesting design.

These do not need to be decided now. The signal architecture must
accommodate them from the start.

---

### Signals — Updated Dash Signal Set

```gdscript
# Existing signals — unchanged
sig_dash_started(direction)
sig_dash_ended
sig_dash_ready
sig_invulnerability_started
sig_invulnerability_ended

# New — charge lifecycle
sig_dash_charge_started(direction)    # stick pulled back, charge begins
sig_dash_charge_building(charge_pct)  # emitted each frame, 0.0 to 1.0
sig_dash_charge_released(charge_pct)  # stick released, dash fires
sig_dash_charge_cancelled             # player released without committing
```

`sig_dash_charge_building` is the key signal — the charge percentage
it carries drives multiple systems simultaneously:
- Animation controller — scales anticipation effect as charge grows
- Combat system — determines dash properties on release
- Shader system — drives power buildup visual on character or weapon

`sig_dash_charge_started(direction)` carries direction — the
anticipation animation needs to know which way the character is about
to move. A character anticipating a rightward dash leans right.
Direction at charge start feeds into the approach vector system.

---

### Animation States — Updated Set

```
idle
dash_anticipation    ← plays when charge starts
dash_charge          ← loops while charge builds, scales with charge_pct
dash                 ← fires on release
dash_land            ← arrival
i_frame
attack
```

**dash_charge** is the visually interesting state. At low charge
percentage: subtle — slight crouch, lean into direction. At high
charge percentage: dramatic — energy gathering, character coiled.

The charge percentage can drive:
- How far through the animation plays
- A shader parameter on the character directly
- Both simultaneously

---

### Connection to Existing Systems
The charge percentage signal connects to systems already designed:

**Execution quality** — charge level at release contributes to
execution quality. A fully charged release produces more spectacular
effects than a quick flick. Skilled players learn to read when a full
charge is worth building.

**Nano system** — a fully charged dash arrival could apply nano on
contact, connecting movement and nano spread into one action.

**Persistent particles** — dash charge buildup could accumulate
particles around the character, releasing them on the dash itself.
Visual charge that becomes visual speed.

**Combat loop** — the anticipation state is the moment between
approach and strike. It is readable to enemies and to other players
watching. Skilled play looks different because the charge is visible.
