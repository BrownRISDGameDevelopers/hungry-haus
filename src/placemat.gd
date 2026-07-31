extends KitchenPuzzle
func _on_x_button_pressed() -> void:
	toggle_puzzle_off()

func _input(event):
	if event.is_action_pressed("pause"):
		_on_x_button_pressed()
