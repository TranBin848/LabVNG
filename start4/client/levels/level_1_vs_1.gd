extends Node2D

var player_char
var opponent_char

const CMD_BROADCAST = "roomBroadcast"
const CMD_BC_CHAT = "chat"
const CMD_BC_REMOTE_CONTROL = "remoteCtrl"

func _ready() -> void:
	#reset frame count
	GameManager.frame_count = 0
	
	# TODO: setup players's properties (id, name, lvl...)
	
	# TODO: setup main character's camera
	
	GameServerConnection.disconnected.connect(_on_server_disconnected)
	GameServerConnection.read_failed.connect(_on_read_failed)
	GameServerConnection.data_received.connect(_on_data_received)


func _process(_delta: float) -> void:
	GameManager.frame_count += 1


func _on_server_disconnected(reason: String) -> void:
	print("Game's disconnected: %s" % reason)


func _on_read_failed(reason: String) -> void:
	print("Can't read data from socket: %s" % reason)
	
	
func _on_data_received(data: String) -> void:
	print("Response from server:")
	print(data)

	var json_obj = JsonHelper.parse(data)

	var cmd = json_obj["cmd"]
	match cmd:
		CmdId.CMD_BROADCAST:
			_handle_room_broadcast(json_obj["result"], json_obj["id"], json_obj["data"])

	print("Unknown cmd: '%s'" % cmd)
	
	
func _handle_room_broadcast(return_msg: String, player_id: int, bc_info: Dictionary) -> void:
	if return_msg != "SUCCESS":
		print("Broadcast fail!")
		return

	var cmd_bc = bc_info["cmdBc"]

	match cmd_bc:
		CmdId.CMD_BC_CHAT:
			_handle_chat(player_id, bc_info["msg"])

func _handle_chat(player_id: int, msg: String) -> void:
	var chat_line = "Player %d: '%s'\n" % [player_id, msg]
	$CanvasLayer/ChatBox.text += chat_line


func _on_send_pressed() -> void:
	print("Send room broadcast cmd: '%s'" % CmdId.CMD_BC_CHAT)

	var msg = $CanvasLayer/ChatMsg.text
	var json_data: String = "{	\"cmd\":\"%s\",
								\"data\":{
									\"cmdBc\":\"%s\",
									\"msg\": \"%s\"
								}
							}" % [CmdId.CMD_BROADCAST,
								CmdId. CMD_BC_CHAT,
								msg]
	print("data = %s" % json_data)

	GameServerConnection.send_string(json_data)


func _handle_character_remote_ctrl(player_id: int, action: String, ctrl_cmd_queue: Array) -> void:
	# TODO: verify ctrl cmd
	
	# fwd ctrl data to opponent character
	opponent_char.handle_remote_ctrl(action, ctrl_cmd_queue)
