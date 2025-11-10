extends Node2D


func _ready() -> void:
	GameServerConnection.connected.connect(_on_server_connected)
	GameServerConnection.disconnected.connect(_on_server_disconnected)
	pass
	
func _on_server_connected() -> void:
	print("Connect to game server OK.")
	get_tree().change_scene_to_file("res://screens/login_menu.tscn")

func _on_server_disconnected(reason: String) -> void:
	print("Game's disconnected: %s" % reason)


func _on_button_connect_pressed() -> void:
	# TODO: get ip from Control Node
	var ip: String = $PanelMain/ServerIP.text
	if ip. length() == 0:
		print("Server ip is empty!")
		return
	# TODO: get port number from Control Node
	var port: int = $PanelMain/Port.text.to_int()
	if port <= 0:
		print("Invalid port number!")
		return
	GameServerConnection.connect_to_server(ip, port)
