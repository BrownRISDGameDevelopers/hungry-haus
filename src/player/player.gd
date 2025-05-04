extends CharacterBody3D

class_name Player

@export_range(1, 35, 1) var speed: float = 2 # m/s
@export_range(10, 400, 1) var acceleration: float = 25 # m/s^2

@export_range(0.1, 3.0, 0.1, "or_greater") var camera_sens: float = 1

static var player: Player

var jumping: bool = false




var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var move_dir: Vector2 # Input direction for movement
var look_dir: Vector2 # Input direction for look/aim

var walk_vel: Vector3 # Walking velocity 
var grav_vel: Vector3 # Gravity velocity 
var jump_vel: Vector3 # Jumping velocity

var can_move: bool = true
var can_highlight: bool = true
var can_look: bool = true


var BloodVision: Node

@onready var camera: Camera3D = $Camera3D
@onready var hands: Node3D = $Camera3D/Hands

func _ready() -> void:
	capture_mouse()
	player = self
	BloodVision = get_tree().get_nodes_in_group("screenshaders")[0]

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_dir = event.relative * 0.001
		if can_move: _rotate_camera()
	#if event.is_action_pressed("freeze_n_stuff"):
		#_freeze_n_move()

func _physics_process(delta: float) -> void:
	velocity = _walk(delta) + _gravity(delta)
	#print_debug(self.camera.rotation)
	#print_debug(self.position)
	move_and_slide()

func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func _rotate_camera(sens_mod: float = 1.0) -> void:
	if can_look:
		camera.rotation.y -= look_dir.x * camera_sens * sens_mod
		camera.rotation.x = clamp(camera.rotation.x - look_dir.y * camera_sens * sens_mod, -1.5, 1.5)

func _walk(delta: float) -> Vector3:
	move_dir = Input.get_vector(&"move_left", &"move_right", &"move_forward", &"move_backward")
	var _forward: Vector3 = camera.global_transform.basis * Vector3(move_dir.x, 0, move_dir.y)
	var walk_dir: Vector3 = Vector3(_forward.x, 0, _forward.z).normalized()
	walk_vel = walk_vel.move_toward(walk_dir * speed * move_dir.length(), acceleration * delta)
	return walk_vel if can_move else Vector3.ZERO

func _gravity(delta: float) -> Vector3:
	grav_vel = Vector3.ZERO if is_on_floor() or not can_move else grav_vel.move_toward(Vector3(0, velocity.y - gravity, 0), gravity * delta)
	return grav_vel

func open_puzzle():
	print("open called")
	can_move = false
	release_mouse()
	
func close_puzzle():
	print("close called")
	can_move = true
	capture_mouse()

@export var thresh_radians: float = 18/180.0 * 3.1415926
@export var clipping_distance: float = 3.5
func is_looking_at(obj: Node3D, thresh_modifier := 1.0):
	var player_looking : Vector3 = camera.global_transform.basis * Vector3(0, 0, -1)
	var displacement = obj.global_position - self.global_position
	var distance_modifier = clipping_distance - displacement.length()
	if distance_modifier < 0:
		return false
	
	return displacement.angle_to(player_looking) < thresh_radians * thresh_modifier * (0.6 + 2.4 * distance_modifier / clipping_distance)

func _freeze_n_move():
	can_look = false
	can_move = false
	can_highlight = false
	self.set_physics_process(false)
	var tween = Global.safe_tween(self)
	get_tree().get_first_node_in_group("mirror_blocker").hide()
	var intermediate_basis = Basis(Vector3(-0.716801, 0.0, 0.697278), Vector3(-0.090391, 0.991562, -0.092922), Vector3(-0.691394, -0.129634, -0.710753))
	#print(global_rotate)
	tween.tween_property(self.camera, "rotation", Vector3(deg_to_rad(-47.0), deg_to_rad(-250), 0), 0.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(self, "position", Vector3(13.275, 1.043, 7.1736), 2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	#CALL ENDING FUNCTION
	tween.tween_callback(BloodVision.disable_blood_vision)
	
	tween.tween_property(self.camera, "rotation", Vector3(deg_to_rad(0.0), deg_to_rad(-250), 0), 4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	#tween.parallel().tween_property(self, "position", Vector3(13.275, 1.2, 7.1736), 2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(self, "position", Vector3(13.275, 1.2, 7.1736) -  intermediate_basis * Vector3(0, 0, 0.4), 4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

func lose():
	can_look = false
	can_move = false
	can_highlight = false
	self.set_physics_process(false)
	BloodVision.disable_blood_vision()
	for puzzle: Puzzle in get_tree().get_nodes_in_group("puzzle"):
		puzzle.toggle_puzzle_off()
	
	SfxPlayer._play("PuzzleComplete3")
	SfxPlayer.stop("BGMusic")
	
	var tween = Global.safe_tween(self)
	tween.tween_property(hands, "rotation:x", 0.0, 3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(camera, "rotation:x", deg_to_rad(-50.0), 3.0).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(hands, "rotation:x", deg_to_rad(10.0), 3.7 / 2).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(hands, "rotation:x", deg_to_rad(-10.0), 3.7 / 2).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(hands, "rotation:x", deg_to_rad(-60.0), 9.1 - 6.7).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(camera, "rotation:x", deg_to_rad(-80.0), 9.1 - 6.7).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	var tween2 = create_tween()
	tween2.tween_callback(IntroCutscene.inst.black_screen).set_delay(9.1)
	tween2.tween_callback(get_tree().change_scene_to_file.bind("res://src/Screens/Menu.tscn")).set_delay(2.0)
