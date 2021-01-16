extends KinematicBody

var moveSpeed = 10.0
var vel = Vector3()
var gravity = 50.0

var color = "#FFFF00"

var camera_scene = preload("res://CameraOrbit.tscn")

puppet var puppet_position = Vector3()

onready var raycast = get_node("RayCast")

func set_player_name(name):
	$PlayerLabel.set_text(name)

func _ready():
	var material = $MeshInstance.get_surface_material(0)
	material.albedo_color = color
	$MeshInstance.set_surface_material(0, material)
	
func turn_on_camera():
	var camera = camera_scene.instance()
	add_child(camera)
	
func _physics_process(delta):
	
	if is_network_master():
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
		vel.y -= gravity * delta
	
		vel = move_and_slide(vel, Vector3.UP)
		rset("puppet_position", transform)
	else:
		transform = puppet_position
	
func _process(delta):
	if raycast.is_colliding():
		if raycast.get_collider().has_method("freeze"):
			raycast.get_collider().rpc("freeze", raycast.get_collider().name)
