extends Spatial

func _on_freeze():
	gamestate.num_frozen += 1
	if gamestate.num_frozen >= network.player_order.size() - 1:
		rpc("it_wins")
		
func _on_unfreeze():
	gamestate.num_frozen -= 1

remotesync func it_wins():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene("res://ItWinScreen.tscn")

remote func spawn_players():
	var player_id = get_tree().get_network_unique_id()
	var pinfo = network.players[player_id]
	var player_class = load(pinfo.actor_path)
	var player_instance = player_class.instance()
	player_instance.set_network_master(pinfo.net_id)
	player_instance.set_name(str(pinfo.net_id))
	player_instance.set_player_name(pinfo.name)
	player_instance.turn_on_camera()
	var index = network.player_order.find(pinfo.net_id)
	var spawn_point = get_node("SpawnPoints/" + str(index))
	player_instance.translation = spawn_point.translation
	add_child(player_instance)
	
	for p in network.players.keys():
		if p != player_id:
			print(p)
			var other_player_class = load(network.players[p].actor_path)
			var other_player_instance = other_player_class.instance()
			other_player_instance.set_name(str(p))
			other_player_instance.set_network_master(p)
			other_player_instance.set_player_name(network.players[p].name)
			var o_index = network.player_order.find(p)
			var o_spawn_point = get_node("SpawnPoints/" + str(o_index))
			other_player_instance.translation = o_spawn_point.translation
			add_child(other_player_instance)
		
func _ready():
	spawn_players()
