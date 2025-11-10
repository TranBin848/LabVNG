class_name TcpConnection extends Node

@export var server_ip = "127.0.0.1"
@export var server_port = 3000
@export var connect_timeout_secs = 2

signal connected()
signal disconnected(reason: String)
signal data_received(data: String)
signal read_failed(reason: String)

var _conn = null
var _is_connected = false

func connect_to_server(ip: String = "", port: int = -1) -> void:
	if ip != null && ip.length():
		server_ip = ip
	if port > 0:
		server_port = port
		
	print("Try connect to server %s:%d" % [server_ip, server_port])
	var result = _conn.connect_to_host(server_ip, server_port)
	
	if result == OK:
		
		# Wait for the socket to connect.
		await get_tree().create_timer(0.2).timeout
		# Poll the socket, updating its state.
		_poll_conn_status()
		if is_connected:
			connected.emit()
			print("connect OK")
			return
			
		# Wait until timeout.
		await get_tree().create_timer(connect_timeout_secs).timeout
		
		# Poll again
		_poll_conn_status()
		
		if _is_connected:
			connected.emit()
			print("connect OK")
		else:
			disconnected.emit("Connect timeout")
	else:
		_is_connected = false
		disconnected.emit("Connect fail: %s" % error_string(result))
		print("connect FAIL!")

func _poll_conn_status() -> void:
	# Poll the socket, updating its state.
	_conn.poll()
	
	# Get connection status
	var conn_status = _conn.get_status()
	
	if conn_status == StreamPeerTCP.STATUS_CONNECTED:
		_is_connected = true
	else:
		# connection's NOT ready!
		_is_connected = false

# Append '\n' and send utf8 data
func send_string(s: String) -> bool:
	# Check connection status
	if _is_connected == false:
		print("connection's NOT ready!")
		return false
	
	# Append '\n' and send utf8 data.
	_conn.put_data((s + "\n").to_utf8_buffer())
	return true

func _ready() -> void:
	_conn = StreamPeerTCP.new()
	
func _process(_delta) -> void:
	if _is_connected == false:
		return
		
	#_poll_conn_status()
	#if _is_connected == false:
		#disconnected.emit("Connection's broken")
		#return
		
	# Check available data
	var available_bytes = _conn.get_available_bytes()
	if available_bytes < 0:
		_is_connected = false
		disconnected.emit("Unknown")
		return
		
	if available_bytes == 0:
		return
	
	# Read data from connection
	var result = _conn.get_partial_data(available_bytes)
	var err = result[0]
	
	if err:
		read_failed.emit("Read fail: %s" % error_string(err))
		return
	
	var data: PackedByteArray = result[1]
	var received_bytes = data.size()
	
	if (received_bytes < available_bytes):
		read_failed.emit("Read fail: can NOT read full of data")
		return
	
	var s: String = data.get_string_from_utf8()
	if s == null:
		read_failed.emit("Read fail: invalid UTF8")
		return
		
	if s.ends_with("\n") == false:
		read_failed.emit("Read fail: string NOT ends_with '\\n'")
		return
	
	# handle multi-line resp string
	var arr_of_s = s.split("\n")
	
	for si in arr_of_s:
		if si.length() > 0:
			# emit single line
			data_received.emit(si)
