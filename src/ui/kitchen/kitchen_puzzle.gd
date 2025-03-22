extends Puzzle

class_name KitchenPuzzle

const GRID_SIZE : int = 40
const NUM_ROWS : int = 4
const NUM_COLUMNS : int = 3

enum FridgeItem {
	NONE,
	JELLO,
	ORANGE_JUICE,
	HAM,
	PRODUCE,
	EGGS,
	PICKLES,
	MILK,
	PASTA,
	BAKING_SODA,
}

var puzzle_array : Array[Array] = []

const VICTORY_LAYOUT : Array[Array] = [
	[FridgeItem.NONE, FridgeItem.JELLO, FridgeItem.NONE],
	[FridgeItem.ORANGE_JUICE, FridgeItem.HAM, FridgeItem.PRODUCE],
	[FridgeItem.EGGS, FridgeItem.EGGS, FridgeItem.PICKLES],
	[FridgeItem.MILK, FridgeItem.PASTA, FridgeItem.BAKING_SODA],
]

## Only the slide puzzle 
var eggs_items : Array[SlidePuzzlePiece]

@onready var puzzle_container : Control = %PuzzleContainer

func _ready():
	super._ready()
	setup_puzzle()
	eggs_items = get_eggs()
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
	if piece.type != FridgeItem.EGGS:
		# CHECK FOR NULL NEIGHBOR
		var null_neighbor : Vector2i = get_null_neighbors(row, column)
		if null_neighbor == Vector2i(-1,-1): return
		var null_row = null_neighbor.x
		var null_column = null_neighbor.y
		
		# SET PIECE NEW POSITION
		#piece.position = Vector2(null_column*GRID_SIZE, null_row*GRID_SIZE)
		var tween = Global.safe_tween(piece)
		tween.tween_property(piece, "position", Vector2(null_column*GRID_SIZE, null_row*GRID_SIZE), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		
		# UPDATE PUZZLE ARRAY
		puzzle_array[row][column] = null
		puzzle_array[null_row][null_column] = piece
	else:
		# SPECIAL EGGS TREATMENT (unrotatable 2x1 object; requires 2 spaces on top but 1 horizontally)
		var right_eggs = get_other_egg_piece(piece)
		
		# CHECK FOR EGGS NULL NEIGHBORS (left eggs' hitbox covers right eggs and will be clicked first)
		var left_pos = Vector2i(row, column)
		var right_pos = Vector2i(row, column + 1)
		var left_null_neighbor : Vector2i = get_null_neighbors(row, column)
		var right_null_neighbor : Vector2i = get_null_neighbors(row, column + 1) # right eggs
		var left_diff = (left_null_neighbor - left_pos) if left_null_neighbor != Vector2i(-1,-1) else Vector2i(-1,-1)
		var right_diff = (right_null_neighbor - right_pos) if right_null_neighbor != Vector2i(-1,-1) else Vector2i(-1,-1)
		print("left diff = ", left_diff)
		print("right diff = ", right_diff)
		var movement_dir : Vector2i
		if left_diff == Vector2i(-1,-1) and right_diff == Vector2i(-1,-1): # Both empty
			return
		elif left_diff == Vector2i(0,-1): # Left slot open
			movement_dir = Vector2i(0, -1)
		elif right_diff == Vector2i(0,1): # Right slot open
			movement_dir = Vector2i(0, 1)
		elif left_diff == Vector2i(-1, 0) and right_diff == Vector2i(-1, 0): # Two upper slots open
			movement_dir = Vector2i(-1, 0)
		elif left_diff == Vector2i(1, 0) and right_diff == Vector2i(1, 0): # Two lower slots open
			movement_dir = Vector2i(1, 0)
		else:
			return
		var null_row = row + movement_dir.x
		var null_column = column + movement_dir.y
		
		# SET PIECE NEW POSITION
		#piece.position = Vector2(null_column*GRID_SIZE, null_row*GRID_SIZE)
		var left_tween = Global.safe_tween(piece)
		left_tween.tween_property(piece, "position", Vector2(null_column*GRID_SIZE, null_row*GRID_SIZE), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		var right_tween = Global.safe_tween(right_eggs)
		right_tween.tween_property(right_eggs, "position", Vector2((null_column + 1)*GRID_SIZE, null_row*GRID_SIZE), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		
		# UPDATE PUZZLE ARRAY
		puzzle_array[row][column] = null
		puzzle_array[row][column + 1] = null
		puzzle_array[null_row][null_column] = piece
		puzzle_array[null_row][null_column + 1] = right_eggs
	
	# CHECK FOR VICTORY
	check_victory()

func get_null_neighbors(row : int, column : int) -> Vector2i:
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


func check_victory():
	for i in range(NUM_ROWS):
		for j in range(NUM_COLUMNS):
			var type = FridgeItem.NONE if not puzzle_array[i][j] else puzzle_array[i][j].type
			if type != VICTORY_LAYOUT[i][j]:
				print("not victory")
				return false
	print("victory!")
	return true


func get_eggs():
	var eggs : Array[SlidePuzzlePiece] = []
	var found_all := false
	for i in range(NUM_ROWS):
		for j in range(NUM_COLUMNS):
			var item : SlidePuzzlePiece = puzzle_array[i][j]
			if not found_all and item and item.type == FridgeItem.EGGS:
				eggs.append(item)
	return eggs

func get_other_egg_piece(first_egg_piece : SlidePuzzlePiece):
	for egg in eggs_items:
		if egg != first_egg_piece:
			return egg
