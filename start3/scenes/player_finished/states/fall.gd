extends PlayerState

func _enter() -> void:
	obj.change_animation("fall")
func _update(_delta: float) -> void:
	if control_climbing(_delta):
		return
		
	if control_dash():
		return
	control_attack()
	control_jump()
	control_moving()
	if(obj.is_on_floor()):
		change_state(fsm.states.idle)
