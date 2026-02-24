# Wiki Additions — Session February 24 2026 (Part 3)

---

## Gestural Combat — Keyboard Input Variation

### Priority Note
The analogue stick gestural system is the identity of the combat.
All design decisions are made for the stick first. The keyboard path
is an accommodation — built cleanly so it works, never driving design.

---

### The Metaphor
Street Fighter — quarter circles and arcs on the analogue stick.
Continuous spatial input. The gesture has a shape. The input and outcome
feel physically connected because the hand makes a motion that resembles
the move.

Mortal Kombat — discrete sequential button presses. Back, forward, punch.
A code rather than a gesture. Faster to learn, easier to execute reliably,
but the connection between input and outcome is arbitrary rather than
embodied.

The gestural system lives at the Street Fighter end of this spectrum.
The keyboard variation lives closer to Mortal Kombat but grounded in
directional logic rather than arbitrary sequences.

---

### Hybrid Approach — Input Device Dependent
The input method is context dependent based on what the player is using.

**Controller** — analogue stick gestures. The stick affords continuous
spatial input. The arc recognition system and execution quality spectrum
work as designed. The priority path.

**Keyboard** — sequential directional inputs. WASD or arrow key
combinations in sequence. Not arbitrary codes but directional logic —
the input still has spatial meaning in discrete steps rather than
continuous motion. Produces the same moves and the same execution
quality spectrum through a different recognition system.

### Execution Quality on Keyboard
Tight execution on keyboard is measured by timing rather than arc
smoothness. A sequential input performed with consistent rhythm — each
press hitting a beat — reads as higher quality than the same sequence
with irregular spacing. Rhythm is the quality signal where arc smoothness
is the quality signal on stick.

### Code Architecture
The gesture reader branches on detected input device. Both paths emit
the same signal with the same move name and quality float. Everything
downstream is identical:

```gdscript
func _detect_gesture():
    if Input.get_connected_joypads().size() > 0:
        _check_analogue_gestures()   # arc recognition
    else:
        _check_sequential_gestures() # timing recognition

# Both paths emit:
sig_gesture_recognised.emit(move_name, quality_float)
```

### Implementation Note
Input device branching must be designed in from the start — not
retrofitted. When building the gesture reader in Phase 1 include
the branch point even if the keyboard path is stubbed out initially.
