extends VBoxContainer

func _ready():
	network.connect("player_list_changed", self, "_on_player_list_changed")
	$localPlayerLabel.text = gamestate.player_info.name

func _on_player_list_changed():
	for c in $playerList.get_children():
		c.queue_free()
	
	for p in network.players:
		if p != gamestate.player_info.net_id:
			var nlabel = Label.new()
			nlabel.text = network.players[p].name
			$playerList.add_child(nlabel)
