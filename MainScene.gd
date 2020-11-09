extends Spatial

var num_players = 3
var num_frozen = 0

func _on_freeze():
	num_frozen += 1
	if num_frozen == num_players:
		it_wins()

func it_wins():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene("res://ItWinScreen.tscn")

remote func spawn_players(pinfo, spawn_index):
	if spawn_index == -1:
		spawn_index = network.players.size()
	
	if get_tree().is_network_server() && pinfo.net_id != 1:
		var s_index = 1
		for id in network.players:
			if id != pinfo.net_id:
				rpc_id(pinfo.net_id, "spawn_players", network.players[id], s_index)
			
			if id != 1:
				rpc_id(id, "spawn_players", pinfo, spawn_index)
			
			s_index += 1
		
	var player_class = load(pinfo.actor_path)
	var player_instance = player_class.instance()
	var spawn_point = get_node("SpawnPoints/" + str(spawn_index))
	player_instance.translation = spawn_point.translation
	if pinfo.net_id != 1:
		player_instance.set_network_master(pinfo.net_id)
	player_instance.set_name(str(pinfo.net_id))
	add_child(player_instance)
		
func _ready():
	if get_tree().is_network_server():
		spawn_players(gamestate.player_info, 1)
	else:
		rpc_id(1, "spawn_players", gamestate.player_info, -1)
