extends Control

@onready var player: Player = get_tree().get_first_node_in_group("player")

var interactable: bool = false
var opened_frame: int = -1

func open():
	self.visible = true
	interactable = true
	opened_frame = Engine.get_process_frames()
	
func close():
	self.visible = false
	interactable = false

func _on_restart_button_pressed() -> void:
	close()
	GlobalState.back_to_menu()

func _on_x_button_pressed() -> void:
	get_viewport().set_input_as_handled()
	close()
	player.close_puzzle()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if not interactable:
			return
		
		get_viewport().set_input_as_handled()
		
		if Engine.get_process_frames() == opened_frame:
			return
				
		_on_x_button_pressed()
