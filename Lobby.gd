extends VBoxContainer

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	network.connect("player_list_changed", self, "_on_player_list_changed")
	$localPlayerLabel.text = gamestate.player_info.name
	if get_tree().is_network_server():
		$StartButton.visible = true
		
func _on_player_list_changed():
	for c in $playerList.get_children():
		c.queue_free()
	
	for p in network.players:
		if p != gamestate.player_info.net_id:
			var nlabel = Label.new()
			nlabel.text = network.players[p].name
			$playerList.add_child(nlabel)
			
	if network.players.size() > 2:
		$StartButton.disabled = false
			
remotesync func start_game(it_player, player_order):
	network.player_order = player_order
	var it_id = player_order[it_player]
	network.players[it_id].actor_path = "res://ItPlayer.tscn"
	get_tree().change_scene("res://MainScene.tscn")
	
func get_player_array():
	return network.players.keys()
	
func choose_it_player():
	return rng.randi_range(0, network.players.size()-1)

func _on_StartButton_pressed():
	rpc("start_game", choose_it_player(), get_player_array())
