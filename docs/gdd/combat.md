# Combat and Systems

---

## Combat System Overview

A dual stick combat system. The left stick controls movement. The right stick controls
gestural attack inputs. The combat loop is: approach → strike → reward window → relaunch.

---

## The Combat Loop

**Phase 1 — Movement**
The player performs a right stick gesture, modified by shoulder buttons, to dash or jump
toward a target. The approach direction and angle are tracked. This is the anticipation
phase — commitment to a direction and an angle.

**Phase 2 — The Strike**
At arrival or during movement, the player inputs an attack. Attacks use Street Fighter
style directional inputs — quarter circles, arcs, directional combinations — performed
with the right stick. The gesture defines the attack.

**Phase 3 — The Reward Window**
A successful hit opens a brief window. Inside it: i-frames (temporary invulnerability),
and a dash refresh. This enables combo chaining — relaunch the loop immediately. The
window is the skill expression moment. Recognising and acting on it quickly sustains the chain.

**Breaking the Loop**
Missing an attack, mistiming the window, or taking a hit ends the chain and leaves the
player exposed. The loop being both offensive and defensive means staying aggressive is
also the safest strategy for skilled players.

---

## Gestural Input and Relative Direction

Move inputs are defined relative to the approach vector, not absolute controller directions.
A move that is "down then forward" in the player's local frame of reference is translated into
absolute stick coordinates based on the direction of approach.

This means the same gesture always feels the same regardless of which direction the player
came from. The move grammar is spatial and intuitive rather than memorised and absolute.

Approach angle may also modify or unlock specific move variants — a downward approach version
and a horizontal approach version of the same input producing different outcomes.

---

## Shoulder Buttons

Used as modifiers and phase triggers. Specific roles to be developed. Options include
distinguishing the anticipation and release phases, categorising gestures as movement or
attack, or triggering special moves.

---

## The Parry

Triggered by a timed shoulder input. Deliberate and reactive — distinct from the gestural
attack system. The parry:

- Blocks an incoming attack
- Applies nano directly to the attacker — the chip converts the impact into a nano injection
- If the attacker is already nano-loaded, triggers immediate detonation spreading to nearby enemies
- Builds the shared nano charge meter
- In hard mode specifically, acts as the skill-based defensive lifeline replacing upgrade-based offense

---

## Time Slow on Charge

### Concept
Time slows slightly when the player charges an attack, allowing a brief window to aim. The
slow is intentionally subtle at base level — a feeling of weight and commitment rather than
a mechanical pause to plan.

### Base Level
Time scale approximately 0.85x — barely perceptible. Registers as the attack feeling
deliberate and heavy rather than giving the player a meaningful planning window. The charge
feels like a consequence, not a safety net.

### Upgrade Scaling
Further upgrades in the dash and agility path lengthen the time slow duration and add damage
boosts to compensate for the increased exposure. The trade is explicit — you slow the world
longer but you hit harder.

Early game: subliminal, almost imperceptible
Late game with full upgrades: dramatic and intentional, earned through progression

### Design Constraints
- The player cannot parry while charging — forces a genuine choice between committing to the
  attack or staying defensive
- The time slow is not a catch your breath moment — pacing and duration must be tuned to
  prevent it feeling like a pause button
- The slow should feel like weight and commitment, not control

---

## Nano System

### Overview
Nano is biological and systemic. It spreads, corrupts, and builds over time. It works with
and through living and electronic systems. Patient, cascading, networked. The hacker's toolkit.

In a room full of enemies nano turns the battlefield into a managed cascade. Different tools
for different problems — and different philosophies about what kind of fighter you are.

### Nano Effects

**Nano Corrosion**
Eats through armor over time. Synergises with the knockback and armor break upgrade path.
Particularly effective as a setup tool before a heavy knockback combo.

**Nano Swarm**
A damage over time cloud released on hit or deployed as a standalone ability. Spreads to
nearby enemies on kill. Good for clustered groups.

**Nano Trace**
Marks an enemy. Enhances subsequent attacks against marked targets. Network effects: two
marked enemies near each other amplify damage between them. Three or more creates a feedback
loop. Rewards thinking about the whole room rather than one target.

**Nano Overload**
A charged effect that detonates after a threshold of nano buildup. Triggers smaller explosions
on nearby enemies. Chain detonations cascade through nano-loaded groups. A patient player
sets up the chain before triggering it.

**Nano Heal**
Passive regeneration or burst heal tied to combat performance. Rewards sustained engagement.

