extends Puzzle

class_name BathroomPuzzle

var pipe_pieces : Array[PipePuzzlePiece]

func _ready() -> void:
	super._ready()
	room_type = Room.Type.BATHROOM
	# Populate pipe_pieces
	for child in get_children():
		if child is PipePuzzlePiece:
			pipe_pieces.append(child)
			child.rotated.connect(check_victory)

func scramble_pieces():
	for pipe : PipePuzzlePiece in pipe_pieces:
		pipe.rotate_randomly()

## Called after each pipe rotation.
## Checks whether all pipes are rotated to 0 degrees. 
## If so, disables all buttons.
func check_victory():
	for pipe : PipePuzzlePiece in pipe_pieces:
		if pipe.rot_state != PipePuzzlePiece.WINNING_ROTATION:
			return false
	return true
