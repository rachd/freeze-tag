extends KinematicBody

var moveSpeed = 10.0
var vel = Vector3()

onready var camera = get_node("Camera Orbit")

func _physics_process(delta):
	vel.x = 0
	vel.y = 0
	
	var input = Vector3()
	
	if Input.is_action_pressed("move_forwards"):
		input.z += 1
	if Input.is_action_pressed("move_backwards"):
		input.z -= 1
	if Input.is_action_pressed("move_left"):
		input.x += 1
	if Input.is_action_pressed("move_right"):
		input.x -= 1
		
	input = input.normalized()
	
	var dir = (transform.basis.z * input.z + transform.basis.x * input.x)
	vel.x = dir.x * moveSpeed
	vel.z = dir.z * moveSpeed
	vel.y = 0
	
	vel = move_and_slide(vel, Vector3.UP)
