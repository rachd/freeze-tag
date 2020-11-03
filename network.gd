extends Node

var server_info = {
	name = "Server",
	max_players = 0,
	used_port = 0
}

func _on_player_connected(id):
	pass
	
func _on_player_disconnected(id):
	pass
	
func _on_connected_to_server():
	pass
	
func _on_connection_failed():
	pass
	
func _on_disconnected_from_server():
	pass
	
func create_server():
	var net = NetworkedMultiplayerENet.new()
	if (net.create_server(server_info.used_port, server_info.max_players) != OK):
		print("Failed to create server")
		return
	get_tree().set_network_peer(net)
	
func _ready():
	get_tree().connect("network_peer_conneted", self, "_on_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_player_disconnected")
	get_tree().connect("connected_to_server", self, "_on_connected_to_server")
	get_tree().connect("connection_failed", self, "_on_connection_failed")
	get_tree().connect("server_disconnected", self, "_on_disconnected_from_server")
