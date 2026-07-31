extends Node

signal switched_room(to: Room.Type)

var current_room : Room.Type = Room.Type.KITCHEN

func move_to_next_room():
	current_room = (int(current_room) + 1) as Room.Type
	switched_room.emit(current_room)
	print("Moved to: " , current_room)

func lose():
	print("LOST THE GAME!!!!!!!!")
	
	Player.player.lose()

func back_to_menu():
	Player.player.back_to_menu()
