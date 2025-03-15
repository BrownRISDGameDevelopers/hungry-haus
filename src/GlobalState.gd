extends Node

var current_room : Room.Type = Room.Type.KITCHEN

func move_to_next_room():
	current_room = (int(current_room) + 1) as Room.Type
