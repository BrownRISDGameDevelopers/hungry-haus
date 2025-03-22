extends TextureButton

class_name SlidePuzzlePiece

#enum FridgeItem {
	#JELLO,
	#ORANGE_JUICE,
	#HAM,
	#PRODUCE,
	#EGGS,
	#PICKLES,
	#MILK,
	#PASTA,
	#BAKING SODA,
#}

signal button_pressed_signal(button)

@export var texture_normal_ : Texture2D
@export var texture_hover_ : Texture2D
@export var texture_pressed_ : Texture2D

func _ready():
	set_texture_normal(texture_normal_)
	set_texture_hover(texture_hover_)
	set_texture_pressed(texture_pressed_)

func _on_pressed():
	button_pressed_signal.emit(self)
	set_texture_hover(texture_normal_)


func _on_mouse_entered():
	set_texture_hover(texture_hover_)
