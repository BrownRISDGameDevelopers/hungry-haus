extends Puzzle

class_name BedroomPuzzle

@export var inventory_ui : Sprite2D


# Steps:
# Add an inventory: array of paintings
var inventory = []


func _ready() -> void:
	inventory_ui.hide()
	super._ready()
	room_type = Room.Type.BEDROOM
	inventory.resize(Painting.Type.NUM_TYPES)
	for i in inventory.size(): inventory[i] = false

func add_to_inventory(pntng : Painting.Type):
	inventory[pntng] = true
	if !inventory_ui.visible:
		inventory_ui.show()
	elif inventory_ui.frame < 6:
		inventory_ui.frame += 1

# Painting class: has overlaid sprite sheets: 
# 1. happy painting
# 2. scratches (normal view)
# 3. numbers (blood view)
# Store victory layout: two 2d arrays, of Types and of Rotations
# Upon opening puzzle, make paintings *in inventory* visible
# On ready, make them invisible
# Add Area2d PaintingSlots where paintings that overlap with them move towards the closest one upon release. 
# Each painting slot can hold a painting of a certain type, and can be validated for victory.  
