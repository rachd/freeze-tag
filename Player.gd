extends KinematicBody

signal on_freeze()
signal on_unfreeze()

var originalMoveSpeed = 10.0
var moveSpeed = originalMoveSpeed
var gravity = 15.0
var vel = Vector3()
var is_frozen = false

var color = "#8BC1DE"

puppet var puppet_vel = Vector3()


onready var camera = get_node("Camera Orbit")

func _ready():
	var material = $MeshInstance.get_surface_material(0)
	material.albedo_color = color
	$MeshInstance.set_surface_material(0, material)
	self.connect("on_freeze", get_node("/root/MainScene"), "_on_freeze")
	self.connect("on_unfreeze", get_node("/root/MainScene"), "_on_unfreeze")

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
	#	rset("puppet_vel", vel)
	#else:
	#	vel = move_and_slide(puppet_vel, Vector3.UP)

func freeze():
	if !is_frozen:
		moveSpeed = 0
		is_frozen = true
		emit_signal("on_freeze")

func _on_Area_body_entered(body):
	if body.name == "Player":
		moveSpeed = originalMoveSpeed
		is_frozen = false
		emit_signal("on_unfreeze")
