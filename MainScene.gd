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
