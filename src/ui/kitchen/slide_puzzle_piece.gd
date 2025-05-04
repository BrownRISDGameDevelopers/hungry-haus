extends TextureButton

class_name SlidePuzzlePiece

@export var type : KitchenPuzzle.FridgeItem
 
signal button_pressed_signal(button)
signal button_released_signal(button)

@export var texture_normal_ : Texture2D
@export var texture_hover_ : Texture2D
@export var texture_pressed_ : Texture2D

#func _ready():
	#set_texture_normal(texture_normal_)
	#set_texture_hover(texture_hover_)
	#set_texture_pressed(texture_pressed_)
#
# func _on_pressed():
# 	button_pressed_signal.emit(self)
	#set_texture_hover(texture_normal_)
#
#
#func _on_mouse_entered():
	#set_texture_hover(texture_hover_)

var activePiece : bool = false

var mouseDownPosition : Vector2 = Vector2.ZERO
var currentMousePosition : Vector2 = Vector2.ZERO

var null_cols : Vector2i = Vector2.ZERO
var null_rows : Vector2i = Vector2.ZERO

var origin_position : Vector2

var mouseDiff : Vector2
var moveDirection : Vector2i

func _on_button_down():
	button_pressed_signal.emit(self)
## BUTTON DOWN TRIGGERS BELOW TO BE CALLED FROM KITCHEN SCRIPT:
func set_active_piece(null_neighbor : Array[Vector2i]):
	activePiece = true;
	mouseDownPosition = get_viewport().get_mouse_position()
	null_rows = null_neighbor[1]
	null_cols = null_neighbor[0]
	origin_position = position;

func _on_button_up():
	activePiece = false
	button_released_signal.emit(self, moveDirection)
	moveDirection = Vector2i.ZERO
	SfxPlayer._play("FridgeMoveItem")

func _physics_process(_delta):
	if (activePiece):
		currentMousePosition = get_viewport().get_mouse_position()
		mouseDiff = currentMousePosition - mouseDownPosition
		# print("Current mous diff: ", mouseDiff)

		if (
			# Check if horizontal movement is preferred
			(abs(mouseDiff.x) > abs(mouseDiff.y)) &&
			(
				## Check if moving in dir of null col
				(mouseDiff.x < 0 && null_cols[0] == 1) ||
				(mouseDiff.x > 0 && null_cols[1] == 1)
				# true
			)):
			# HORIZONTAL MOVEMENT
			# print(null_cols)
			position.y = origin_position.y
			position.x = origin_position.x + clamp(mouseDiff.x, -KitchenPuzzle.GRID_SIZE, KitchenPuzzle.GRID_SIZE)
			moveDirection = Vector2i(sign(mouseDiff.x), 0)
		elif (
				## Check if moving in dir of null col
				(mouseDiff.y < 0 && null_rows[0] == 1) ||
				(mouseDiff.y > 0 && null_rows[1] == 1)
				# true
			):
			# print(null_rows)
			position.x = origin_position.x
			position.y = origin_position.y + clamp(mouseDiff.y, -KitchenPuzzle.GRID_SIZE, KitchenPuzzle.GRID_SIZE)
			moveDirection = Vector2i(0, sign(mouseDiff.y))
		else:
			position = origin_position;
			moveDirection = Vector2i.ZERO