### Nano Interactions
Different nano types interact with each other — corrosion plus swarm produces compound effects
neither achieves alone. Stacking multiple types and hitting thresholds triggers automatic
emergent effects. The system rewards experimentation and knowledge of the interaction table.

### The Contagion System
Inspired by Cyberpunk 2077's quickhacking contagion. Effects spread from killed or critically
hit enemies to nearby enemies. Special moves can create building and spreading effects. The
goal is for skilled players to feel like a force multiplier — one well-placed action cascades
through a group.

### Parry and Nano
A successful parry applies nano directly to the attacker. If the attacker is already
nano-loaded, the parry triggers immediate detonation spreading to nearby enemies.

The full contagion chain: **parry → apply nano → contagion spreads → meter fills → nano burst
detonates everything simultaneously.**

### The Nano Charge Meter
Built by successful parries. When full, triggers a nano burst — a room-wide pulse that applies
the current active nano type to every enemy present simultaneously. In a room full of enemies
this is the power fantasy moment. The meter rewards defensive skill with explosive offensive payoff.

### Nano in Hard Mode
Without upgrades nano builds slower and the burst is less explosive. But the parry still feeds
the meter. Hard mode nano is a slow burn — carefully cultivated rather than splashed around.
The hard mode player has a different, more deliberate relationship with the nano system.

### Visual and Audio Design Notes
- Each nano type needs a distinct visual language — battlefield state must be readable at a glance
- Nano spread and detonation chains need satisfying, distinct audio design
- Nano interaction with boss enemies to be developed — partial immunity, different thresholds, unique reactions

---

## Gestural Combat — Moveset Forking

### Moves as Data
Moves are defined as Resources — Godot data containers saved as files, duplicated, and
swapped at runtime without touching code. Each moveset is a .tres file in the project.

```gdscript
# move_definition.gd
class_name MoveDefinition
extends Resource

@export var exp_move_name : String = ""
@export var exp_gesture : Array[Vector2] = []
@export var exp_gesture_tolerance : float = 0.3
@export var exp_damage : float = 10.0
@export var exp_hitbox_active_frame : int = 4
@export var exp_hitbox_duration : float = 0.1
@export var exp_animation_name : String = ""
@export var exp_time_slow : float = 1.0
```

```gdscript
# moveset.gd
class_name Moveset
extends Resource

@export var exp_moveset_name : String = ""
@export var exp_moves : Array[MoveDefinition] = []
```

### Forking a Moveset
Duplicate the .tres file in the Godot filesystem panel, rename it, edit values. Original
is untouched. Both files exist independently.

```
/assets/movesets/
    moveset_base.tres
    moveset_alt_heavy.tres
    moveset_alt_fluid.tres
    moveset_experimental.tres
```

### Selecting Alternates in the Debug Room
The debug manager exposes the active moveset as an exported variable. Swap the .tres file
in the Inspector and press play — no code changes.

---

## Gesture Recognition System

### Architecture
Right stick position sampled every physics frame into a rolling buffer. Buffer analysed each
frame for gesture signatures. Recognised gestures emit signals consumed by the combat system.

### Quarter Circle Down to Left — Implementation

```gdscript
# gesture_reader.gd
extends Node

signal sig_gesture_recognised(gesture_name)

const BUFFER_SIZE = 20
const DEAD_ZONE = 0.3

var _stick_buffer : Array[Vector2] = []

func _physics_process(_delta):
    var stick = Input.get_vector(
        "aim_left", "aim_right", "aim_up", "aim_down"
    )
    if stick.length() > DEAD_ZONE:
        _stick_buffer.append(stick.normalized())
    while _stick_buffer.size() > BUFFER_SIZE:
        _stick_buffer.pop_front()
    _check_gestures()

func _check_gestures():
    if _stick_buffer.size() < 8:
        return
    if _match_quarter_circle_down_left():
        sig_gesture_recognised.emit("quarter_circle_down_left")
        _stick_buffer.clear()

func _match_quarter_circle_down_left() -> bool:
    if _stick_buffer.size() < 8:
        return false
    var samples = _stick_buffer.slice(-8)
    var start_angle = rad_to_deg(samples[0].angle())
    if not _angle_near(start_angle, 90.0, 45.0):
        return false
    var end_angle = rad_to_deg(samples[-1].angle())
    if not _angle_near(end_angle, 180.0, 45.0):
        return false
    var passed_through = false
    for sample in samples:
        if _angle_near(rad_to_deg(sample.angle()), 135.0, 35.0):
            passed_through = true
            break
    return passed_through

func _angle_near(angle: float, target: float, tolerance: float) -> bool:
    var diff = abs(angle - target)
    if diff > 180.0:
        diff = 360.0 - diff
    return diff <= tolerance
```

