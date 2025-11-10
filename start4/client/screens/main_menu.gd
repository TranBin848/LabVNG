extends Node2D

const CMD_BROADCAST = "roomBroadcast"
# broadcast sub-cmd
const CMD_BC_CHAT = "chat"
const CMD_BC_REMOTE_CTRL = "remoteCtrl"

func _ready() -> void:
	
	# TODO: Setup main menu (using user info from login's reponse data)
	
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
	
	# TODO: handle response data from server (same as login, reuse code)
	var json_obj = JsonHelper.parse(data)
	
	var cmd = json_obj["cmd"]
	match cmd:
		CmdId.CMD_FIND_MATCH:
			_handle_find_match_resp(json_obj["result"], json_obj["data"])
		_:
			print("Unknown cmd: '%s" % cmd)
	pass

func _handle_find_match_resp(return_msg: String, room_info: Dictionary) -> void:
	if return_msg != "SUCCESS":
		print("Find match fail!")
		return
	
	print("Find match succeed. Room info:")
	print(room_info)
	
	# TODO: save/update room info
	GameManager.set_room_info(room_info)
	
	# TODO: change scene to level_1vs1.tscn if room's full
	if GameManager.is_room_full():
		get_tree().change_scene_to_file("res://levels/level_1vs1.tscn")
	pass


func _on_button_find_match_pressed() -> void:
	# TODO: build & send find match cmd
	var room_id = 1
	
	var json_data: String = "{\"cmd\":\"%s\", \"id\":%d}" % [CmdId.CMD_FIND_MATCH, room_id]
	GameServerConnection.send_string(json_data)
	pass
