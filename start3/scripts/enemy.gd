class_name EnemyCharacter
extends BaseCharacter
# Raycast check wall and fall
var front_ray_cast: RayCast2D;
var down_ray_cast: RayCast2D;

# detect player area
var detect_player_area: Area2D;
var found_player: Player = null

var front_detect_ray: RayCast2D
var back_detect_ray: RayCast2D

func _ready() -> void:
	_init_ray_cast()
	_init_detect_player_area()
	_init_detect_player_ray_casts()
	_init_hurt_area()
	super._ready()
	pass


#init ray cast to check wall and fall
func _init_ray_cast():
	if has_node("Direction/FrontRayCast2D"):
		front_ray_cast = $Direction/FrontRayCast2D
	if has_node("Direction/DownRayCast2D"):
		down_ray_cast = $Direction/DownRayCast2D

# Initialization function for player detection RayCasts
func _init_detect_player_ray_casts() -> void:
	# Initialize Front Detection RayCast
	if has_node("Direction/FrontDetectPlayerRayCast2D"):
		front_detect_ray = $Direction/FrontDetectPlayerRayCast2D
	# Initialize Back Detection RayCast
	if has_node("Direction/BackDetectPlayerRayCast2D"):
		back_detect_ray = $Direction/BackDetectPlayerRayCast2D

#init detect player area
func _init_detect_player_area():
	if has_node("Direction/DetectPlayerArea2D"):
		detect_player_area = $Direction/DetectPlayerArea2D
		detect_player_area.body_entered.connect(_on_body_entered)
		detect_player_area.body_exited.connect(_on_body_exited)

# init hurt area
func _init_hurt_area():
	if has_node("Direction/HurtArea2D"):
		var hurt_area = $Direction/HurtArea2D
		hurt_area.hurt.connect(_on_hurt_area_2d_hurt)

# check touch wall
func is_touch_wall() -> bool:
	if front_ray_cast != null:
		return front_ray_cast.is_colliding()
	return false

# check can fall
func is_can_fall() -> bool:
	if down_ray_cast != null:
		return not down_ray_cast.is_colliding()
	return false

#enable check player in sight
func enable_check_player_in_sight() -> void:
	if(detect_player_area != null):
		detect_player_area.get_node("CollisionShape2D").disabled = false

#disable check player in sight
func disable_check_player_in_sight() -> void:
	if(detect_player_area != null):
		detect_player_area.get_node("CollisionShape2D").disabled = true


func _on_body_exited(_body: CharacterBody2D) -> void:
	if _body is Player:
		found_player = null
		_on_player_not_in_sight()

func _on_body_entered(_body: CharacterBody2D) -> void:
	if _body is Player:
		found_player = _body as Player 
		_on_player_in_sight(_body.global_position)
	else:
		pass

func _on_hurt_area_2d_hurt(_direction: Vector2, _damage: float) -> void:
	_take_damage_from_dir(_direction, _damage)

# called when player is in sight
func _on_player_in_sight(_player_pos: Vector2):
	pass

# called when player is not in sight
func _on_player_not_in_sight():
	pass

# Check if player is detected by either raycast
func is_player_detected_by_raycast() -> bool:
	# Check front raycast
	if front_detect_ray and front_detect_ray.is_colliding():
		if front_detect_ray.get_collider() is Player:
			found_player = front_detect_ray.get_collider() as Player
			return true
	# Check back raycast
	if back_detect_ray and back_detect_ray.is_colliding():
		if back_detect_ray.get_collider() is Player:
			found_player = back_detect_ray.get_collider() as Player
			return true
	
	found_player = null		
	return false

func _take_damage_from_dir(_damage_dir: Vector2, _damage: float):
	fsm.current_state.take_damage(_damage_dir, _damage)
