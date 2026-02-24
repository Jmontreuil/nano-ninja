# Wiki Additions — Session February 24 2026 (Part 2)

---

## Gestural Combat — Spectator Test

### Purpose
A recurring design validation check for any mechanic with a visible
skill expression. Apply this test during development whenever execution
quality feedback is added, tuned, or changed.

### The Test
Show a new player watching an expert play. Ask internally:

1. Can they see that the expert's moves look different — more spectacular,
   more dynamic — than a standard execution?
2. Can they simultaneously recognise that the expert is performing the
   same moves they themselves can perform?
3. Does the gap between the two read as skill rather than as access to
   a different system?

All three must be true for the execution feedback system to be working
correctly.

**If the spectator cannot tell the difference between low and high
execution quality** — the reward system is too subtle. Add visual weight.

**If the spectator believes the expert has access to different moves
or a different system** — the floor is too punishing or the feedback
gap is too wide. Bring the floor up or reduce the ceiling gap.

**The correct spectator response:** "I can do that, but not like that.
Not yet."

### Apply Beyond Gestural Combat
The spectator test applies to any system with a visible skill expression
— not just gesture recognition. Nano spread efficiency, combo threshold
camera responses, particle accumulation density — all of these should
pass the same test. The skilled version should look visibly different
from the competent version while remaining recognisably the same system.
Every successful gesture produces one of several quality tiers based on
how cleanly the input was executed. The move always fires. The quality
of the execution determines how the move looks and feels.

**Low execution quality:**
- Move completes successfully
- Weapon or attack effect is clean but unremarkable
- Standard animation plays
- Standard particle output
- Standard cooldown applies
- Audio is present but not exceptional

**High execution quality:**
- Move completes successfully
- Weapon or attack effect gains a stylized visual layer — the sword
  looks like it has weight, momentum, and energy behind it
- Animation plays with more visual dynamism
- Particle output is more dramatic — more density, more spread,
  more colour saturation
- Cooldown is shortened — tight execution makes the next move
  available sooner
- Audio has more impact, more satisfying

The difference between tiers is visible at a glance. A player watching
high level play can see that the moves look different — more spectacular,
more alive — while also recognising that the expert is performing the
same moves they can perform. The gap reads as skill, not as access to
a different system.

---

### Diegetic Feedback — No Floating Numbers
Execution quality feedback lives in the world, not in the UI. No damage
numbers, no grade letters, no screen-edge indicators, no pop-up alerts.

The weapon is the feedback surface. The character is the feedback surface.
The environment is the feedback surface.

**Weapon effects** — the primary feedback channel. A sword, a strike,
a nano-charged blow all gain or lose visual treatment based on execution
quality. Low execution: the effect exists but is subdued. High execution:
the effect is spectacular — stylized energy, trailing light, animated
impact geometry that reads as something genuinely powerful happening.

**Character animation** — high execution quality triggers a more dynamic
animation variant. The body reads the quality of the move. A perfectly
executed gesture produces movement that looks intentional and controlled.
A loose execution produces movement that still completes but reads as
less precise.

**Environmental response** — persistent particles, light response, nano
spread — all respond more dramatically to high execution quality. The
room accumulates evidence of skilled play. A player who excels leaves a
visually spectacular environment behind them.

**Audio** — hit sounds, impact effects, and weapon sounds have execution
quality variants. A clean hit sounds different from a perfect hit. The
ear reads execution quality as naturally as the eye does.

---

### Diegetic UI Consideration
Any UI component communicating execution quality must feel like it
belongs to the world rather than sitting on top of it.

Candidates:
- A charge indicator on the weapon itself — a visual state on the
  blade or weapon that fills or intensifies with execution quality,
  visible in the game world rather than a screen overlay
- The nano meter responding to execution quality — a world-space
  element that already exists, responding more dramatically to
  clean inputs
- Environmental light response — a brief intensification of nearby
  light sources on high execution, subtle enough to read as atmospheric
  rather than as a UI element

What to avoid:
- Floating damage numbers or grade letters
- Screen-edge glow or vignette for execution feedback
- Pop-up text of any kind
- Any element that reads as sitting outside the game world

---

### Cooldown as Execution Reward
Tight execution shortens the cooldown on the executed move. The player
who executes cleanly can chain moves faster than the player who executes
loosely — not because the game is harder for the loose player, but
because the skilled player has earned a faster rhythm.

This creates a natural incentive to improve without communicating
improvement through a score or a grade. The skilled player notices their
moves chain more fluidly. They feel faster. The feedback is kinetic and
immediate rather than numerical and abstract.

---

### The Spectator Test
The clearest design validation for this system: a new player watching an
expert play should be able to see that the expert's moves look different —
more spectacular, more dynamic — and simultaneously understand that the
expert is performing the same moves they themselves can perform.

That gap must read as skill, not as a different game.

If the spectator cannot tell the difference between low and high execution
quality the reward system is too subtle. If the spectator believes the
expert has access to different moves or a different system the floor is
too punishing. The correct response is: I can do that, but not like that.
Not yet.

---

### Connection to Existing Systems
Execution quality feeds into systems already designed:

**Persistent particle accumulation** — high execution quality contributes
more particles to the persistent system. Skilled play leaves a more
spectacular room behind. The environment is a record of the player's
performance.

**Combo threshold camera** — high execution quality contributes more to
the combo meter, reaching dramatic camera thresholds faster. The camera
responds more dynamically to skilled play.

**Nano buildup** — high execution applies more nano to targets, cycling
through contagion states faster. Skilled execution and the nano system
are aligned — both reward the same quality of play.

**Cooldown reduction** — tight execution means more moves available more
often. Skilled play produces more mechanical options, not just better
visual feedback.

All reward systems in the game are unified around the moment of skilled
gestural execution as the central rewarded action. One clean input
touches every reward system simultaneously.