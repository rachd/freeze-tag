extends Node

signal server_created
signal join_success
signal join_fail
signal player_list_changed

var server_info = {
	name = "Server",
	max_players = 0,
	used_port = 0
}
var players = {}

func _on_player_connected(id):
	pass
	
func _on_player_disconnected(id):
	print("Player ", players[id].name, " disconnected from server")
	if (get_tree().is_network_server()):
		unregister_player(id)
		rpc("unregister_player", id)
	
func _on_connected_to_server():
	emit_signal("join_success")
	gamestate.player_info.net_id = get_tree().get_network_unique_id()
	rpc_id(1, "register_player", gamestate.player_info)
	register_player(gamestate.player_info)
	
func _on_connection_failed():
	emit_signal("join_fail")
	get_tree().set_network_peer(null)
	
func _on_disconnected_from_server():
	print("Disconnected from server")
	players.clear()
	gamestate.player_info.net_id = 1
	
func create_server():
	var net = NetworkedMultiplayerENet.new()
	if (net.create_server(server_info.used_port, server_info.max_players) != OK):
		print("Failed to create server")
		return
	get_tree().set_network_peer(net)
	emit_signal("server_created")
	register_player(gamestate.player_info)
	
func join_server(ip, port):
	var net = NetworkedMultiplayerENet.new()
	
	if net.create_client(ip, port) != OK:
		print("Failed to create client")
		emit_signal("join_fail")
		return
		
	get_tree().set_network_peer(net)
	emit_signal("server_created")
	register_player(gamestate.player_info)
	
remote func register_player(pinfo):
	if get_tree().is_network_server():
		for id in players:
			rpc_id(pinfo.net_id, "register_player", players[id])
			if(id != 1):
				rpc_id(id, "register_player", pinfo)
	print("Registering player ", pinfo.name, " (", pinfo.net_id, ") to internal player table")
	players[pinfo.net_id] = pinfo
	emit_signal("player_list_changed")
	
remote func unregister_player(id):
	print("Removing player ", players[id].name, " from internal table")
	players.erase(id)
	emit_signal("player_list_changed")
	
func _ready():
	get_tree().connect("network_peer_conneted", self, "_on_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_player_disconnected")
	get_tree().connect("connected_to_server", self, "_on_connected_to_server")
	get_tree().connect("connection_failed", self, "_on_connection_failed")
	get_tree().connect("server_disconnected", self, "_on_disconnected_from_server")
