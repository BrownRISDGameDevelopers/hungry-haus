extends Node3D

class_name Room

enum Type {
	KITCHEN,
	BEDROOM,
	BATHROOM,
	END,
}

## Emitted when all puzzles in this room are completed.
signal puzzles_completed

## The puzzles to complete in this room.
## When all are completed, the room's door opens.
var puzzles : Array[Puzzle]

## The number of puzzles completed so far.
var completed_count := 0

## This room's door, which opens when all puzzles are completed.
var door : Door

@export var type : Type

func _ready() -> void:
	# Populate puzzles 
	for puzzle in [
		get_tree().get_first_node_in_group("kitchen_puzzle"), 
		get_tree().get_first_node_in_group("bedroom_puzzle"), # TODO add code lock puzzle
		get_tree().get_first_node_in_group("bathroom_puzzle"), 
	]:
		if puzzle.room_type == type:
			puzzles.append(puzzle)
			# Make each puzzle increment a count when it's completed
			puzzle.completed.connect(complete_one_puzzle)
	# Populate door
	for child in get_children():
		if child is Door:
			door = child
	# Make door open when puzzles are all completed
	puzzles_completed.connect(door.open)

# USE TO TEST IF DOORS OPEN
func _unhandled_input(event):
	if event.is_action_pressed("jump"):
		puzzles_completed.emit()
	

func complete_one_puzzle():
	completed_count += 1
	if completed_count == puzzles.size():
		puzzles_completed.emit()
		GlobalState.move_to_next_room()

	
