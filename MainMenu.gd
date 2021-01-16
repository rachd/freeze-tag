extends VBoxContainer

func _ready():
	network.connect("server_created", self, "_on_ready_to_play")
	network.connect("join_success", self, "_on_ready_to_play")
	network.connect("join_fail", self, "_on_join_fail")
	
func _on_CreateButton_pressed():
	set_player_info()
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


func _on_txtPlayerName_text_changed(new_text):
	if new_text:
		if $PanelContainer/VBoxContainer/HBoxContainer/txtJoinIP.text and $PanelContainer/VBoxContainer/HBoxContainer/textJoinPort.text:
			$PanelContainer/VBoxContainer/JoinButton.disabled = false
		if $HostPanel/VBoxContainer/HBoxContainer/txtServerPort.text:
			$HostPanel/VBoxContainer/CreateButton.disabled = false
	else:
		$HostPanel/VBoxContainer/CreateButton.disabled = true
		$PanelContainer/VBoxContainer/JoinButton.disabled = true


func _on_txtServerPort_text_changed(new_text):
	if new_text:
		if $PlayerPanel/VBoxContainer/txtPlayerName.text:
			$HostPanel/VBoxContainer/CreateButton.disabled = false
	else:
		$HostPanel/VBoxContainer/CreateButton.disabled = true


func _on_txtJoinIP_text_changed(new_text):
	if new_text:
		if $PlayerPanel/VBoxContainer/txtPlayerName.text and $PanelContainer/VBoxContainer/HBoxContainer/textJoinPort.text:
			$PanelContainer/VBoxContainer/JoinButton.disabled = false
	else:
		$PanelContainer/VBoxContainer/JoinButton.disabled = true


func _on_textJoinPort_text_changed(new_text):
	if new_text:
		if $PlayerPanel/VBoxContainer/txtPlayerName.text and $PanelContainer/VBoxContainer/HBoxContainer/txtJoinIP.text:
			$PanelContainer/VBoxContainer/JoinButton.disabled = false
	else:
		$PanelContainer/VBoxContainer/JoinButton.disabled = true
