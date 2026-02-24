# Design Pillars and Creative Intent

This document captures the core values, priorities, and creative intentions
behind the game as expressed during development. It serves as a reference
point when making decisions — if something doesn't serve these pillars,
question whether it belongs.

---

## Contents

- [Visual and Aesthetic](#visual-and-aesthetic)
- [Feel and Game Design](#feel-and-game-design)
- [Combat](#combat)
- [Narrative and Tone](#narrative-and-tone)
- [Player Experience](#player-experience)
- [Visual Language — Perspective and Presentation](#visual-language--perspective-and-presentation)
- [Visual Language — Verticality](#visual-language--verticality)
- [Boss Design](#boss-design)
- [Development Philosophy](#development-philosophy)

---

## Visual and Aesthetic

**Scale and depth** — a sense of physical dimensionality must be present
throughout the game even though it is 2D. Parallax layers, dynamic camera
work, foreground elements, and the scale relationship between the player
and the environment all serve this goal. This is not a flat game.

**David vs Goliath scale relationships** — the player is deliberately small
against a world built at machine and corporate scale. This is a visual
and narrative statement that runs throughout every environment.

**A unique and distinctive visual identity** — not generic, not assembled
from recognisable parts. The visual language is deeply considered and defined
early to prevent costly rework. Time spent on visual experimentation at the
start of development is an investment.

**Color direction** — rich dark blues, greens, and purples as the base world
tones. Striking orange, pink, and yellow as accent and energy colors.
The world is dark and controlled. The player is the bright disruptive element.

**Visuals and mechanics reinforce each other** — effects communicate systems.
The way nano spreads should look like it is spreading. The way a matter
projection destabilises should look unstable. Shader work is not decoration,
it is information.

**Combat that looks rewarding to excel at** — visual chaos as a skill
indicator. Persistent glowing particles accumulate during skilled play.
The room tells the story of the fight. A player who excels leaves a
visually spectacular environment behind them.

**Layering and depth as an ongoing consideration** — as the visual language
develops, scale and parallax depth should remain a constant lens. The camera,
the layer stack, the scale of enemies and environments — all of these are
active tools, not passive settings.

---

## Feel and Game Design

**Games are a power fantasy** — if the player puts in the work they should
be able to absolutely wreck rooms. This is not negotiable. The game rewards
mastery with spectacle.

**Earned power is more satisfying than given power** — the system rewards
skill and dedication. Power handed to the player for free is worth less than
power that was fought for.

**Small but meaningful choices** — not minor percentage increases. Every
choice should feel like it matters and changes how the game is played.

**Players should never feel locked in** — upgrade points are refundable,
hard mode is accessible to everyone, and no choice should feel like a
permanent mistake. Freedom to experiment is essential.

**The barrier to challenge is commitment, not gatekeeping** — everyone can
attempt hard mode. Few will finish it. The challenge is real but the door
is always open.

**Upgrades change behaviour and mindset, not just numbers** — the best
upgrades transform how the player thinks about the game, not just how
much damage they deal.

---

## Combat

**Physical and gestural input philosophy** — inspired by the Skate series.
Actions feel embodied. The input and the outcome feel connected.

**A combat loop with rhythm** — approach, strike, reward window, relaunch.
The loop is both offensive and defensive. Sustaining it keeps you safe.
Breaking it exposes you to danger.

**Parrying as skilled defense that feeds offense** — the parry is not a
panic button. It is a deliberate skill expression that feeds the nano
system and provides the hard mode lifeline.

**Nano contagion as battlefield control** — the nano system should feel
like hacking. Patient, systemic, spreading. The player influences the
environment rather than just damaging individual targets.

**Clone enemies as mirrors** — they adapt to your habits, counter your
tendencies, and turn your own skill against you. Fighting them is a
fundamentally different problem than fighting human enemies.

**Gestural execution is an expression surface, not a barrier** — moves
should be easy to execute. It should be pretty hard to fail. The gestural
combat system is available to every player regardless of skill level.
Failure is not punished. Degrees of success are rewarded. The floor is
generous. The ceiling is expressive.

The emotional target: a new player watching an expert should think —
"I can do that, but not like that. Not yet."

---

## Narrative and Tone

**Cyberpunk ninja with genuine thematic weight** — not aesthetic only.
The themes of dependency, augmentation, corporate power, and media
narrative are present in the mechanics and the story simultaneously.

**The normal ending as commentary** — doing the right thing is not always
recognised. The media frames your victory as villainy. You saved the day
and are exiled for it. This is a statement about power and narrative control.

**The triumphant ending must be earned** — it is not found by accident.
It requires the player to give something real. That cost is what makes
the payoff meaningful.

**The chip implant raises questions** — the most capable version of the
player never needed it. Dependency and augmentation are not presented as
purely positive. The narrative and mechanical design are aligned on this.

**Environmental storytelling through discovered objects** — characters are
revealed through notes, emails, photographs, and activated objects rather
than cutscenes. The world has a life that exists independently of the
player's presence in it.

**In sections without combat, visual presentation carries the design** —
non-combat areas are not empty space between fights. They are
opportunities for cinematic visual storytelling. The design focus shifts
from mechanical engagement to visual and atmospheric engagement.

Transition areas should visually connect the spaces they join while
remaining distinct from both. A door leading from a maintenance tunnel
to a laboratory looks like it belongs to the maintenance tunnel on one
side and the laboratory on the other. The visual language of each space
bleeds into its transitions — the player reads where they are going
before they arrive.

Example: the red light on the hidden camera in the opening transition.
The light is a consistent visual element across transitions but its
housing, context, and framing changes to reflect the space it occupies.
In the maintenance tunnel it is industrial and exposed. In the lab it
is recessed and clinical. Same element, distinct expression.

Each district of the arcology has a tone mapping signature — a distinct
color treatment that shifts as the player arrives. The labs are cooler
and clinical. The maintenance tunnels are warmer and amber. The executive
offices are high contrast and desaturated. The player reads the building's
personality through color before they understand it through story.

---

## Player Experience

**Accessibility is a priority** — colorblindness support with a user
definable color wheel and presets. No player should be excluded by a
visual design decision.

**The endless mode is where the full power fantasy lives** — fully upgraded,
procedurally varied, visually spectacular. This is the reward for mastery.

**Challenge tiers are layered and meaningful** — each tier asks something
real from the player. The hidden tier asks everything. None of them are
gated by obscurity — only by commitment and skill.

**The promotional idle game as a discoverable entry point** — the full
combat system remains exclusive to the main game. The idle game creates
awareness and curiosity without giving everything away.

---

## Visual Language — Perspective and Presentation

### Perspective Definition
This game uses an oblique three quarter view perspective —
not top down, not isometric, not side scrolling. The camera
is positioned high and angled, revealing both the top face
and front face of objects simultaneously. Height and volume
are readable. Characters show body language and silhouette,
not just head and shoulders.

Technical definition: high angle oblique projection,
approximately 45 degrees from vertical, parallel projection
with no vanishing point or perspective distortion.

### The Consistency Rule
Every visual element in the game must be drawn from the same
implied camera angle without exception. Mixing perspectives
— even subtly — destroys spatial coherence. This is a
technical discipline as much as an artistic one. When in
doubt, return to the reference image and match the angle.

### What This Perspective Achieves
- Height and scale are readable — tall objects read as tall
- Characters have body language and presence, not just silhouette
- The floor plane is visible, creating a readable battlefield
- Natural depth without vanishing points or perspective distortion
- The David vs Goliath scale relationship is communicated through
  visible height difference between player and environment

### Depth Through Layering
The oblique perspective creates inherent spatial depth that the
canvas layer and parallax system then amplifies. Objects further
from the viewer sit higher on screen — this is the fundamental
visual language of the perspective and every system that touches
depth should reinforce it rather than contradict it.

### Sprite Direction Budget
The oblique perspective requires multiple directional sprites
per character. Minimum viable: four cardinal directions.
Target: eight directions including diagonals for the player
character. Enemies may use four directions to manage art budget.
This must be decided before art production begins — changing
it mid-production is extremely costly.

### The Reference Image
The reference screenshot analyzed during development is stored
in the mood board. When perspective questions arise during art
production, return to this reference first.

---

## Visual Language — Verticality

### The Challenge
The oblique three quarter camera angle chosen for this game prioritises
combat readability and battlefield clarity — the right decision for a
fast action game. The tradeoff is that the steep downward angle naturally
flattens vertical space. A camera looking steeply down sees floors and
horizontal surfaces clearly but loses the dramatic sense of height that
a lower, more cinematic angle would provide. Objects that are tall look
similar to objects that are short. The world risks feeling flat despite
the parallax and depth systems working to counter that.

This is a genuine design challenge that must be solved through art
direction rather than camera adjustment.

### Why Verticality Matters to This Game
Vertical scale is not a purely aesthetic concern in this game — it is
thematically essential. The game is about power and corruption. Corporate
architecture is designed to intimidate, to make individuals feel small
and insignificant against institutions that dwarf them. The buildings
are not just settings — they are expressions of the power the player
is moving against. Height communicates dominance. Scale communicates
authority. A corporation that fills the sky with its geometry is one
that believes it owns the sky.

The player ascends a futuristic corporate tower. This is the central
physical journey of the game — moving upward through layers of increasing
power and security, from the sewers beneath the building to its highest
reaches. Every floor ascended is a statement of defiance. The verticality
of the tower is the spine of the entire narrative. If the player does
not feel the tower's scale — if they do not feel genuinely small against
it — the journey loses its meaning.

The camera angle cannot show this directly. The art must sell it instead.

### Tools for Implying Vertical Scale

**Negative space** — the most powerful tool available. A character
standing at the base of a structure that extends beyond the top of the
screen communicates enormous height without the camera tilting at all.
The player's imagination fills in what is not shown and almost always
exaggerates upward. Design architectural elements to deliberately exceed
the frame. Let the building refuse to fit.

**Cropping** — a deliberate extension of negative space. Tall structures,
pipes, columns, and walls that bleed off the top edge of the screen. The
crop is the message. What cannot be contained implies what cannot be
measured.

**Foreground CanvasLayer elements** — pipes, girders, structural beams,
and architectural details placed in the foreground layer above the
character. They do not need to connect to visible structures below —
their presence above implies a structure extending upward out of frame.
The foreground elements are the bottom of something enormous.

**Shadow** — a shadow cast downward onto the floor plane from a light
source above implies a massive structure overhead without showing it.
The shadow does the storytelling. A vast angular shadow falling across
the player from something the camera cannot see is one of the most
efficient ways to communicate scale in this perspective.

**Parallax background layers** — background architectural detail that
scrolls slowly as the player moves horizontally carries vertical
information. A wall of corporate brutalist geometry in the background
layer that extends from floor to the top of the screen and beyond
implies height that the gameplay layer cannot show. The background
is doing vertical work the camera cannot.

**Sound design** — footsteps that echo in vast vertical space, ambient
machinery sounds from above, the acoustic difference between a low
corridor and an atrium that extends upward out of sight. Not visual
but contributes powerfully to the perception of scale. The ear fills
in what the eye cannot see.

**Lighting from above** — light sources positioned above the camera
frame cast light and shadow downward onto the scene. A shaft of light
descending from off screen implies a source above. Industrial lighting
rigs that are visible only by their light output and their shadows
sell the presence of overhead structure without showing it.

**Ascent as felt progression** — as the player moves upward through
the tower, the visual language of each floor should communicate
increasing altitude. Wider corridors that imply greater structural
scale. More ambitious architecture. Longer sight lines through windows
or gaps that show the city far below. The player should feel themselves
getting higher even when the camera angle cannot show it directly.

### The Design Instruction
When designing any environment in this game ask: does this space feel
tall? Not does it look tall — does it feel tall. The camera will not
show the ceiling. The art must make the player believe the ceiling
exists and that it is very far above them.

---

## Boss Design

**Boss encounters should change phase to phase** — each phase must feel
distinct from the previous one while adhering to a specific mechanical
identity that defines that boss. Phases are not just health thresholds —
they are distinct gameplay experiences united by a consistent thematic
mechanic.

**Every boss has a specific mechanic** — one core mechanical identity
that runs through every phase of the encounter. The player always knows
what they are doing and why. The mechanic changes in expression, not
in nature.

**The Spider Tank as the model:**
The specific mechanic is legs. Legs are the main obstacle throughout
the entire encounter. Attack patterns, movement speed, and aggression
change based on how many legs remain — but legs are always the focus.

Each phase asks a different question using the same mechanical language:
- Phase 1 — can you navigate a fast moving threat and identify targets?
- Phase 2 — can you adapt to unpredictable asymmetric movement?
- Phase 3 — can you deal with a stationary but heavily armed threat?
- Phase 4 — can you finish a vulnerable target before it recovers?

**Apply to all boss encounters:**

*CEO final boss* — the specific mechanic is exposure. Each phase strips
away a layer of corporate protection. Vulnerability increases as defenses
are removed. The player is always working toward the same goal — getting
to the man beneath the machine.

*Hard mode mech* — the specific mechanic is consequence. Phases are tied
to the gauntlet challenges the player completed. The player's own
excellence armed the enemy. Each phase is a reflection of a choice
the player made earlier in the run.

*Secret boss* — mechanic to be defined. Must have a consistent mechanical
identity across all phases.

---

## Development Philosophy

**Learn the skills while building the game** — AI tools are tutors, not
just code generators. Understanding why code works matters as much as
having working code.

**Hand crafted story, procedural replayability** — know which tool serves
which goal. Narrative moments are authored. Replayability is systemic.

**Visual identity defined early** — strong visual decisions made at the
start prevent expensive rework later. The mood board, the shader
experimentation, and the color direction are not optional preliminaries —
they are foundational work.

**Branch to experiment, merge what works** — no idea is too risky to try
when it lives on its own branch. Main is always stable.
