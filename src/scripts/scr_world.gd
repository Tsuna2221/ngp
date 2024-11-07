extends Node3D

@onready var pivot = $CameraPivot

var navigation_speed = 0.03

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var forward = pivot.transform.basis.z.normalized() * navigation_speed
		
	if Input.is_key_pressed(KEY_W):
		$CameraPivot.transform.origin += -forward
	if Input.is_key_pressed(KEY_S):
		$CameraPivot.transform.origin += forward
	if Input.is_key_pressed(KEY_A):
		$CameraPivot.transform.origin += forward.cross(Vector3.UP) / 1.03
	if Input.is_key_pressed(KEY_D):
		$CameraPivot.transform.origin += -forward.cross(Vector3.UP) / 1.03
		
	if Input.is_action_pressed("key_rotate_l"):
		pivot.rotation_degrees.y -= 0.5
		
	if Input.is_action_pressed("key_rotate_r"):
		pivot.rotation_degrees.y += 0.5
