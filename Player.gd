extends KinematicBody

signal on_freeze()
signal on_unfreeze()

var originalMoveSpeed = 10.0
var moveSpeed = originalMoveSpeed
var gravity = 50.0
var vel = Vector3()
var is_frozen = false

var unfrozen_color = "#8BC1DE"
var frozen_color = "#251FCE"

var camera_scene = preload("res://CameraOrbit.tscn")

puppet var puppet_position = Vector3()

func turn_on_camera():
	var camera = camera_scene.instance()
	add_child(camera)

func set_player_name(name):
	$PlayerLabel.set_text(name)
	
func _ready():
	change_color(unfrozen_color)
	self.connect("on_freeze", get_node("/root/MainScene"), "_on_freeze")
	self.connect("on_unfreeze", get_node("/root/MainScene"), "_on_unfreeze")
	
remotesync func change_color(color):
	var material = SpatialMaterial.new()
	material.albedo_color = color
	$MeshInstance.set_material_override(material)

func _physics_process(delta):
	var pos = get_translation()
	var cam = get_tree().get_root().get_camera()
	var screenPos = cam.unproject_position(pos)
	$NameLabel.set_position(Vector2(screenPos.x, screenPos.y - 2))
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
		for i in range(get_slide_count() - 1):
			var collision = get_slide_collision(i)
			if collision.collider.has_method("unfreeze"):
				collision.collider.rpc("unfreeze")	
		rset("puppet_position", transform)
	else:
		transform = puppet_position
		
remotesync func unfreeze():
	moveSpeed = originalMoveSpeed
	is_frozen = false
	rpc("change_color", unfrozen_color)
	emit_signal("on_unfreeze")

remotesync func freeze(n):
	if get_tree().get_network_unique_id() == int(n) and !is_frozen:
		rpc("change_color", frozen_color)
		moveSpeed = 0
		is_frozen = true
		emit_signal("on_freeze")
