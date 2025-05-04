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
var winning_rotation : Rotation

var rot_state : Rotation

@export var isStraight : bool = false

func _ready():
	pressed.connect(_on_pressed)
	
	if rotation < 0:
		rotation += TAU
	rot_state = int(rotation/(PI/2))
	
	winning_rotation = rot_state
	
	#for i in range(randi_range(1,3)):
		#rotate_clockwise()
	

## Rotates the piece, changing its rotation state. Called on click
func rotate_clockwise():
	# Increment rotation state
	rot_state = ((rot_state + 1) % 4) as Rotation
	# Rotate visuals to current state using a tween
	var goal_rot = int(rot_state) * (PI / 2)
	var tween = Global.safe_tween(self)
	tween.tween_property(self, "rotation", lerp_angle(rotation, goal_rot, 1.0), 0.3)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	# Cause a check for victory
	rotated.emit()

## Rotates the piece to a random rotation different than its current rotation state.
## Used on initialization to scramble the puzzle
func rotate_randomly():
	var num_rotations = randi_range(1, 3)
	for i in range(num_rotations):
		rotate_clockwise()

func _on_pressed():
	rotate_clockwise()
