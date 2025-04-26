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

@onready var camera: Camera3D = $Camera3D

func _ready() -> void:
	capture_mouse()
	player = self

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_dir = event.relative * 0.001
		if can_move: _rotate_camera()
	if event.is_action_pressed("freeze_n_stuff"):
		_freeze_n_move()

func _physics_process(delta: float) -> void:
	velocity = _walk(delta) + _gravity(delta)
	move_and_slide()

func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func _rotate_camera(sens_mod: float = 1.0) -> void:
	camera.rotation.y -= look_dir.x * camera_sens * sens_mod
	camera.rotation.x = clamp(camera.rotation.x - look_dir.y * camera_sens * sens_mod, -1.5, 1.5)

func _walk(delta: float) -> Vector3:
	move_dir = Input.get_vector(&"move_left", &"move_right", &"move_forward", &"move_backward")
	var _forward: Vector3 = camera.global_transform.basis * Vector3(move_dir.x, 0, move_dir.y)
	var walk_dir: Vector3 = Vector3(_forward.x, 0, _forward.z).normalized()
	walk_vel = walk_vel.move_toward(walk_dir * speed * move_dir.length(), acceleration * delta)
	return walk_vel if can_move else Vector3.ZERO

func _gravity(delta: float) -> Vector3:
	grav_vel = Vector3.ZERO if is_on_floor() else grav_vel.move_toward(Vector3(0, velocity.y - gravity, 0), gravity * delta)
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
func is_looking_at(obj: Node3D):
	var player_looking : Vector3 = camera.global_transform.basis * Vector3(0, 0, -1)
	var displacement = obj.global_position - self.global_position
	var distance_modifier = clipping_distance - displacement.length()
	if distance_modifier < 0:
		return false
	
	return displacement.angle_to(player_looking) < thresh_radians * (0.6 + 2.4 * distance_modifier / clipping_distance)

func _freeze_n_move():
	can_move = false
	var tween = Global.safe_tween(self)
	tween.tween_property(self.camera, "rotation", Vector3(PI/2, camera.rotation.y, camera.rotation.z), 3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(self, "position", Vector3(self.position.x + 5, self.position.y, self.position.z), 3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	
	#CALL ENDING FUNCTION
	
	
	
	
	
