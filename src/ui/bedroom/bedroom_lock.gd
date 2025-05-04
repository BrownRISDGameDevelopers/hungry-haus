extends Puzzle

class_name BedroomLock

const TRANS_RED = Color(1, 0, 0, 0)
func _ready():
	super._ready()
	for child in [$LockButton, $LockButton2, $LockButton3, $LockButton4]:
		child.updated.connect(_submit)

func _submit():
	var combo = $LockButton.getVal() + $LockButton2.getVal() + $LockButton3.getVal() + $LockButton4.getVal() 
	if combo == "1138":
		print("Success!")
		$LockButton.disabled = true
		$LockButton2.disabled = true
		$LockButton3.disabled = true
		$LockButton4.disabled = true
		show_victory()
		complete()


func show_victory():
	var tween = Global.safe_tween(self)
	mouse_filter = Control.MOUSE_FILTER_IGNORE # Don't let user close the puzzle
	tween.tween_property(self, "scale", Vector2(1.05, 1.05), 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(self, "modulate", Color(1.0, 0.8, 0.8), 3.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.chain().tween_callback(toggle_puzzle_active) 


func _on_x_button_pressed() -> void:
	toggle_puzzle_off()
