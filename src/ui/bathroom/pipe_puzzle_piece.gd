extends TextureButton

class_name PipePuzzlePiece

## Emitted after this piece is rotated.
signal rotated

## Describes the current direction of the piece's rotation 
##  (not necessarily the actual rotation, since visuals could be transitioning)
enum Rotation {
	ROT_0,
	ROT_90,
	ROT_180,
	ROT_270,
}

# Unrotated pipes will be correctly connected
const WINNING_ROTATION = Rotation.ROT_0 

var rot_state : Rotation = Rotation.ROT_0

## Rotates the piece, changing its rotation state. Called on click
func rotate_clockwise():
	# Increment rotation state
	rot_state = ((rot_state + 1) % 4) as Rotation
	# Rotate visuals to current state using a tween
	var goal_rot = int(rot_state) * (PI / 2)
	var tween = Global.safe_tween(self)
	tween.tween_property(self, "rotation", goal_rot, 0.3)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	# Cause a check for victory
	rotated.emit()

## Rotates the piece to a random rotation different than its current rotation state.
## Used on initialization to scramble the puzzle
func rotate_randomly():
	var num_rotations = randi_range(1, 3)
	for i in range(num_rotations):
		rotate_clockwise()
