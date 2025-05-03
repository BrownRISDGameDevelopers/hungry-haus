extends Control


func _on_start_pressed() -> void:
	play_intro_cutscene()


func play_intro_cutscene():
	# Disable all buttons
	# Move camera towards doorway and
	# Fade to black
	# Slap ID card down
	get_tree().change_scene_to_file("res://src/Game.tscn")

func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_credits_pressed() -> void:
	pass # Replace with function body.
