extends Node2D


func _ready() -> void:
	GameServerConnection.disconnected.connect(_on_server_disconnected)
	GameServerConnection.read_failed.connect(_on_read_failed)
	GameServerConnection.data_received.connect(_on_data_received)


func _on_server_disconnected(reason: String) -> void:
	print("Game's disconnected: %s" % reason)


func _on_read_failed(reason: String) -> void:
	print("Can't read data from socket: %s" % reason)


func _on_data_received(data: String) -> void:
	print("Response from server:")
	print(data)

	var json_obj = JsonHelper.parse(data)
	print(json_obj)
	var cmd = json_obj["cmd"]
	match cmd:
		CmdId.CMD_LOGIN:
			_handle_login_resp(json_obj["result"], json_obj["data"], json_obj["session"])

			print("Unknown cmd: '%s'" % cmd)

func _handle_login_resp(return_msg: String, user_info: Dictionary, sskey: String) -> void:
	if return_msg != "SUCCESS":
		print("Login fail!")
		return

	print("Login succeed. User info:")
	print(user_info)

# save user info
	GameManager.set_user_info(user_info)
	GameManager.set_session_key(sskey)

	# change scene to main menu
	get_tree().change_scene_to_file("res://screens/main_menu.tscn")
	

func _on_button_login_pressed() -> void:

	var user_id: int = $PanelMain/UserID.get_text().to_int()
	if user_id <= 0:
		print("Invalid user id!")
		return

	var json_data: String = "{\"cmd\":\"%s\", \"id\":%d}" % [CmdId.CMD_LOGIN, user_id]
	print("Send login cmd ... ")
	print("data = %s" % json_data)
	GameServerConnection.send_string(json_data)
