extends VBoxContainer

func _ready():
	network.connect("server_created", self, "_on_ready_to_play")
	network.connect("join_success", self, "_on_ready_to_play")
	network.connect("join_fail", self, "_on_join_fail")
	
func _on_CreateButton_pressed():
	set_player_info()
	
	if (!$HostPanel/VBoxContainer/txtServerName.text.empty()):
		network.server_info.name = $HostPanel/VBoxContainer/txtServerName.text
	network.server_info.max_players = int($HostPanel/VBoxContainer/HBoxContainer/txtMaxPlayers.value)
	network.server_info.used_port = int($HostPanel/VBoxContainer/HBoxContainer/txtServerPort.text)
	
	network.create_server()

func _on_ready_to_play():
	get_tree().change_scene("res://Lobby.tscn")

func _on_join_fail():
	print("Failed to join server")

func _on_JoinButton_pressed():
	set_player_info()
	var port = int($PanelContainer/VBoxContainer/HBoxContainer/textJoinPort.text)
	var ip = $PanelContainer/VBoxContainer/HBoxContainer/txtJoinIP.text
	network.join_server(ip, port)
	
func set_player_info():
	if !$PlayerPanel/VBoxContainer/txtPlayerName.text.empty():
		gamestate.player_info.name = $PlayerPanel/VBoxContainer/txtPlayerName.text
