extends PlayerState

func _enter() -> void:
	obj.disable_gravity = true
	obj.velocity = Vector2.ZERO
	obj.change_animation("climb")

func _update(delta: float) -> void:
	# Giữ nguyên vị trí (không bị gravity kéo xuống)
	obj.velocity.y = 0
	
	if not Input.is_action_pressed("climb") or not obj.is_on_wall():
		change_state(fsm.states.fall)
		return

	if Input.is_action_pressed("jump"):
		obj.velocity.x = -obj.direction * obj.movement_speed * 1.5
		obj.change_direction(-obj.direction)
		obj.velocity.y = -obj.jump_speed
		obj.just_wall_jumped = true
		obj.wall_jump_block_timer = obj.wall_jump_block_time
		change_state(fsm.states.jump)
		return
	
	
func _exit() -> void:
	obj.disable_gravity = false
