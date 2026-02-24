# Wiki Additions — Session February 23 2026 (Part 9)

---

## Shader Masks — Layering Noise and External Maps

### Layering Noise in Shader Masks
Multiple noise textures combined in a shader produce organic masks with
large scale structure and fine surface detail — the classic fractal noise
octave pattern used in professional VFX and game shaders.

```glsl
uniform sampler2D noise_a;    // large scale, slow — base shape
uniform sampler2D noise_b;    // medium scale, medium speed — variation
uniform sampler2D noise_c;    // small scale, fast — surface detail
uniform float threshold;
uniform sampler2D screen_texture : hint_screen_texture;

void fragment() {
    float n1 = texture(noise_a, UV * 1.0 + TIME * 0.02).r;
    float n2 = texture(noise_b, UV * 3.0 + TIME * 0.05).r * 0.5;
    float n3 = texture(noise_c, UV * 8.0 + TIME * 0.1).r  * 0.25;
    
    float combined = (n1 + n2 + n3) / 1.75;
    float mask = smoothstep(threshold - 0.1, threshold + 0.1, combined);
    
    vec4 original = texture(screen_texture, SCREEN_UV);
    vec4 effect = [your effect here];
    COLOR = mix(original, effect, mask);
}
```

Weights 1.0 / 0.5 / 0.25 follow the fractal octave pattern — each layer
contributes half as much as the previous. Different scroll speeds animate
naturally without looking mechanical.

**Addition vs multiplication:**
- Adding layers → brighter, more expansive shapes
- Multiplying layers → darker, more eroded shapes
- Combining both → precise control over mask character

### Externally Building Mask Textures

**Krita** — free and open source. Paint greyscale masks by hand, export
as PNG. Best for hand-painted organic shapes — decay patterns, biological
spread boundaries, water stains. Consistent with art direction.

**Aseprite** — already in the workflow for sprites. Greyscale pixel art
masks exported as PNG. Good for masks needing a pixelated hand-crafted
feel.

**Substance Designer** — industry standard for procedural texture and
mask generation via node graph. More powerful than hand painting for
mathematically precise procedural masks. Steeper learning curve.

**Godot NoiseTexture2D** — generates noise masks procedurally inside
Godot without external tools. No export required:

```gdscript
var noise = FastNoiseLite.new()
noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
noise.frequency = 0.05
noise.fractal_octaves = 4

var noise_tex = NoiseTexture2D.new()
noise_tex.noise = noise
noise_tex.seamless = true  # prevents visible tiling edges

node_shader_material.set_shader_parameter("mask_texture", noise_tex)
```

### Importing External Masks into Godot
Drag PNG into the filesystem panel. In the Import tab:
- Texture type: Texture2D
- Disable compression for precise greyscale values
- Enable Mipmaps only if viewed at varying zoom levels
- Assign as shader uniform in Inspector or via code

---

## Floor Transitions — Architecture and Player Scaling

### The Core Misconception Corrected
The player node on the gameplay layer is not affected by other layers'
shader effects. CanvasLayers are completely isolated render passes.
A shader on layer -1 has zero influence on layer 0.

The player's apparent scale and the camera zoom create the sense of
depth — not motion_scale. Motion_scale controls scroll speed relative
to the camera, not apparent size.

### How Player Scaling Actually Works
Camera zoom tweening combined with player scale tweening sells the
illusion of the player moving closer to or further from the camera.
Background layers shifting motion_scale simultaneously reinforces the
depth change.

```gdscript
func transition_to_upper_floor():
    var tween = create_tween().set_parallel()
    
    # Camera zooms in — player appears larger, closer
    tween.tween_property(camera, "zoom", Vector2(1.4, 1.4), DURATION)
    
    # Player scales up slightly — reinforces coming closer
    tween.tween_property(player, "scale", Vector2(1.15, 1.15), DURATION)
    
    # Background layers shift motion_scale — world depth changes
    tween.tween_method(
        func(val): lower_layer.motion_scale = Vector2(val, val),
        1.0, 0.7, DURATION
    )
```

### Multi-Tier Scaling
Define camera zoom and player scale targets per floor level. Tween
between them as the player crosses thresholds:

```
Lower floor    →  camera zoom 0.7,  player scale 0.85
Stair middle   →  camera zoom 1.0,  player scale 1.0   ← neutral point
Upper floor    →  camera zoom 1.4,  player scale 1.15
```

The middle neutral point gives the climb a sense of continuous movement.
The transition passes through it rather than snapping between two states.

---

## FloorTransitionManager — Template

Save as: `scenes/templates/floor_transition_manager.tscn`
Attach script: `scripts/floor_transition_manager.gd`

### Scene Structure
```
FloorTransitionManager (Node2D) ← script attached here
├── Threshold_Lower (Area2D) ← triggers lower→upper transition
│   └── CollisionShape2D
├── Threshold_Upper (Area2D) ← triggers upper→lower transition
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

# Motion scaling
@export var exp_lower_motion_scale : Vector2 = Vector2(0.7, 0.7)
@export var exp_upper_motion_scale : Vector2 = Vector2(1.4, 1.4)

# Shader materials — assign CanvasGroup ShaderMaterials in Inspector
@export var exp_lower_shader : ShaderMaterial
@export var exp_upper_shader : ShaderMaterial

# Color correction per floor — set target values for each floor
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
    
    # Wait for transition to complete
    await tween.finished
    current_floor = floor_name
    is_transitioning = false
    sig_transition_completed.emit(floor_name)

# ─────────────────────────────────────────
# PRIVATE
# ─────────────────────────────────────────
func _tween_to_upper(tween: Tween):
    var d = exp_transition_duration
    
    # Camera
    tween.tween_property(exp_camera, "position", exp_upper_camera_pos, d)
    tween.tween_property(exp_camera, "zoom", exp_upper_camera_zoom, d)
    
    # Player scale
    tween.tween_property(exp_player, "scale", exp_upper_player_scale, d)
    
    # Layer motion scaling
    tween.tween_method(
        func(val): exp_lower_canvas_layer.motion_scale = Vector2(val, val),
        exp_lower_motion_scale.x, exp_upper_motion_scale.x * 0.5, d
    )
    
    # Shader — lower floor gets background treatment
    if exp_lower_shader:
        tween.tween_method(
            func(val): exp_lower_shader.set_shader_parameter("blur_amount", val),
            0.0, 3.0, d
        )
        tween.tween_method(
            func(val): exp_lower_shader.set_shader_parameter("desaturate", val),
            0.0, 0.3, d
        )
    
    # Shader — upper floor comes into clarity
    if exp_upper_shader:
        tween.tween_method(
            func(val): exp_upper_shader.set_shader_parameter("blur_amount", val),
            3.0, 0.0, d
        )
        tween.tween_method(
            func(val): exp_upper_shader.set_shader_parameter("desaturate", val),
            0.3, 0.0, d
        )
    
    # Color correction
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
    # Sets floor state instantly — used on _ready() to initialise
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

### Usage Notes
- Assign all exported references in the Inspector per level instance
- Threshold areas placed at stair entry and exit points
- Add more threshold areas and match cases for three or more floor tiers
- Shader materials must be assigned to CanvasGroup nodes on each layer
- Color correction requires a WorldEnvironment node in the scene tree
- The sig_transition_started and sig_transition_completed signals can
  trigger audio, narrative events, or additional visual effects from
  other systems
