extends Node

func _ready():
    print("=== INPUT MAP TEST ===")
    print("Connected pads: ", Input.get_connected_joypads())

func _process(_delta):
    var move = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    var aim  = Input.get_vector("aim_left",  "aim_right",  "aim_up",  "aim_down")

    if move.length() > 0.1:
        print("Move: (%.2f, %.2f)" % [move.x, move.y])
    if aim.length() > 0.1:
        print("Aim:  (%.2f, %.2f)" % [aim.x, aim.y])

func _input(event):
    if event.is_action_pressed("dash"):
        print("DASH triggered")
    if event.is_action_pressed("attack"):
        print("ATTACK triggered")
    if event.is_action_pressed("parry"):
        print("PARRY triggered")
