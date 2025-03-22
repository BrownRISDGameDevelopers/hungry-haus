extends Puzzle

class_name KitchenPuzzle

const GRID_SIZE : int = 40
const NUM_ROWS : int = 4
const NUM_COLUMNS : int = 3

# TODO sliding puzzle logic
var puzzle_array : Array[Array] = []

@onready var puzzle_container : Control = %PuzzleContainer

func _ready():
	super._ready()
	setup_puzzle()
	room_type = Room.Type.KITCHEN

func setup_puzzle():
	for row in range(NUM_ROWS):
		var row_array = []
		for col in range(NUM_COLUMNS):
			var piece : SlidePuzzlePiece = get_puzzle_piece(row, col)
			row_array.append(piece)
			if piece:
				piece.button_pressed_signal.connect(slide_piece)
		puzzle_array.append(row_array)
	print(puzzle_array)

func get_puzzle_piece(y_position : int, x_position : int):
	var target_position : Vector2 = Vector2(x_position * GRID_SIZE, y_position * GRID_SIZE)
	for child in puzzle_container.get_children():
		if child is not SlidePuzzlePiece:
			continue
		print(child.position, " | ", target_position)
		if (child.position == target_position):
			return child
	return null

func slide_piece(piece : SlidePuzzlePiece):
	var row : int
	var column : int
	for r in range(NUM_ROWS):
		for c in range(NUM_COLUMNS):
			if puzzle_array[r][c] == piece:
				row = r
				column = c
	# WE HAVE CORRECT ROW AND COLUMN
	
	# CHECK FOR NULL NEIGHBOR
	var null_neighbor : Vector2 = get_null_neighbors(row, column)
	if null_neighbor == Vector2(-1,-1): return
	var null_row = null_neighbor.x
	var null_column = null_neighbor.y
	
	# SET PIECE NEW POSITION
	#piece.position = Vector2(null_column*GRID_SIZE, null_row*GRID_SIZE)
	var tween = Global.safe_tween(piece)
	tween.tween_property(piece, "position", Vector2(null_column*GRID_SIZE, null_row*GRID_SIZE), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	# UPDATE PUZZLE ARRAY
	puzzle_array[row][column] = null
	puzzle_array[null_row][null_column] = piece

func get_null_neighbors(row : int, column : int) -> Vector2:
	var positions : Array = [-1, 1]
	for i in range(2):
		var target_column = column + positions[i]
		var target_row = row + positions[i]
		
		if not (target_column >= NUM_COLUMNS || target_column < 0):
			if not puzzle_array[row][target_column]:
				return Vector2i(row, target_column)
				
		if not (target_row >= NUM_ROWS || target_row < 0):
			if not puzzle_array[target_row][column]:
				return Vector2i(target_row, column)
	return Vector2(-1,-1)
