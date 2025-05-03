extends InteractableObject

class_name Painting_3D

var collected := false

@export var type : Painting.Type

@export var paintingSprite : Sprite3D
@export var paintingOverlayGood : Sprite3D
@export var paintingOverlayEvil : Sprite3D

func _ready():
	paintingSprite.frame = type
	paintingOverlayGood.frame = type
	paintingOverlayEvil.frame = type

func interact() -> void:
	if puzzle and highlighted and not puzzle.puzzle_active and not collected:
		puzzle.add_to_inventory(type)
		print(puzzle.inventory)
		collected = true
		paintingSprite.hide()
