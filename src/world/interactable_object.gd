extends Node3D

class_name InteractableObject

var highlighted: bool

@export var puzzle_type : Puzzle.Type = Puzzle.Type.BEDROOM_PAINTING
@export var mesh : MeshInstance3D

## The puzzle opened by this object on click.
@onready var puzzle: Puzzle # = get_tree().get_first_node_in_group("kitchen_puzzle")

## Create exprot htat lets you set puzzle enum
## Setup puzzle enum in Global

@export var highlightColor: Color = Color(1, 1, 0.2, 1)
@export var highlightSize: float = 1.01
@export var thresh_modifier := 1.0

func _ready() -> void:
	highlighted = false

	for p in get_tree().get_nodes_in_group("puzzle"):
		if p.puzzle_type == puzzle_type:
			puzzle = p
	if !puzzle:
		print("Missing puzzle: ", puzzle_type)

func _process(_delta: float) -> void:
	# Update highlighting
	var looked: bool = Player.player.is_looking_at(mesh, thresh_modifier)
	if highlighted != looked:
		if highlighted:
			Global.hide_3d_outline(mesh)
		else:
			Global.show_3d_outline(mesh, highlightColor, highlightSize)
		highlighted = looked

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") && visible && get_parent().visible && highlighted:
		interact()

## Opens this interactable's puzzle if it's highlighted.
func interact() -> void:
	if puzzle and not puzzle.puzzle_active:
		puzzle.toggle_puzzle_active()
