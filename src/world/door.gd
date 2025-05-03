extends Node3D

class_name Door

@export var is_closet := false
@export var door_animator : AnimationPlayer
@export var closet_animator : AnimationPlayer
@export var door_collider : CollisionShape3D
@export var lock : Node3D

func open():
	door_animator.play("Open")
	closet_animator.play("LeftAction")
	door_collider.disabled = true
	if lock: lock.hide()
	# create_tween().tween_property(self, "rotation", PI / 3, 0.3).set_trans(Tween.TRANS_BOUNCE)
	# TODO play a door opening sound here
