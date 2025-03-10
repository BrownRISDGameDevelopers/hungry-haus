extends Control

class_name Puzzle

@onready var player: Player = get_tree().get_first_node_in_group("player")

const APPEAR_DURATION_SEC : float = 0.5
const COLOR_VISIBLE : Color = Color(1,1,1,1)
const COLOR_TRANSPARENT : Color = Color(1,1,1,0)

var puzzle_active : bool = false

func _ready():
	modulate = Color(1,1,1,0)

func _input(event):
	if event.is_action_pressed("interact"):
		toggle_puzzle_active()
	else:
		pass

func toggle_puzzle_active():
	if !puzzle_active:
		Global.safe_tween(self).tween_property(self, "modulate", COLOR_VISIBLE, APPEAR_DURATION_SEC)
		puzzle_active = true
		player.open_puzzle()
	else:
		Global.safe_tween(self).tween_property(self, "modulate", COLOR_TRANSPARENT, APPEAR_DURATION_SEC)
		puzzle_active = false
		player.close_puzzle()
