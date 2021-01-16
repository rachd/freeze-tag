extends MarginContainer

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	if get_tree().is_network_server():
		$VBoxContainer/PlayAgainButton.visible = true
			
remotesync func start_game(it_player, player_order):
	network.player_order = player_order
	var it_id = player_order[it_player]
	for p in player_order:
		if p == it_id:
			network.players[it_id].actor_path = "res://ItPlayer.tscn"
		else:
			network.players[p].actor_path = "res://Player.tscn"
	get_tree().change_scene("res://MainScene.tscn")
	
func get_player_array():
	return network.players.keys()
	
func choose_it_player():
	return rng.randi_range(0, network.players.size()-1)

func _on_PlayAgainButton_pressed():
	rpc("start_game", choose_it_player(), get_player_array())
