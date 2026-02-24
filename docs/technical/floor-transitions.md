# Floor Transitions — FloorTransitionManager

---

## Overview

The floor transition system sells the illusion of moving between floors in the arcology
using camera zoom, player scale, and layer motion_scale — not geometry changes. The player
stays on a flat 2D plane. The depth is performed through tweens.

See [visual-systems.md](../visual/visual-systems.md) for the conceptual explanation.

---

## FloorTransitionManager Template

Save as: `scenes/templates/floor_transition_manager.tscn`
Attach script: `scripts/floor_transition_manager.gd`

### Scene Structure

```
FloorTransitionManager (Node2D) ← script attached here
├── Threshold_Lower (Area2D) ← triggers lower → upper transition
│   └── CollisionShape2D
├── Threshold_Upper (Area2D) ← triggers upper → lower transition
│   └── CollisionShape2D
└── [Optional] Threshold_Mid (Area2D) ← mid point neutral zone
    └── CollisionShape2D
```

### Script

```gdscript
# floor_transition_manager.gd
extends Node2D

# ─────────────────────────────────────────
# SIGNALS
# ─────────────────────────────────────────
signal sig_transition_started(from_floor, to_floor)
signal sig_transition_completed(floor_name)

# ─────────────────────────────────────────
# EXPORTS — configure per level in Inspector
# ─────────────────────────────────────────

# Camera
@export var exp_camera : Camera2D
@export var exp_lower_camera_pos : Vector2 = Vector2(0, 200)
@export var exp_upper_camera_pos : Vector2 = Vector2(0, -200)
@export var exp_lower_camera_zoom : Vector2 = Vector2(0.7, 0.7)
@export var exp_upper_camera_zoom : Vector2 = Vector2(1.4, 1.4)

# Player
@export var exp_player : CharacterBody2D
@export var exp_lower_player_scale : Vector2 = Vector2(0.85, 0.85)
@export var exp_upper_player_scale : Vector2 = Vector2(1.15, 1.15)

# Layers
@export var exp_lower_canvas_layer : CanvasLayer
@export var exp_upper_canvas_layer : CanvasLayer
@export var exp_lower_motion_scale : Vector2 = Vector2(0.7, 0.7)
@export var exp_upper_motion_scale : Vector2 = Vector2(1.4, 1.4)

# Shader materials — assign CanvasGroup ShaderMaterials in Inspector
@export var exp_lower_shader : ShaderMaterial
@export var exp_upper_shader : ShaderMaterial

# Color correction per floor
@export var exp_lower_brightness : float = 0.9
@export var exp_upper_brightness : float = 1.1
@export var exp_lower_saturation : float = 0.85
@export var exp_upper_saturation : float = 1.0
@export var exp_lower_contrast : float = 0.9
@export var exp_upper_contrast : float = 1.0

# Transition
@export var exp_transition_duration : float = 1.2
@export var exp_tween_ease : Tween.EaseType = Tween.EASE_IN_OUT

# ─────────────────────────────────────────
# STATE
# ─────────────────────────────────────────
var current_floor : String = "lower"
var is_transitioning : bool = false

# ─────────────────────────────────────────
# BUILT IN
# ─────────────────────────────────────────
func _ready():
    $Threshold_Lower.body_entered.connect(_on_threshold_lower_entered)
    $Threshold_Upper.body_entered.connect(_on_threshold_upper_entered)
    _apply_floor_state_immediate("lower")

# ─────────────────────────────────────────
# PUBLIC
# ─────────────────────────────────────────
func transition_to_floor(floor_name: String):
    if is_transitioning or current_floor == floor_name:
        return
    is_transitioning = true
    sig_transition_started.emit(current_floor, floor_name)

    var tween = create_tween().set_parallel()
    tween.set_ease(exp_tween_ease)
    tween.set_trans(Tween.TRANS_SINE)

    match floor_name:
        "upper":
            _tween_to_upper(tween)
        "lower":
            _tween_to_lower(tween)

    await tween.finished
    current_floor = floor_name
    is_transitioning = false
    sig_transition_completed.emit(floor_name)

# ─────────────────────────────────────────
# PRIVATE
# ─────────────────────────────────────────
func _tween_to_upper(tween: Tween):
    var d = exp_transition_duration
    tween.tween_property(exp_camera, "position", exp_upper_camera_pos, d)
    tween.tween_property(exp_camera, "zoom", exp_upper_camera_zoom, d)
    tween.tween_property(exp_player, "scale", exp_upper_player_scale, d)
    tween.tween_method(
        func(val): exp_lower_canvas_layer.motion_scale = Vector2(val, val),
        exp_lower_motion_scale.x, exp_upper_motion_scale.x * 0.5, d
    )
    if exp_lower_shader:
        tween.tween_method(
            func(val): exp_lower_shader.set_shader_parameter("blur_amount", val),
            0.0, 3.0, d
        )
        tween.tween_method(
            func(val): exp_lower_shader.set_shader_parameter("desaturate", val),
            0.0, 0.3, d
        )
    if exp_upper_shader:
        tween.tween_method(
            func(val): exp_upper_shader.set_shader_parameter("blur_amount", val),
            3.0, 0.0, d
        )
    _tween_color_correction(tween, exp_upper_brightness,
        exp_upper_saturation, exp_upper_contrast, d)

func _tween_to_lower(tween: Tween):
    var d = exp_transition_duration
    tween.tween_property(exp_camera, "position", exp_lower_camera_pos, d)
    tween.tween_property(exp_camera, "zoom", exp_lower_camera_zoom, d)
    tween.tween_property(exp_player, "scale", exp_lower_player_scale, d)
    if exp_upper_shader:
        tween.tween_method(
            func(val): exp_upper_shader.set_shader_parameter("blur_amount", val),
            0.0, 3.0, d
        )
    if exp_lower_shader:
        tween.tween_method(
            func(val): exp_lower_shader.set_shader_parameter("blur_amount", val),
            3.0, 0.0, d
        )
    _tween_color_correction(tween, exp_lower_brightness,
        exp_lower_saturation, exp_lower_contrast, d)

func _tween_color_correction(tween: Tween, brightness, saturation, contrast, duration):
    var env = get_tree().get_root().get_node("WorldEnvironment").environment
    if not env:
        return
    tween.tween_method(
        func(val): env.adjustment_brightness = val,
        env.adjustment_brightness, brightness, duration
    )
    tween.tween_method(
        func(val): env.adjustment_saturation = val,
        env.adjustment_saturation, saturation, duration
    )
    tween.tween_method(
        func(val): env.adjustment_contrast = val,
        env.adjustment_contrast, contrast, duration
    )

func _apply_floor_state_immediate(floor_name: String):
    current_floor = floor_name
    match floor_name:
        "lower":
            if exp_camera:
                exp_camera.position = exp_lower_camera_pos
                exp_camera.zoom = exp_lower_camera_zoom
            if exp_player:
                exp_player.scale = exp_lower_player_scale
        "upper":
            if exp_camera:
                exp_camera.position = exp_upper_camera_pos
                exp_camera.zoom = exp_upper_camera_zoom
            if exp_player:
                exp_player.scale = exp_upper_player_scale

func _on_threshold_lower_entered(body):
    if body == exp_player:
        transition_to_floor("upper")

func _on_threshold_upper_entered(body):
    if body == exp_player:
        transition_to_floor("lower")
```

---

## Usage Notes

- Assign all exported references in the Inspector per level instance
- Threshold areas placed at stair entry and exit points
- Add more threshold areas and match cases for three or more floor tiers
- Shader materials must be assigned to CanvasGroup nodes on each layer
- Color correction requires a WorldEnvironment node in the scene tree
- `sig_transition_started` and `sig_transition_completed` can trigger audio,
  narrative events, or additional visual effects from other systems

---

## Experimentation Note

This system should be built early and treated as a dedicated experimentation session before
levels are built around it. Variables to tune:

- The zoom range between floor tiers (0.7 to 1.4 is a starting point)
- Whether player scale change is subtle or pronounced
- Tween duration — faster feels dynamic, slower feels cinematic
- Easing curve character
- Whether the camera leads the player scale or follows it
- Whether a slight camera rotation tween (1-2 degrees) adds cinematic quality

Treat the first session with this system as pure play. Tune values, compare feels, commit
nothing until something is clearly right.
