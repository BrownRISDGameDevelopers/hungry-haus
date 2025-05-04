extends Control

class_name Puzzle

#region Signals
## Called when this puzzle is completed by the player.
signal completed
#endregion Signals

enum Type {
	KITCHEN_FRIDGE,
	KITCHEN_GOOD_NOTE,
	KITCHEN_BAD_NOTE,
	BEDROOM_PAINTING,
	BEDROOM_PADLOCK,
	BATHROOM_PIPES,
	KITCHEN_PLACEMAT
}

@export var puzzle_type : Type

@export var room_type : Room.Type
@export var force_visible := false

@onready var player: Player = get_tree().get_first_node_in_group("player")

const APPEAR_DURATION_SEC : float = 0.5
const COLOR_VISIBLE : Color = Color(1,1,1,1)
const COLOR_TRANSPARENT : Color = Color(1,1,1,0)

var puzzle_active : bool = false
var already_complete := false

func _ready():
	visible = false
	modulate = COLOR_TRANSPARENT
	if force_visible:
		visible = true
		modulate = COLOR_VISIBLE

func _input(event):
	if event.is_action_pressed("dev_interact"):
		var tween = Global.safe_tween(self)
		tween.tween_property(self, "modulate", COLOR_TRANSPARENT, APPEAR_DURATION_SEC)
		tween.tween_property(self, "visible", false, 0.0)
		puzzle_active = false
		player.close_puzzle()

func toggle_puzzle_active():
	if not puzzle_active and room_type == GlobalState.current_room:
		var tween = Global.safe_tween(self)
		tween.tween_property(self, "modulate", COLOR_VISIBLE, APPEAR_DURATION_SEC)
		visible = true
		puzzle_active = true
		player.open_puzzle()
		on_open()
		print("opening puzzle")
	elif puzzle_active:
		var tween = Global.safe_tween(self)
		tween.tween_property(self, "modulate", COLOR_TRANSPARENT, APPEAR_DURATION_SEC)
		tween.tween_property(self, "visible", false, 0.0)
		puzzle_active = false
		player.close_puzzle()


func toggle_puzzle_off():
	if puzzle_active:
		var tween = Global.safe_tween(self)
		tween.tween_property(self, "modulate", COLOR_TRANSPARENT, APPEAR_DURATION_SEC)
		tween.tween_property(self, "visible", false, 0.0)
		puzzle_active = false
		player.close_puzzle()
	
	
## Overridden for on-open functionality
func on_open():
	pass

func complete():
	if not already_complete: # Can only be completed once
		completed.emit()
		already_complete = true
