extends PlayerState

func _enter() -> void:
	obj.change_animation("jump")
func _update(delta: float):
	if not obj.just_wall_jumped:
		if control_climbing(delta):
			return
	
	if control_dash():
		return
	
	control_attack()
	control_jump()
	control_moving()
	
	if not obj.is_on_wall() and obj.velocity.y > 0:
		change_state(fsm.states.fall)
		return
