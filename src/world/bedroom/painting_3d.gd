extends InteractableObject

class_name Painting_3D

var collected := false

@export var type : Painting.Type

@export var paintingSprite : Sprite3D

func interact() -> void:
	if puzzle and highlighted and not puzzle.puzzle_active and not collected:
		puzzle.add_to_inventory(type)
		print(puzzle.inventory)
		collected = true
		paintingSprite.hide()
