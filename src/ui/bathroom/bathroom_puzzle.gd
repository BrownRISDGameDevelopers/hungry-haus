extends Puzzle

class_name BathroomPuzzle

var pipe_pieces : Array[PipePuzzlePiece]

const GRID_SIZE := 40

func _ready() -> void:
	super._ready()
	room_type = Room.Type.BATHROOM
	# Populate pipe_pieces
	for parent in get_children():
		for child in parent.get_children():
			if child is PipePuzzlePiece:
				pipe_pieces.append(child)
				child.rotated.connect(check_victory)
				#child.pivot_offset = Vector2(GRID_SIZE/2, GRID_SIZE/2)
	#scramble_pieces()

func scramble_pieces():
	for pipe : PipePuzzlePiece in pipe_pieces:
		pipe.rotate_randomly()

## Called after each pipe rotation.
## Checks whether all pipes are rotated to 0 degrees. 
## If so, disables all buttons.
func check_victory():
	for pipe : PipePuzzlePiece in pipe_pieces:
		if pipe.isStraight:
			if pipe.rot_state % 2 != pipe.winning_rotation % 2:
				return false
		else:
			if pipe.rot_state != pipe.winning_rotation:
				return false
	show_victory()
	return true

func show_victory():
	var tween = Global.safe_tween(self)
	mouse_filter = Control.MOUSE_FILTER_IGNORE # Don't let user close the puzzle
	tween.tween_property(self, "scale", Vector2(1.05, 1.05), 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(self, "modulate", Color(1.0, 0.5, 0.5), 3.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(toggle_puzzle_active)


func _on_x_button_pressed() -> void:
	toggle_puzzle_off()
