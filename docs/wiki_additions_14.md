# Wiki Additions — Session February 24 2026 (Part 1)

---

## Gestural Combat — Balancing Precision and Player Intention

### The Core Tension
Precise gesture recognition rewards skilled players with physical mastery.
But if recognition is too strict, new players fail to execute moves and
feel like the game is broken rather than that they need to improve. The
skill floor problem is not about difficulty — it is about legibility. A
player who fails to execute a move needs to understand why they failed
and feel like success is within reach.

---

### Tolerance — The Primary Tuning Lever
The tolerance parameter in `_angle_near()` is the most important value
in the entire gesture system. Wide tolerance accepts sloppy inputs.
Narrow tolerance requires clean precise execution.

Tolerance does not have to be fixed. Dynamic tolerance starts wide and
tightens as the player demonstrates competence — neither player knows
this is happening, both feel like they are playing the same game:

```gdscript
var gesture_tolerance : float = 45.0  # starts wide
var successful_gestures : int = 0

func _on_gesture_succeeded():
    successful_gestures += 1
    # Gradually tighten as player demonstrates skill
    gesture_tolerance = max(25.0, 45.0 - (successful_gestures * 0.5))
```

### Input Buffering
Buffer window length — how many frames the gesture reader looks back —
is the second major lever. A longer buffer catches slower more deliberate
inputs. A shorter buffer requires faster more precise execution.

Speed of execution and accuracy of execution are different skills.
A generous buffer separates them — players demonstrate accuracy at their
own pace before speed becomes relevant. A quarter circle performed over
30 frames should register the same as one performed over 10 frames.

### Intention Reading
Read what the player was trying to do rather than what they literally did.
Smooth the buffer before analysing it — averaging adjacent samples removes
small deviations and reveals the underlying intended shape:

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

Run the smoothed version through the gesture matcher rather than raw
input. The player's intention is more visible in smoothed data.

---

### Tiered Input — Simple and Gestural Modes
Two input modes produce the same moves. Players self-select based on
comfort and skill level:

**Simple mode** — directional inputs. Hold stick toward enemy and press
attack. Clean, reliable, no gesture required. The move fires every time.

**Gestural mode** — the full quarter circle system. Harder to execute,
produces the same move, but with visible execution rewards (see below).

This is the Skate design principle in practice — in Skate you could
control your board with face buttons but analogue stick tricks felt more
satisfying and produced better scores. Nobody was locked out. Mastery
was rewarded without gatekeeping.

The skill floor is the simple input. The skill ceiling is the gestural
system. Neither player is locked out of any content.

---

### Rewarding Gestural Execution
Successful gesture execution should feel meaningfully better than simple
input — not gatekeeping content but rewarding mastery with tangible and
visible benefits:

**Mechanical rewards:**
- Slightly longer reward window — more time to chain the next move
- Minor damage bonus — gesture execution deals more than simple input
- Faster recovery frames — gestural attacks return the player to neutral
  sooner, enabling tighter combo chains
- Dash cooldown reduction on clean execution — rewards precision with
  more resource availability

**Visual and audio rewards:**
- More spectacular attack animation — the gestural version of a move
  looks more dramatic than the simple version
- Distinct sound design — a gestural hit sounds more impactful, more
  satisfying than a simple input hit
- Particle accumulation — clean gestural execution adds more to the
  persistent particle system than simple inputs, making skilled play
  visually spectacular over time
- Hit flash — a more pronounced screen response on gestural hits

**Systemic rewards:**
- Nano buildup bonus — gestural attacks apply slightly more nano to
  targets, accelerating the contagion system for skilled players
- Combo meter contribution — gestural moves contribute more to the
  combo threshold system, reaching visual and mechanical thresholds
  faster through skilled execution

The rewards should be visible and feelable but not so large that simple
mode players feel punished. The gap between modes is the difference
between good and excellent — not between functional and broken.

---

### Feedback on Failed Gestures
Whatever tolerance and buffer settings are chosen, the player must
understand what happened when a gesture fails.

A failed gesture with no feedback — silence — is the worst outcome.
The player does not know if they were close or completely wrong.

**Near-miss feedback** — a subtle visual or audio cue implying almost.
A brief flash, a sound that suggests something almost happened. Tells
the player they are on the right track.

**Complete miss feedback** — a clearly different response. Tells the
player to try again differently.

The feedback loop makes the skill floor learnable rather than opaque.

---

### Connecting to Existing Systems
Gestural execution rewards feed directly into systems already designed:

**Persistent particle accumulation** — gestural moves contributing more
to the particle system than simple inputs means skilled play becomes
visually spectacular over time in a way that simple mode play does not.
The room tells the story of how well the player performed. This connection
is not incidental — it is the visual expression of the power fantasy
pillar. Mastery looks different from competence.

**Combo threshold camera** — gestural moves contributing more to the
combo meter means skilled players reach the dramatic camera punch-in
thresholds faster. The world responds more dramatically to skilled
execution. The camera is an audience for the player's performance.

**Nano system** — gestural nano buildup bonus means skilled players
cycle through contagion states faster, reaching chain explosion and
burst thresholds more efficiently. The nano system rewards the same
player the combo and particle systems reward — not through a separate
mechanic but through the same gesture execution that already powers
everything else.

The design principle: gestural execution is not an isolated input system.
It is the thread that runs through every reward system in the game.
One skilled input produces better moves, more particles, faster camera
responses, and accelerated nano spread simultaneously. The systems are
not connected by accident — they are intentionally unified around the
moment of skilled execution as the central rewarded action.

---

### Suggested Starting Values for Phase 1 Experimentation
- Tolerance: 45 degrees — very forgiving starting point
- Buffer window: 20 frames
- Get the move feeling good and feedback readable first
- Tighten tolerance in 5 degree increments during playtesting
- The threshold where execution starts feeling earned rather than
  automatic is the base tolerance value
- Build dynamic tolerance system around that locked value

- Tolerance: 45 degrees — very forgiving starting point
- Buffer window: 20 frames
- Get the move feeling good and feedback readable first
- Tighten tolerance in 5 degree increments during playtesting
- The threshold where execution starts feeling earned rather than
  automatic is the base tolerance value
- Build dynamic tolerance system around that locked value
