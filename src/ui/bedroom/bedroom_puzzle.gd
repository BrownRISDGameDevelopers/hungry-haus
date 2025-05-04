extends Puzzle

class_name BedroomPuzzle

@export var inventory_ui : Sprite2D


# Steps:
# Add an inventory: array of paintings
var inventory = []
var paintings : Array[Painting] = []
var slots : Array[PaintingSlot] = []

func _ready() -> void:
	if inventory_ui:
		inventory_ui.hide()
	super._ready()
	room_type = Room.Type.BEDROOM
	inventory.resize(Painting.Type.NUM_TYPES)
	for i in inventory.size(): inventory[i] = false
	
	# Get paintings
	for child in get_children():
		if child is Painting:
			paintings.append(child)
		if child is PaintingSlot:
			slots.append(child)
			child.winning.connect(check_victory)

func add_to_inventory(pntng : Painting.Type):
	inventory[pntng] = true
	if !inventory_ui.visible:
		inventory_ui.show()
	elif inventory_ui.frame < 6:
		inventory_ui.frame += 1

## Upon opening puzzle, make paintings *in inventory* visible
func on_open():
	for painting : Painting in get_tree().get_nodes_in_group("painting"):
		# Reveal painting in puzzle if it's stored in inventory
		painting.visible = inventory[painting.type]

func check_victory():
	print("checking victory")
	for slot in slots:
		if not slot.is_winning():
			print("No")
			print()
			return
		else:
			print("Yes")
	
	# Winning
	for painting in paintings:
		painting.interactable = false
		painting.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	show_victory()
	complete()

func show_victory():
	var tween = Global.safe_tween(self)
	#mouse_filter = Control.MOUSE_FILTER_IGNORE # Don't let user close the puzzle
	tween.tween_property(self, "scale", Vector2(1.05, 1.05), 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(self, "modulate", Color(1.0, 0.8, 0.8), 3.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(toggle_puzzle_active) 
	

# Painting class: has overlaid sprite sheets: 
# 1. happy painting
# 2. scratches (normal view)
# 3. numbers (blood view)
# Store victory layout: two 2d arrays, of Types and of Rotations
# Upon opening puzzle, make paintings *in inventory* visible
# On ready, make them invisible
# Add Area2d PaintingSlots where paintings that overlap with them move towards the closest one upon release. 
# Each painting slot can hold a painting of a certain type, and can be validated for victory.  


func _on_x_button_pressed() -> void:
	toggle_puzzle_active()
