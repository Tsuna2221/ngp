extends CharacterBody3D

@export var speed = 85
@export var friction = 0.65
@export var gravity = 80
@export var camera_rotation_speed = 60

var move_direction = Vector3()
@onready var camera = $CameraRig/Camera3D
@onready var camera_rig = $CameraRig
@onready var cursor= $Cursor


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _physics_process(delta):
	camera_follows_player()
	rotate_camera(delta)
	
	#look_at_cursor()
	run(delta)
	
	velocity *= friction
	#velocity.y -= gravity*delta
	move_and_slide()

func camera_follows_player():
	var player_pos = global_transform.origin
	camera_rig.global_transform.origin = player_pos


func rotate_camera(delta):
	if Input.is_action_pressed("key_rotate_l"):
		camera_rig.rotate_y(deg_to_rad(-camera_rotation_speed * delta)) 
	if Input.is_action_pressed("key_rotate_r"):
		camera_rig.rotate_y(deg_to_rad(camera_rotation_speed * delta)) 


func look_at_cursor():
	# Create a horizontal plane, and find a point where the ray intersects with it
	var player_pos = global_transform.origin
	var dropPlane  = Plane(Vector3(0, 1, 0), player_pos.y)
	# Project a ray from camera, from where the mouse cursor is in 2D viewport
	var ray_length = 1000
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	var cursor_pos = dropPlane.intersects_ray(from,to)
	
	# Set the position of cursor visualizer
	cursor.global_transform.origin = cursor_pos + Vector3(0,1,0)
	
	# Make player look at the cursor
	look_at(cursor_pos, Vector3.UP)


func run(delta):
	move_direction = Vector3()
	var camera_basis = camera_rig.transform.basis.z.normalized() * 0.03
	
	if Input.is_key_pressed(KEY_W):
		move_direction += -camera_basis
	if Input.is_key_pressed(KEY_S):
		move_direction += camera_basis
	if Input.is_key_pressed(KEY_A):
		move_direction += camera_basis.cross(Vector3.UP) / 1.03
	if Input.is_key_pressed(KEY_D):
		move_direction += -camera_basis.cross(Vector3.UP) / 1.03
		
	move_direction.y = 0
	move_direction = move_direction.normalized()
	
	velocity += move_direction*speed*delta
