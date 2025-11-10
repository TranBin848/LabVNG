class_name Player
extends BaseCharacter

## Player character class that handles movement, combat, and state management
@export var has_blade: bool = false
@export var _Blade: PackedScene
@export var TIME_OUT_INVULNERABLE = 2
@export var enable_remote_ctrl: bool = true

var is_invulnerable: bool = false
var timer_invulnerable = 0

var player_id: int = 0
var player_name: String = ""
var is_controllable: bool = false

func _ready() -> void:
	super._ready()
	fsm = FSM.new(self, $States, $States/Idle)
	if has_blade:
		collected_blade()

func set_player_id(id: int) -> void:
	player_id = id


func set_player_name(s: String) -> void:
	player_name = s
	$Name.text = player_name
	

func set_controllable() -> void:
	is_controllable = true
	$Camera2D.enabled = true


func can_attack() -> bool:
	return has_blade


func collected_blade() -> void:
	has_blade = true
	set_animated_sprite($Direction/BladeAnimatedSprite2D)


func removed_blade() -> void:
	has_blade = false
	set_animated_sprite($Direction/AnimatedSprite2D)


func _on_hurt_area_2d_hurt(_direction: Variant, _damage: Variant) -> void:
	# if player is invulnerable then not be effected
	if is_invulnerable:
		return
	#Player take damage
	#Player die if health is 0 and change to dead state
	#Player hurt if health is not 0 and change to hurt state
	take_damage(_damage)
	if health > 0:
		change_state(fsm.states.hurt)
	else:
		change_state(fsm.states.dead)


func get_hit_collision() -> CollisionShape2D:
	return $Direction/HitArea2D/CollisionShape2D


func set_disable_hit_collision(value: bool):
	$Direction/HitArea2D/CollisionShape2D.disabled = value


func _process(delta: float) -> void:
	if is_invulnerable:
		timer_invulnerable += delta
		if timer_invulnerable >= TIME_OUT_INVULNERABLE:
			set_invulnerable(false)
			timer_invulnerable = 0

	#if Input.is_action_just_pressed("throw") and has_blade:
	#	throw_blade()


func throw_blade() -> void:
	var blade = _Blade.instantiate() as Blade
	blade.set_up(self.global_position + Vector2(20 * direction, -15),
				300 + abs(velocity.x), 
				Vector2.RIGHT*direction, 
				20)
	get_parent().add_child(blade)
	pass


func set_invulnerable(val: bool):
	self.is_invulnerable = val


#Control moving and changing state to run
#Return true if moving
func control_moving() -> bool:
	if not is_controllable:
		return false
	
	var right: int = 1 if Input.is_action_pressed("right") else 0
	var left: int = 1 if Input.is_action_pressed("left") else 0
	
	var dir: int = right - left
	var is_moving: bool = (dir != 0)
	
	# remote ctrl cmd queue
	var is_status_change: bool = false
	var ctrl_cmd_queue: Array = []
	
	if is_moving:
		# change dir & speed
		if direction != dir:
			# build remote ctrl cmd
			is_status_change = true
			ctrl_cmd_queue.push_back({"ctrl_code": "set_pos",
									"x": int(position.x), "y": int(position.y)})

			ctrl_cmd_queue.push_back({ "ctrl_code": "change_dir",
			"from": direction, "to": dir})

			change_direction(dir)

		if velocity.x == 0 and is_status_change == false:
			# build remote ctrl cmd
			is_status_change = true
			ctrl_cmd_queue.push_back({"ctrl_code": "set_pos",
			"x": int(position.x), "y": int(position.y)})

			ctrl_cmd_queue.push_back({"ctrl_code": "moving",
			"dir": dir})

		velocity.x = movement_speed * dir

		if is_on_floor():
			change_state(fsm.states.run)

		# update change to remote character
		if is_status_change:
			_send_character_ctrl_cmd("move", ctrl_cmd_queue)
		
		return true
	else:
		if velocity.x != 0:
			is_status_change = true
			# TODO: build remote ctrl cmd

		# change dir & speed
		velocity.x = 0
		
		if is_on_floor():
			change_state(fsm.states.idle)
		
		# update change to remote character
		if is_status_change:
			_send_character_ctrl_cmd("move", ctrl_cmd_queue)
		
	return false

#Control jumping
#Return true if jumping
func control_jump() -> bool:
	if not is_controllable:
		return false

	#If jump is pressed change to jump state and return true
	if Input.is_action_just_pressed("jump") and is_on_floor():
		# build remote ctrl cmd
		var ctrl_cmd_queue: Array = []
		ctrl_cmd_queue.push_back({"ctrl_code": "set_pos", "x": int(position.x), "y": int(position.y)})
		ctrl_cmd_queue.push_back({"ctrl_code": "set_spd", "spd": int(velocity.x)})
		ctrl_cmd_queue.push_back({"ctrl_code": "jumping"})
		jump ()
		change_state(fsm.states.jump)

		_send_character_ctrl_cmd("jump", ctrl_cmd_queue)
		return true

	return false


func control_attack() -> bool:
	if not is_controllable:
		return false
	if Input.is_action_just_pressed("attack") and can_attack():
		# TODO: build remote ctrl cmd
		var ctrl_cmd_queue: Array = []
		
		change_state(fsm.states.attack)
		
		# update change to remote character
		_send_character_ctrl_cmd("attack", ctrl_cmd_queue)
		return true
	return false


func control_throw() -> bool:
	if not is_controllable:
		return false
	if Input.is_action_just_pressed("throw") and can_attack():
		# TODO: build remote ctrl cmd
		var ctrl_cmd_queue: Array = []
		
		change_state(fsm.states.throw)
		
		# update change to remote character
		_send_character_ctrl_cmd("throw", ctrl_cmd_queue)
		return true
	return false


func _send_character_ctrl_cmd(action: String, ctrl_cmd_queue: Array) -> void:
	
	if not enable_remote_ctrl:
		return
	
	# TODO: build BC_REMOTE_CTRL cmd
	#var data = {		"cmd": CmdId.CMD_BROADCAST, 
					#"data": {
						#"cmdBc": CmdId.CMD_BC_REMOTE_CTRL, 
						#...
					#}
				#}
	# var json_data: String = JSON.stringify(data)
	#print("data = %s" % json_data)
	
	# send to game server
	# GameServerConnection.send_string(json_data)
	pass

# handle remote ctrl on character
func handle_remote_ctrl(action: String, ctrl_cmd_queue: Array) -> void:
	if is_controllable:
		return
		
	print("Handle remote ctrl cmd (%s): " % action)
	print(ctrl_cmd_queue)
	
	# TODO: hanlde remote ctrl
	
	pass


func remote_ctrl_moving(ctrl_cmd_queue: Array) -> void:
	# TODO: handle 'move' action
	pass


func remote_ctrl_jumping(ctrl_cmd_queue: Array) -> void:
	# TODO: handle 'jump' action
	pass
	

func remote_ctrl_attacking(ctrl_cmd_queue: Array) -> void:
	# TODO: handle 'attack' action
	pass
	

func remote_ctrl_throwing(ctrl_cmd_queue: Array) -> void:
	# TODO: handle 'throw' action
	pass
