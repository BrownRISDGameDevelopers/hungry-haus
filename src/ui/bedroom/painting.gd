extends Sprite2D

# Painting class: has overlaid sprite sheets: 
# 1. happy painting
# 2. scratches (normal view)
# 3. numbers (blood view)
# Has drag-and-drop, left click to rotate
class_name Painting


enum Rotation {
	ROT_0,
	ROT_90,
	ROT_180,
	ROT_270,
}


enum Type {
	IMG_0,
	IMG_1,
	IMG_2,
	IMG_3,
	IMG_4,
	IMG_5,
	NUM_TYPES
	# TODO add names of each painting
}

## True when the mouse is inside of the painting
var hovering := false

## True when the mouse is holding left click inside the painting
var holding := false

## True when the mouse is moving the painting
var dragging := false

## Ignores all inputs when false. Used while tweening positions and after puzzle's done.
var interactable := true

## The vector offset from the center at which the mouse originally grabbed the object.
var mouse_offset : Vector2

@onready var scratches: AnimatedSprite2D = $Scratches
@onready var numbers: AnimatedSprite2D = $Numbers
@onready var hitbox: Area2D = $Hitbox

## The minimum distance dragged before a rotation input turns to a drag input.
const MIN_DRAG_DIST := 10.0

## The location where the current drag action started.
var root_pos : Vector2

## The inventory position where the painting starts out.
var inventory_pos : Vector2

func _ready() -> void:
	inventory_pos = global_position

## On hover, wiggle the painting left and right to show it can be rotated on click
func hover():
	hovering = true
	print("hovered")

## On unhover, stop hover animations
func unhover():
	hovering = false
	print("unhovered")

func begin_drag():
	dragging = true
	print("beginning drag")

## On mouse down, begin holding the piece and capture mouse offset
func press():
	holding = true
	mouse_offset = get_local_mouse_position()
	root_pos = global_position
	print("pressing")

## On mouse release, if mouse travelled more than x pixels, drop; otherwise, rotate
func release():
	if dragging: 
		drop()
	holding = false
	dragging = false
	print("released")

## Place the painting into a nearby slot, or back in inventory if none is in contact
func drop():
	var closest_slot : PaintingSlot
	var closest_dist_sqrd := 999999.0
	
	# Search for closest painting slot to drop into
	for slot : PaintingSlot in hitbox.get_overlapping_bodies():
		var dist_sqrd = global_position.distance_squared_to(slot.global_position)
		if dist_sqrd < closest_dist_sqrd:
			closest_slot = slot
			closest_dist_sqrd = dist_sqrd
	
	# Drop into it if possible, otherwise 
	if closest_slot:
		interactable = false
		var drop_tween = Global.safe_tween(self)
		drop_tween.tween_property(self, "global_position", closest_slot.global_position, 0.3)\
			.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		drop_tween.tween_property(self, "interactable", true, 0.0)
		
		# Tell the slot it has a new painting, swapping the currently held one to inventory
		var old_painting = closest_slot.remove_painting()
		if old_painting:
			old_painting.interactable = false
			var old_to_inv_tween = Global.safe_tween(old_painting)
			old_to_inv_tween.tween_property(old_painting, "global_position", old_painting.inventory_pos, 0.3)\
				.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			old_to_inv_tween.tween_property(old_painting, "interactable", true, 0.0)
	else: # Return it to the inventory
		interactable = false
		var drop_tween = Global.safe_tween(self)
		drop_tween.tween_property(self, "global_position", inventory_pos, 0.3)\
			.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		drop_tween.tween_property(self, "interactable", true, 0.0)

func _process(delta: float) -> void:
	if not dragging and root_pos and global_position.distance_to(root_pos) > MIN_DRAG_DIST:
		begin_drag()
	if dragging:
		global_position = get_global_mouse_position() - mouse_offset

func _input(event: InputEvent) -> void:
	if interactable and hovering:
		if event.is_action_pressed("interact"):
			press()
		if event.is_action_released("interact"):
			release()

func _on_hitbox_mouse_entered() -> void:
	hover()

func _on_hitbox_mouse_exited() -> void:
	unhover()
