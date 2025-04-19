extends Area2D
# Add Area2d PaintingSlots where paintings that overlap with them move towards the closest one upon release. 
# Each painting slot can hold a painting of a certain type, and can be validated for victory.  
class_name PaintingSlot

var child_painting : Painting

func receive_painting(painting : Painting):
	assert(child_painting == null)
	child_painting = painting
	child_painting.sent_to_inv.connect(remove_painting)

func remove_painting() -> Painting:
	var old_painting = child_painting
	if child_painting:
		child_painting.sent_to_inv.disconnect(remove_painting)
	child_painting = null
	
	return old_painting
	

func has_painting():
	return child_painting != null
