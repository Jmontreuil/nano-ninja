extends Node

class_name DebugManager

# ─────────────────────────────────────────
# CONSTANTS
# ─────────────────────────────────────────
const SLOW_MOTION_SCALE = 0.25

# ─────────────────────────────────────────
# EXPORTED VARIABLES
# ─────────────────────────────────────────
@export var exp_player : CharacterBody2D
@export var exp_spawn_player : Marker2D
@export var exp_state_label : Label

# ─────────────────────────────────────────
# PRIVATE VARIABLES
# ─────────────────────────────────────────
var _slow_motion_active = false

# ─────────────────────────────────────────
# BUILT IN
# ─────────────────────────────────────────
func _process(_delta):
	_update_state_label()

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_R:
			_reset_player()
		if event.keycode == KEY_T:
			_toggle_slow_motion()

# ─────────────────────────────────────────
# PRIVATE
# ─────────────────────────────────────────
func _reset_player():
	if not exp_player or not exp_spawn_player:
		return
	exp_player.global_position = exp_spawn_player.global_position
	exp_player.velocity = Vector2.ZERO

func _toggle_slow_motion():
	_slow_motion_active = not _slow_motion_active
	Engine.time_scale = SLOW_MOTION_SCALE if _slow_motion_active else 1.0

func _update_state_label():
	if not exp_player or not exp_state_label:
		return
	var p = exp_player as PlayerMovement
	exp_state_label.text = (
		"Dashing: %s\nInvulnerable: %s\nVelocity: (%.0f, %.0f)\nSlow motion: %s"
		% [p.is_dashing, p.node_iframe_manager.is_invulnerable,
		p.velocity.x, p.velocity.y, _slow_motion_active]
	)
