extends CharacterBody2D

class_name PlayerMovement

# ─────────────────────────────────────────
# SIGNALS
# ─────────────────────────────────────────
signal sig_dash_started(direction)
signal sig_dash_ended
signal sig_dash_ready
signal sig_invulnerability_started
signal sig_invulnerability_ended

# ─────────────────────────────────────────
# CONSTANTS
# ─────────────────────────────────────────
const SPEED = 200.0
const DASH_SPEED = 600.0
const DASH_DURATION = 0.15
const DASH_COOLDOWN = 0.5

# ─────────────────────────────────────────
# EXPORTED VARIABLES
# ─────────────────────────────────────────
@export var exp_dash_enabled : bool = true

# ─────────────────────────────────────────
# PUBLIC VARIABLES
# ─────────────────────────────────────────
var is_dashing = false
var dash_direction = Vector2.ZERO

# ─────────────────────────────────────────
# PRIVATE VARIABLES
# ─────────────────────────────────────────
var _dash_timer = 0.0
var _dash_cooldown_timer = 0.0

# ─────────────────────────────────────────
# NODE REFERENCES
# ─────────────────────────────────────────
@onready var node_sprite = $Sprite2D
@onready var node_iframe_manager = $IFrameManager

# ─────────────────────────────────────────
# BUILT IN
# ─────────────────────────────────────────
func _ready():
	sig_dash_started.connect(node_iframe_manager._on_sig_dash_started)

func _physics_process(delta):
	_handle_dash_timers(delta)

	if is_dashing:
		velocity = dash_direction * DASH_SPEED
	else:
		var move_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		velocity = move_input * SPEED

	move_and_slide()

func _input(event):
	if event.is_action_pressed("dash") and exp_dash_enabled:
		_attempt_dash()

# ─────────────────────────────────────────
# PRIVATE
# ─────────────────────────────────────────
func _attempt_dash():
	if is_dashing or _dash_cooldown_timer > 0.0:
		return

	var move_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	# Fallback prevents a zero length dash if the player is standing still
	dash_direction = move_input if move_input.length() > 0.1 else Vector2.RIGHT

	is_dashing = true
	_dash_timer = DASH_DURATION
	sig_dash_started.emit(dash_direction)

func _handle_dash_timers(delta):
	if is_dashing:
		_dash_timer -= delta
		if _dash_timer <= 0.0:
			is_dashing = false
			_dash_cooldown_timer = DASH_COOLDOWN
			sig_dash_ended.emit()

	if _dash_cooldown_timer > 0.0:
		_dash_cooldown_timer -= delta
		if _dash_cooldown_timer <= 0.0:
			sig_dash_ready.emit()
