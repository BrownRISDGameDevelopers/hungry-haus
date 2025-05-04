extends Control

@onready var start: TextureButton = $BG/Start
@onready var credits: TextureButton = $BG/Credits
@onready var credits_splash: TextureRect = $CreditsSplash

var final_pos = Vector2(-2300, -1000)

func _on_start_pressed() -> void:
	play_intro_cutscene()


func play_intro_cutscene():
	# TODO Disable all buttons
	start.disabled = true
	credits.disabled = true
	# Move camera towards doorway and
	var tween = Global.safe_tween(self).set_parallel()
	const TIME = 3.0
	tween.tween_property(credits_splash, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ONE * 3.0, TIME).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position:x", final_pos.x, TIME).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position:y", final_pos.y, TIME).set_trans(Tween.TRANS_CUBIC)
	
	# Fade to black
	tween.tween_property(self, "modulate", Color.BLACK, TIME).set_trans(Tween.TRANS_CUBIC)
	
	# TODO Fade out audio
	
	
	# Switch scene TODO set clear_color to black
	tween.chain().tween_callback(get_tree().change_scene_to_file.bind("res://src/Game.tscn"))



func _on_credits_pressed() -> void:
	var tween = Global.safe_tween(self)
	tween.tween_property(credits_splash, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func _on_x_button_pressed() -> void:
	var tween = Global.safe_tween(self)
	tween.tween_property(credits_splash, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
