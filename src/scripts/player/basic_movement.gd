extends CharacterBody3D

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.25
@export var tilt_upper_limit := PI / 3.0
@export var tilt_lower_limit := -PI / 8.0

@export_group("Movement")
@export var move_speed := 14.0
@export var acceleration := 10.0
@export var camera_rotation_speed = 60
@export var rotation_matrix: float = 40.0

var _camera_input_direction := Vector2.ZERO

@onready var _camera_pivot: Node3D = $CameraRig
@onready var _camera: Camera3D = $CameraRig/Camera3D

func camera_follows_player():
	var player_pos = global_transform.origin
	_camera_pivot.global_transform.origin = player_pos


func rotate_camera(delta):
	if Input.is_action_pressed("key_rotate_r"):
		_camera_pivot.rotate_y(deg_to_rad(-camera_rotation_speed * delta)) 
	if Input.is_action_pressed("key_rotate_l"):
		_camera_pivot.rotate_y(deg_to_rad(camera_rotation_speed * delta)) 


func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * mouse_sensitivity

func _physics_process(delta: float) -> void:
	camera_follows_player()
	rotate_camera(delta)

	var raw_input := Input.get_vector("left_stick_l", "left_stick_r", "left_stick_u", "left_stick_d")
	raw_input = -raw_input.rotated(deg_to_rad(135))
	print(raw_input)
	
	var move_direction := (transform.basis * Vector3(raw_input.x, 0, raw_input.y)).normalized()


	if move_direction:	
		velocity = move_direction * move_speed;
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)
		
	move_and_slide()
