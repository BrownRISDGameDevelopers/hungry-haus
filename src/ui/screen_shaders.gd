extends Control

class_name ScreenShaders


var blood_vision_on := false
var blood_vision_amount := 0.0

@onready var red_shader: ColorRect = %RedShader
@onready var red_mat : ShaderMaterial = red_shader.material
@onready var vhs_shader: ColorRect = %VHSShader
@onready var vhs_mat : ShaderMaterial = vhs_shader.material
@onready var pixelate_shader: ColorRect = %PixelateShader
@onready var pixelate_mat : ShaderMaterial = pixelate_shader.material

@export var enable_curve : Curve
@export var enable_pixelate_curve : Curve
@export var disable_curve : Curve
@export var disable_pixelate_curve : Curve

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_blood_vision"):
		toggle_blood_vision()

func toggle_blood_vision():
	send_signal_after_delay(not blood_vision_on)
	if blood_vision_on:
		toggle_blood_vision_off()
	else:
		toggle_blood_vision_on()

var toggle_blood_vision_on_duration: float = 2.7
func toggle_blood_vision_on():
	if not blood_vision_on:
		blood_vision_on = true
		var tween = Global.safe_tween(self)
		tween.tween_method(set_blood_vision_amount, blood_vision_amount, 1.0, toggle_blood_vision_on_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

var toggle_blood_vision_off_duration: float = 2.2
func toggle_blood_vision_off():
	if blood_vision_on:
		blood_vision_on = false
		var tween = Global.safe_tween(self)
		tween.tween_method(set_blood_vision_amount, blood_vision_amount, 0.0, toggle_blood_vision_off_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

#@export var delay_before_asset_switch: float = 1
func send_signal_after_delay(new_state: bool):
	if (new_state):
		await get_tree().create_timer(toggle_blood_vision_on_duration * .21).timeout
	else:
		await get_tree().create_timer(toggle_blood_vision_off_duration * .33).timeout
	for obj in get_tree().get_nodes_in_group("enable_off_blood_vision"):
		obj.set_process(not new_state)
		obj.visible = not new_state
	for obj in get_tree().get_nodes_in_group("enable_on_blood_vision"):
		obj.set_process(new_state)
		obj.visible = new_state
	#toggle_blood_signal.emit(new_state)
	

func set_pixelate_amount(value: float):
	red_mat.set_shader_parameter("tint_effect_factor", value)

func set_blood_vision_amount(value: float):
	blood_vision_amount = value
	var curve_val = enable_curve.sample_baked(value) \
				if blood_vision_on \
				else disable_curve.sample_baked(value)
	var pixelate_curve_val = enable_pixelate_curve.sample_baked(value) \
				if blood_vision_on \
				else disable_pixelate_curve.sample_baked(value)
	var red_amount = 0.5 * curve_val
	red_mat.set_shader_parameter("tint_effect_factor", red_amount)
	var contrast_amount = 0.5 * curve_val + 1.0
	red_mat.set_shader_parameter("contrast", contrast_amount)
	
	var pixelate_amount = 5.0 + maxf(0, pixelate_curve_val - 1) * 15
	pixelate_mat.set_shader_parameter("quantize_size", pixelate_amount)
	var vhs_pixelate_amount = 130/(pixelate_amount/4.3)
	vhs_mat.set_shader_parameter("resolution", Vector2(vhs_pixelate_amount, vhs_pixelate_amount))
	var static_amount = 0.05 + maxf(0, pixelate_curve_val - 1) * 0.1
	vhs_mat.set_shader_parameter("static_noise_intensity", static_amount)
