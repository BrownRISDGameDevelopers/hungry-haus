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


func _ready() -> void:
	# Populate puzzles and door
	for child in get_children():
		if child is Puzzle:
			puzzles.append(child)
			# Make each puzzle increment a count when it's completed
			child.completed.connect()
		if child is Door:
			door = child
	# Make door open when puzzles are all completed
	puzzles_completed.connect(door.open)
	
	

func complete_one_puzzle():
	completed_count += 1
	if completed_count == puzzles.size():
		puzzles_completed.emit()
		GlobalState.move_to_next_room()

	