### The Approach Vector Rotation
Before gesture checking, raw stick input is rotated by the inverse of the approach angle —
the direction the player was moving toward the enemy when the gesture started:

```gdscript
func _get_rotated_stick(raw_stick: Vector2, approach_angle: float) -> Vector2:
    return raw_stick.rotated(-approach_angle)
```

Gesture recognition runs on rotated values. A quarter circle toward the enemy always produces
the same move regardless of approach direction. This is the core innovation that makes the
system feel embodied rather than arbitrary.

### Tuning Values
- `BUFFER_SIZE` — more frames means more forgiving timing, fewer means tighter
- Tolerance in `_angle_near()` — wider feels forgiving, tighter feels precise
- `samples = _stick_buffer.slice(-8)` — more frames catches slower gestures
- These are primary tuning targets during Phase 1 experimentation

### Suggested Starting Values
- Tolerance: 45 degrees — very forgiving starting point
- Buffer window: 20 frames
- Get the move feeling good and feedback readable first
- Tighten tolerance in 5 degree increments during playtesting

---

## Balancing Precision and Player Intention

### The Core Tension
Precise gesture recognition rewards skilled players with physical mastery. But if recognition
is too strict, new players fail to execute moves and feel like the game is broken rather than
that they need to improve. The skill floor problem is not about difficulty — it is about
legibility.

### Dynamic Tolerance
Tolerance does not have to be fixed. Dynamic tolerance starts wide and tightens as the player
demonstrates competence:

```gdscript
var gesture_tolerance : float = 45.0
var successful_gestures : int = 0

func _on_gesture_succeeded():
    successful_gestures += 1
    gesture_tolerance = max(25.0, 45.0 - (successful_gestures * 0.5))
```

### Input Buffering
A generous buffer separates accuracy from speed — players demonstrate accuracy at their own
pace before speed becomes relevant.

### Intention Reading
Smooth the buffer before analysing it — averaging adjacent samples removes small deviations
and reveals the underlying intended shape:

```gdscript
func _smooth_buffer(buffer: Array[Vector2], window: int = 3) -> Array[Vector2]:
    var smoothed = []
    for i in range(buffer.size()):
        var sum = Vector2.ZERO
        var count = 0
        for j in range(max(0, i - window), min(buffer.size(), i + window + 1)):
            sum += buffer[j]
            count += 1
        smoothed.append(sum / count)
    return smoothed
```

---

## Tiered Input — Simple and Gestural Modes

Two input modes produce the same moves. Players self-select based on comfort and skill:

**Simple mode** — directional inputs. Hold stick toward enemy and press attack. Clean,
reliable, no gesture required. The move fires every time.

**Gestural mode** — the full quarter circle system. Harder to execute, produces the same
move, but with visible execution rewards.

This is the Skate design principle in practice — nobody was locked out. Mastery was rewarded
without gatekeeping. The skill floor is the simple input. The skill ceiling is the gestural
system. Neither player is locked out of any content.

---

## Rewarding Gestural Execution

**Mechanical rewards:**
- Slightly longer reward window — more time to chain the next move
- Minor damage bonus
- Faster recovery frames — tighter combo chains possible
- Dash cooldown reduction on clean execution

**Visual and audio rewards:**
- More spectacular attack animation
- Distinct, more impactful sound design
- Greater particle accumulation — skilled play becomes visually spectacular
- More pronounced screen response on gestural hits

**Systemic rewards:**
- Nano buildup bonus — gestural attacks apply more nano, accelerating contagion
- Combo meter contribution — reaches camera thresholds faster

The rewards should be visible and feelable but not so large that simple mode players feel
punished. The gap between modes is the difference between good and excellent.

---

## Diegetic Feedback — No Floating Numbers

Execution quality feedback lives in the world, not in the UI. No damage numbers, no grade
letters, no screen-edge indicators, no pop-up alerts.

The weapon is the feedback surface. The character is the feedback surface. The environment
is the feedback surface.

**Weapon effects** — the primary feedback channel. Low execution: the effect exists but
is subdued. High execution: the effect is spectacular.

