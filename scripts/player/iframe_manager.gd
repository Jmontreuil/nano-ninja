extends Node

class_name IFrameManager

# ─────────────────────────────────────────
# CONSTANTS
# ─────────────────────────────────────────
const IFRAME_DURATION = 0.3

# ─────────────────────────────────────────
# PUBLIC VARIABLES
# ─────────────────────────────────────────
var is_invulnerable = false

# ─────────────────────────────────────────
# PRIVATE VARIABLES
# ─────────────────────────────────────────
var _iframe_timer = 0.0

# ─────────────────────────────────────────
# BUILT IN
# ─────────────────────────────────────────
func _physics_process(delta):
	if not is_invulnerable:
		return
	_iframe_timer -= delta
	if _iframe_timer <= 0.0:
		_end_invulnerability()

# ─────────────────────────────────────────
# PUBLIC
# ─────────────────────────────────────────
func start_invulnerability(duration: float = IFRAME_DURATION):
	is_invulnerable = true
	_iframe_timer = duration
	get_parent().sig_invulnerability_started.emit()
	# TODO: disable hurtbox collision here when Hurtbox node is added

# ─────────────────────────────────────────
# SIGNAL HANDLERS
# ─────────────────────────────────────────
func _on_sig_dash_started(_direction):
	start_invulnerability()

# ─────────────────────────────────────────
# PRIVATE
# ─────────────────────────────────────────
func _end_invulnerability():
	is_invulnerable = false
	get_parent().sig_invulnerability_ended.emit()
	# TODO: re-enable hurtbox collision here when Hurtbox node is added
