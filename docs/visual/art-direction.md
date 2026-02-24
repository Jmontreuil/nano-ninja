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
