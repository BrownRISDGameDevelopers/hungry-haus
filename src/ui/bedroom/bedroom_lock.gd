extends Puzzle

class_name BedroomLock

func _ready():
	$ColorRect/submit.pressed.connect(_submit)
	modulate = Color(1,1,1,0)

func _submit():
	var combo = $ColorRect/HBoxContainer/LockButton.getVal() + $ColorRect/HBoxContainer/LockButton2.getVal() + $ColorRect/HBoxContainer/LockButton3.getVal() + $ColorRect/HBoxContainer/LockButton4.getVal() + $ColorRect/HBoxContainer/LockButton5.getVal()
	if combo == "12345":
		print("Success!")