**Character animation** — high execution quality triggers a more dynamic animation variant.

**Environmental response** — persistent particles, light response, nano spread all respond
more dramatically to high execution quality.

**Audio** — hit sounds have execution quality variants. A clean hit sounds different from a
perfect hit.

### The Spectator Test
A new player watching an expert play should be able to:
1. See that the expert's moves look different — more spectacular, more dynamic
2. Recognise that the expert is performing the same moves they themselves can perform
3. Read the gap as skill, not as access to a different system

The correct spectator response: *"I can do that, but not like that. Not yet."*

---

## Keyboard Input Variation

### Priority Note
The analogue stick gestural system is the identity of the combat. All design decisions are
made for the stick first. The keyboard path is an accommodation.

### The Metaphor
Street Fighter — quarter circles on the stick. Continuous spatial input. The gesture has a
shape. The input and outcome feel physically connected.

Mortal Kombat — discrete sequential button presses. A code rather than a gesture.

The gestural system lives at the Street Fighter end. The keyboard variation lives closer to
Mortal Kombat but grounded in directional logic.

### Hybrid Approach
**Controller** — analogue stick gestures. The priority path.

**Keyboard** — sequential directional inputs. WASD or arrow key combinations in sequence.
Not arbitrary codes but directional logic. Produces the same moves and the same execution
quality spectrum.

### Execution Quality on Keyboard
Measured by timing rather than arc smoothness. A sequential input performed with consistent
rhythm reads as higher quality than the same sequence with irregular spacing.

### Code Architecture

```gdscript
func _detect_gesture():
    if Input.get_connected_joypads().size() > 0:
        _check_analogue_gestures()
    else:
        _check_sequential_gestures()

# Both paths emit:
sig_gesture_recognised.emit(move_name, quality_float)
```

Input device branching must be designed in from the start — not retrofitted.

---

## Dash Anticipation and Charge State

### The Concept
The dash is not a press-to-go input. It is a draw-and-release. The player pulls back on the stick, the character reads the intent and holds tension, the dash fires on release. The anticipation is part of the input.

This aligns with the gestural, embodied input philosophy and the Skate reference — in Skate you load tricks through stick position before executing. The anticipation is not a delay, it is a commitment.

**Input method:** Flick and release. No button. The stick motion is the entire input — pull back to charge, release to fire.

---

### Mechanical Possibilities
Hold duration opens a design space:

**Brief hold** — acknowledges intent, plays anticipation animation, fires standard dash on release. Visual read improves, mechanic unchanged.

**Longer hold** — builds charge, modifies the dash. Options include:
- More distance or speed
- More invulnerability frames
- More damage on the arrival strike
- More spectacular visual effect on execution

**Overcharge** — held too long. Either fires automatically or applies a penalty. Overcommitment having a cost is interesting design.

These do not need to be decided now. The signal architecture must accommodate them from the start.

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

`sig_dash_charge_building` is the key signal — the charge percentage it carries drives multiple systems simultaneously:
- Animation controller — scales anticipation effect as charge grows
- Combat system — determines dash properties on release
- Shader system — drives power buildup visual on character or weapon

`sig_dash_charge_started(direction)` carries direction — the anticipation animation needs to know which way the character is about to move. A character anticipating a rightward dash leans right. Direction at charge start feeds into the approach vector system.

---

### Animation States — Updated Set

```
idle
dash_anticipation    ← plays when charge starts
dash_charge          ← loops while charge builds, scales with charge_pct
dash                 ← fires on release
dash_land            ← arrival
i_frame
attack               ← stub, defined fully in Phase 1
```

**dash_charge** is the visually interesting state. At low charge percentage: subtle — slight crouch, lean into direction. At high charge percentage: dramatic — energy gathering, character coiled.

The charge percentage can drive:
- How far through the animation plays
- A shader parameter on the character directly
- Both simultaneously

---

### Connection to Existing Systems
The charge percentage signal connects to systems already designed:

**Execution quality** — charge level at release contributes to execution quality. A fully charged release produces more spectacular effects than a quick flick.

**Nano system** — a fully charged dash arrival could apply nano on contact, connecting movement and nano spread into one action.

**Persistent particles** — dash charge buildup could accumulate particles around the character, releasing them on the dash itself. Visual charge that becomes visual speed.

**Combat loop** — the anticipation state is the moment between approach and strike. It is readable to enemies and to other players watching. Skilled play looks different because the charge is visible.
