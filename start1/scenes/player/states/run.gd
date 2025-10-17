extends PlayerState

func _enter() -> void:
	obj.change_animation("run")
func _update(delta: float):
	if control_dash():
		return
	
	control_jump()
	
	control_moving()
	
	if(!obj.is_on_floor()):
		change_state(fsm.states.fall)
	
	pass
