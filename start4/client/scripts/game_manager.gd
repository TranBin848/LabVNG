extends Node

var session: String = ""

var user_info: Dictionary = {}
var player_id: int = 0
var player_name: String = ""
var is_host: bool = false

var room_info: Dictionary = {}
var room_id: int = 0
var room_players: Dictionary = {}

var opponent_id: int = -1
var opponent_name: String = ""

var frame_count: int = 0

func set_session_key(sskey: String) -> void:
	session = sskey
	
func get_session_key() -> String:
	return session

func set_user_info(json_obj: Dictionary) -> void:
	user_info = json_obj
	player_id = user_info["id"]
	player_name = user_info["displayName"]
	
func get_user_info() -> Dictionary:
	return user_info
	
func set_room_info(json_obj: Dictionary) -> void:
	room_info = json_obj
	room_id = room_info["roomId"]
	room_players = room_info["mapName"]
	
	if room_players.size() == 1:
		is_host = true
		
	# set opponent info
	for uid_str in room_players:
		var uid = uid_str.to_int()
		if uid != player_id:
			opponent_id = uid
			opponent_name = room_players[uid_str]

func get_room_info() -> Dictionary:
	return room_info
	
func get_room_id() -> int:
	return room_id
	
func is_room_full() -> bool:
	return room_players.size() >= 2
