extends Node

func _play(sound : String):
	if find_child(sound):
		find_child(sound).play()
	else: print("couldnt find ", sound)
