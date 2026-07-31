extends Sprite2D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_blood_vision"):
		self_modulate = Color(1, 1, 0.2, 1)
	
	if event.is_action_released("toggle_blood_vision"):
		self_modulate = Color.WHITE
