extends MeshInstance3D

var highlighted: bool

## The puzzle opened by this object on click.
@onready var puzzle: Puzzle = get_tree().get_first_node_in_group("kitchen_puzzle")

@export var highlightColor: Vector4 = Vector4(1, 1, 0, 1)
@export var highlightSize: float = 1.01

func _ready() -> void:
	highlighted = false

func _process(delta: float) -> void:
	# Update highlighting
	var looked: bool = Player.player.is_looking_at(self)
	if highlighted != looked:
		if highlighted:
			Global.hide_3d_outline(self)
		else:
			Global.show_3d_outline(self, highlightColor, highlightSize)
		highlighted = looked

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		try_open_puzzle()

## Opens this interactable's puzzle if it's highlighted.
func try_open_puzzle() -> void:
	if puzzle and highlighted and not puzzle.puzzle_active:
		puzzle.toggle_puzzle_active()
