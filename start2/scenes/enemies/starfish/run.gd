extends EnemyState

func _enter() -> void:

	obj.change_animation("run")


func _update(delta):
	obj.velocity.x = obj.direction * obj.movement_speed * 0.8
	if _should_turn_around():
		obj.turn_around()
	if obj.is_player_detected_by_raycast():
		var target_position = obj.found_player.global_position if obj.found_player else obj.global_position
		if obj.found_player:
			if obj.found_player.global_position.x > obj.global_position.x:
				obj.turn_right()
			else:
				obj.turn_left()
		change_state(fsm.states.attack)


func _should_turn_around() -> bool:
	if obj.is_touch_wall():
		return true
	if obj.is_on_floor() and obj.is_can_fall():
		return true
	return false
	
