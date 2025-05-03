extends Node3D

class_name InteractableObject

var highlighted: bool

@export var mesh : MeshInstance3D

## The puzzle opened by this object on click.
@onready var puzzle: Puzzle = get_tree().get_first_node_in_group("bedroom_puzzle")




## Create exprot htat lets you set puzzle enum
## Setup puzzle enum in Global



@export var highlightColor: Vector4 = Vector4(1, 1, 0.2, 1)
@export var highlightSize: float = 1.01

func _ready() -> void:
	highlighted = false

func _process(_delta: float) -> void:
	# Update highlighting
	var looked: bool = Player.player.is_looking_at(mesh)
	if highlighted != looked:
		if highlighted:
			Global.hide_3d_outline(mesh)
		else:
			Global.show_3d_outline(mesh, highlightColor, highlightSize)
		highlighted = looked

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		interact()

## Opens this interactable's puzzle if it's highlighted.
func interact() -> void:
	if puzzle and highlighted and not puzzle.puzzle_active:
		puzzle.toggle_puzzle_active()
