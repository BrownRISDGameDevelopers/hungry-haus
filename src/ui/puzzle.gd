extends Control

class_name Puzzle

var puzzle_active : bool = false
var opaque : Color = Color(1,1,1,1)
var clear : Color = Color(1,1,1,0)

func _ready():
	modulate = Color(1,1,1,0)

func _input(event):
	if event.is_action_pressed("interact"):
		ToggleVisibility()
	else:
		pass

func ToggleVisibility():
	if puzzle_active:
		modulate = clear
		puzzle_active = false
	else:
		modulate = opaque
		puzzle_active = true
