extends Node3D

class_name Door

func open():
	create_tween().tween_property(self, "rotation", PI / 3, 0.3).set_trans(Tween.TRANS_BOUNCE)
	# TODO play a door opening sound here
