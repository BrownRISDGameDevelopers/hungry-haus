extends Node

func _play(sound : String):
	if find_child(sound):
		find_child(sound).play()
	else: print("couldnt find ", sound)

func stop(sound : String):
	if find_child(sound):
		var player : AudioStreamPlayer = find_child(sound)
		player.stop()
	else: print("couldnt find ", sound)
