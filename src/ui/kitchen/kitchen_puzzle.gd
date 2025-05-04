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

@export var solved_bg : TextureRect

@export var puzzle_container : Control

@onready var organs : Array = get_tree().get_nodes_in_group("fridge_organ")
@onready var foods : Array = get_tree().get_nodes_in_group("fridge_food")

func _ready():
	super._ready()
	setup_puzzle()
	eggs_items = get_eggs()
	room_type = Room.Type.KITCHEN
	for organ : TextureRect in organs:
		organ.hide()

func setup_puzzle():
	for row in range(NUM_ROWS):
		var row_array = []
		for col in range(NUM_COLUMNS):
			var piece : SlidePuzzlePiece = get_puzzle_piece(row, col)
			row_array.append(piece)
			if piece:
				piece.button_pressed_signal.connect(slide_piece)
				piece.button_released_signal.connect(reconnect_piece)
		puzzle_array.append(row_array)
	# print(puzzle_array)

func get_puzzle_piece(y_position : int, x_position : int):
	var target_position : Vector2 = Vector2(x_position * GRID_SIZE, y_position * GRID_SIZE)

	if !puzzle_container: puzzle_container = get_tree().get_first_node_in_group("puzzle_container")

	for child in puzzle_container.get_children():
		if child is not SlidePuzzlePiece:
			continue
		# print(child.position, " | ", target_position)
		if (child.position == target_position):
			return child
	return null

# LIL FUNCTY FOR SLIDING NORMAL PIECE
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
		var null_neighbor : Array[Vector2i] = get_null_neighbors(row, column)
		if (null_neighbor[0] == Vector2i(0,0) && null_neighbor[1] == Vector2i(0,0)): return
		
		piece.set_active_piece(null_neighbor)
		print("null cols: ", null_neighbor[0])
		print("null rows: ", null_neighbor[1])
	else:
		slide_egg_piece(piece, row, column)
	
# BRUTAL FUCNTION FOR SLIDING EGG PIECE WTF
func slide_egg_piece(piece : SlidePuzzlePiece, row : int, column : int):
	# SPECIAL EGGS TREATMENT (unrotatable 2x1 object; requires 2 spaces on top but 1 horizontally)
	var right_eggs = get_other_egg_piece(piece)
	
	# CHECK FOR EGGS NULL NEIGHBORS (left eggs' hitbox covers right eggs and will be clicked first)
	var left_pos = Vector2i(row, column)
	var right_pos = Vector2i(row, column + 1)
	var left_null_neighbor : Vector2i = get_null_neighbors_old(row, column)
	var right_null_neighbor : Vector2i = get_null_neighbors_old(row, column + 1) # right eggs
	var left_diff = (left_null_neighbor - left_pos) if left_null_neighbor != Vector2i(-1,-1) else Vector2i(-1,-1)
	var right_diff = (right_null_neighbor - right_pos) if right_null_neighbor != Vector2i(-1,-1) else Vector2i(-1,-1)
	# print("left diff = ", left_diff)
	# print("right diff = ", right_diff)
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

	check_victory()

# ONLY FOR NORMAL PIECES W 2 WAY SLIDE
func reconnect_piece(piece : SlidePuzzlePiece, moveDirection : Vector2i):

	var row : int
	var column : int
	for r in range(NUM_ROWS):
		for c in range(NUM_COLUMNS):
			if puzzle_array[r][c] == piece:
				row = r
				column = c
	
	if (moveDirection == Vector2i.ZERO):
		return;
	
	puzzle_array[row][column] = null

	var releasePosition : Vector2 = piece.position

	if (moveDirection.y == 0):
		puzzle_array[row][column + moveDirection.x] = piece
		releasePosition = Vector2((column + moveDirection.x)*GRID_SIZE, (row)*GRID_SIZE)
	else:
		puzzle_array[row + moveDirection.y][column] = piece
		releasePosition = Vector2((column)*GRID_SIZE, (row + moveDirection.y)*GRID_SIZE)

	var tween = Global.safe_tween(piece)
	tween.tween_property(piece, "position", Vector2(releasePosition.x, releasePosition.y), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	# THIS NEEDS TO RECIEVE PIECE'S NEW POSITION, AND MOVE IT IN THE ACTUAL ARRAY
	check_victory()

func get_null_neighbors(row : int, column : int) -> Array[Vector2i]:

	var null_cols : Vector2i = Vector2i(0,0) # LEFT, RIGHT
	var null_rows : Vector2i = Vector2i(0,0) # TOP, BOTTOM

	var positions : Array = [-1, 1]
	for i in range(2):
		var target_column = column + positions[i]
		var target_row = row + positions[i]
		
		# CHECK IF NULL NEIGHBOR TO LEFT OR RIGHT
		if not (target_column >= NUM_COLUMNS || target_column < 0):
			if not puzzle_array[row][target_column]:
				null_cols[i] = 1
		
		# CHECK IF NULL NEIGHBOR ABOVE OR BELOW
		if not (target_row >= NUM_ROWS || target_row < 0):
			if not puzzle_array[target_row][column]:
				null_rows[i] = 1
	
	return [null_cols, null_rows]

func get_null_neighbors_old(row : int, column : int) -> Vector2i:
	var positions : Array = [-1, 1]
	for i in range(2):
		var target_column = column + positions[i]
		var target_row = row + positions[i]
		
		# CHECK IF NULL NEIGHBOR TO LEFT OR RIGHT
		if not (target_column >= NUM_COLUMNS || target_column < 0):
			if not puzzle_array[row][target_column]:
				return Vector2i(row, target_column)
		
		# CHECK IF NULL NEIGHBOR ABOVE OR BELOW
		if not (target_row >= NUM_ROWS || target_row < 0):
			if not puzzle_array[target_row][column]:
				return Vector2i(target_row, column)
	return Vector2(-1,-1)


func check_victory():
	for i in range(NUM_ROWS):
		for j in range(NUM_COLUMNS):
			var type = FridgeItem.NONE if not puzzle_array[i][j] else puzzle_array[i][j].type
			if type != VICTORY_LAYOUT[i][j]:
				match type:
					FridgeItem.PRODUCE: if VICTORY_LAYOUT[i][j] != FridgeItem.ORANGE_JUICE: return false
					FridgeItem.ORANGE_JUICE: if VICTORY_LAYOUT[i][j] != FridgeItem.PRODUCE: return false
					FridgeItem.MILK: if VICTORY_LAYOUT[i][j] != FridgeItem.BAKING_SODA: return false
					FridgeItem.BAKING_SODA: if VICTORY_LAYOUT[i][j] != FridgeItem.MILK: return false
					_:
						return false
	show_victory()
	complete()
	if solved_bg:
		var tween = Global.safe_tween(solved_bg)
		tween.tween_property(solved_bg, "modulate", Color.WHITE, 0.8)
	return true

func show_victory():
	var tween = Global.safe_tween(self)
	mouse_filter = Control.MOUSE_FILTER_IGNORE # Don't let user close the puzzle
	tween.tween_property(self, "scale", Vector2(1.05, 1.05), 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(self, "modulate", Color(1.0, 0.8, 0.8), 3.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	for i in range(len(organs)):
		var organ : TextureRect = organs[i]
		var food : TextureButton = foods[i]
		organ.modulate = COLOR_TRANSPARENT
		organ.visible = true
		food.disabled = true
		tween.parallel().tween_property(organ, "modulate", COLOR_VISIBLE, 0.25).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		tween.parallel().tween_property(food, "self_modulate", COLOR_TRANSPARENT, 0.25).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(toggle_puzzle_active) 

# Get the eggs
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
