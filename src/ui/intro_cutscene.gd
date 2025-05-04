extends Control

class_name IntroCutscene

signal start_game

@export var do_cutscene := true
@onready var black_bg: ColorRect = $BlackBG
@onready var id_card: Node2D = $IDCard
@onready var controls: Sprite2D = $Controls

@onready var id_card_pos := id_card.position
@onready var id_card_scale := id_card.scale
@onready var id_card_rotation := id_card.rotation


func _ready():
	if do_cutscene:
		Player.player.can_move = false
		var tween = Global.safe_tween(self)
		# Move ID card above center screen
		id_card.position += Vector2(-50, -500)
		id_card.scale = Vector2.ONE * 5
		id_card.rotation = PI 
		
		# Move ID card to center screen
		const TIME = 0.67
		tween.set_parallel()
		tween.chain().tween_interval(1.0)
		tween.chain().tween_property(id_card, "position", id_card_pos, TIME).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(id_card, "scale", id_card_scale, TIME).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
		tween.tween_callback(shake_card).set_delay(TIME)
		tween.tween_property(id_card, "rotation", id_card_rotation, TIME + 0.15).set_trans(Tween.TRANS_CUBIC)
		# Wait, then reveal controls 
		tween.chain().tween_interval(2.0)
		tween.tween_property(controls, "modulate:a", 1.0, 3.0).set_trans(Tween.TRANS_CUBIC)
		
		# Wait for input
		tween.chain().tween_callback(start_game_after_input)
		
		
	else:
		visible = false
		Player.player.can_move = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		start_game.emit()

func shake_card():
	var tween = create_tween()
	for i in range(10):
		tween.tween_property(id_card, "position", id_card.position + Vector2((10 - i) / 10.0 * randf_range(-8, 8), (10 - i) / 10.0 * randf_range(-8, 8)), 0.0)
		tween.tween_interval(0.015)


func start_game_after_input():
	await start_game
	# Hide controls and put card in pocket, enable movement
	var tween = Global.safe_tween(self).set_parallel()
	tween.tween_property(controls, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(black_bg, "modulate:a", 0.0, 2.0).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(id_card, "position:x", id_card_pos.x + 50, 1.0).set_trans(Tween.TRANS_BACK)
	tween.tween_property(id_card, "position:y", id_card_pos.y + 200, 1.5).set_trans(Tween.TRANS_BACK).set_delay(0.5).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(id_card, "scale", Vector2.ONE * 0.8, 1.5).set_trans(Tween.TRANS_CUBIC).set_delay(0.5).set_ease(Tween.EASE_OUT)
	tween.chain().tween_property(Player.player, "can_move", true, 0.0)
