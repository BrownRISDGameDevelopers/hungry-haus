extends Area2D
# Add Area2d PaintingSlots where paintings that overlap with them move towards the closest one upon release. 
# Each painting slot can hold a painting of a certain type, and can be validated for victory.  
class_name PaintingSlot

signal winning

var child_painting : Painting

@export var correct_painting_type : Painting.Type

func receive_painting(painting : Painting):
	assert(child_painting == null)
	child_painting = painting
	child_painting.sent_to_inv.connect(remove_painting)
	child_painting.rotated.connect(emit_if_winning)
	emit_if_winning()

func remove_painting() -> Painting:
	var old_painting = child_painting
	if child_painting:
		child_painting.sent_to_inv.disconnect(remove_painting)
		child_painting.rotated.disconnect(emit_if_winning)
	child_painting = null
	
	return old_painting

func is_winning() -> bool:
	return child_painting and \
		child_painting.type == correct_painting_type and \
		child_painting.rot_state == Painting.Rotation.ROT_0

func emit_if_winning():
	print("calling emit_if_winning: ", self)
	if is_winning(): winning.emit()

func has_painting():
	return child_painting != null
