# Wiki Additions — Session February 23 2026 (Part 11)

---

## Gestural Combat — Moveset Forking and Testing

### Moves as Data
Moves are defined as Resources — Godot data containers saved as files,
duplicated, and swapped at runtime without touching code. Each moveset
is a .tres file in the project.

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
Duplicate the .tres file in the Godot filesystem panel, rename it, edit
values. Original is untouched. Both files exist independently.

```
/assets/movesets/
    moveset_base.tres
    moveset_alt_heavy.tres
    moveset_alt_fluid.tres
    moveset_experimental.tres
```

### Selecting Alternates in the Debug Room
The debug manager exposes the active moveset as an exported variable.
Swap the .tres file in the Inspector and press play — no code changes:

```gdscript
# debug_manager.gd
@export var exp_active_moveset : Moveset
@export var exp_moveset_library : Array[Moveset] = []

var _current_moveset_index : int = 0

func _ready():
    spawn_player()
    CombatSystem.load_moveset(exp_active_moveset)
    spawn_enemies()

func _input(event):
    if event.is_action_just_pressed("debug_cycle_moveset"):
        _current_moveset_index = \
            (_current_moveset_index + 1) % exp_moveset_library.size()
        CombatSystem.load_moveset(
            exp_moveset_library[_current_moveset_index]
        )
        print("Moveset: ", 
            exp_moveset_library[_current_moveset_index].exp_moveset_name)
```

Assign all moveset files to the library array in the Inspector. During
play, a bound key cycles through them without stopping the game.
The debug HUD shows the active moveset name at all times.

---

## Gestural Combat — Gesture Recognition System

### Architecture
Right stick position sampled every physics frame into a rolling buffer.
Buffer analysed each frame for gesture signatures. Recognised gestures
emit signals consumed by the combat system.

### Quarter Circle Down to Left

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
    
    # Start near down — Vector2.DOWN angle() ~90 degrees
    var start_angle = rad_to_deg(samples[0].angle())
    if not _angle_near(start_angle, 90.0, 45.0):
        return false
    
    # End near left — 180 degrees
    var end_angle = rad_to_deg(samples[-1].angle())
    if not _angle_near(end_angle, 180.0, 45.0):
        return false
    
    # Must pass through bottom-left diagonal — 135 degrees
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
Before gesture checking, raw stick input is rotated by the inverse of
the approach angle — the direction the player was moving toward the
enemy when the gesture started:

```gdscript
func _get_rotated_stick(raw_stick: Vector2, approach_angle: float) -> Vector2:
    return raw_stick.rotated(-approach_angle)
```

Gesture recognition runs on rotated values. A quarter circle toward the
enemy always produces the same move regardless of approach direction.
Moves have physical logic — the gesture is defined relative to the
relationship with the enemy, not screen space directions. This is the
core innovation that makes the system feel embodied rather than arbitrary.

### Tuning Values
- `BUFFER_SIZE` — more frames means more forgiving timing, fewer means
  tighter and more precise
- Tolerance in `_angle_near()` — wider feels forgiving, tighter feels
  precise
- `samples = _stick_buffer.slice(-8)` — how many frames the match
  analyses. More frames catches slower gestures, fewer catches faster ones
- These are primary tuning targets during Phase 1 experimentation
