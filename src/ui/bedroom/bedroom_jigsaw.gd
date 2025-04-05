extends Puzzle

class_name BedroomJigsaw

const GRID_SIZE : int = 40
const NUM_ROWS : int = 3
const NUM_COLUMNS : int = 4

var puzzle_array : Array[Array] = []

@onready var puzzle_container : Control = %PuzzleContainer

func _ready():
	#setup_puzzle()
	room_type = Room.Type.BEDROOM

			
			
