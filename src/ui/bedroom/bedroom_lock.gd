extends Puzzle

class_name BedroomLock

const TRANS_RED = Color(1, 0, 0, 0)
func _ready():
	$submit.pressed.connect(_submit)
	modulate = Color(1,1,1,1)

func _submit():
	var combo = $HBoxContainer/LockButton.getVal() + $HBoxContainer/LockButton2.getVal() + $HBoxContainer/LockButton3.getVal() + $HBoxContainer/LockButton4.getVal() + $HBoxContainer/LockButton5.getVal()
	if combo == "12345":
		print("Success!")
		$status_overlay.modulate = Color(0, 1, 0)
		Global.safe_tween($status_overlay).tween_property($status_overlay, "modulate", Color(0, 1, 0, 0) , APPEAR_DURATION_SEC)
		$HBoxContainer/LockButton.disabled = true
		$HBoxContainer/LockButton2.disabled = true
		$HBoxContainer/LockButton3.disabled = true
		$HBoxContainer/LockButton4.disabled = true
		$HBoxContainer/LockButton5.disabled = true
		$submit.disabled = true
		complete()
	else:
		$status_overlay.modulate = Color(1, 0, 0)
		
		Global.safe_tween($status_overlay).tween_property($status_overlay, "modulate", TRANS_RED , APPEAR_DURATION_SEC)
		
