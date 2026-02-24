# Wiki Additions — Session February 23 2026 (Part 3)

---

## Debug Testing Scene

### Purpose
A clean reusable scene for testing movement, combat, and enemy behaviour
without story or level dressing interfering. Built in stages toward a
reusable template for new test scenarios and eventually real levels.

### Scene Structure

```
DebugRoom (Node2D) ← root, debug manager script attached
├── ColorRect (floor — dark grey #1a1a1a, 1280x720)
├── NavigationRegion2D (covers walkable area, excludes obstacles)
│
├── StaticBody2D — WallTop
│   ├── ColorRect (bright red or white — visually obvious)
│   └── CollisionShape2D
├── StaticBody2D — WallBottom
│   └── [same structure]
├── StaticBody2D — WallLeft
│   └── [same structure]
├── StaticBody2D — WallRight
│   └── [same structure]
│
├── StaticBody2D — Pillar_01
│   ├── ColorRect (mid grey)
│   └── CollisionShape2D
├── StaticBody2D — Pillar_02
│   └── [same structure]
├── StaticBody2D — WalkwayEdge
│   └── [same structure]
├── StaticBody2D — NarrowCorridor
│   └── [same structure]
│
├── Marker2D — PlayerSpawn
├── Marker2D — EnemySpawn_01
├── Marker2D — EnemySpawn_02
└── Marker2D — EnemySpawn_03
```

### Layout Guidelines
- Playable area: approximately 1024x576 pixels
- Two or three central pillars of different sizes
- A raised walkway edge along one side — long thin obstacle
- A narrow corridor section to test tight space navigation
- An open arena section to test ranged combat and nano spread
- Border color visually distinct from floor and obstacles at a glance

### Debug Manager Script
Attached to the DebugRoom root. Handles scene setup via exported variables
assigned in the Inspector — swap what you're testing without touching code.

```gdscript
extends Node2D

@export var player_scene : PackedScene
@export var enemy_scene : PackedScene
@export var enemy_count : int = 3

func _ready():
    spawn_player()
    spawn_enemies()

func spawn_player():
    var player = player_scene.instantiate()
    player.global_position = $PlayerSpawn.global_position
    add_child(player)

func spawn_enemies():
    var spawns = [$EnemySpawn_01, $EnemySpawn_02, $EnemySpawn_03]
    for i in range(min(enemy_count, spawns.size())):
        var enemy = enemy_scene.instantiate()
        enemy.global_position = spawns[i].global_position
        add_child(enemy)
```

### Debug Quality of Life Features
All of the following live in the debug manager script and are disabled
or removed for shipping builds.

**Live state display** — a Label node updated every frame showing current
player state: velocity, dash cooldown, i-frame status, combo count.
Invaluable for tuning values without print statements everywhere.

**Reset button** — pressing R respawns the player and enemies at spawn
points without reloading the scene. Saves significant time during
combat testing.

**Slow motion toggle** — pressing T halves game speed. Lets you watch
fast combat interactions frame by frame to diagnose timing issues.

### The Template Workflow
Once the debug room is working, save a copy as:
`scenes/debug/debug_room_template.tscn`

This is the master template — never edit it directly.

**For a new test scenario:**
1. Duplicate `debug_room_template.tscn`
2. Rename the duplicate descriptively — `test_time_slow.tscn`,
   `test_nano_spread.tscn`, `test_clone_ai.tscn`
3. Modify the duplicate freely

**For real game levels:**
The same template provides navigation, spawn points, and border collision
as a starting skeleton. Replace the ColorRect floor with a TileMap and
placeholder obstacles with real environment art. The structural foundation
is already in place.
