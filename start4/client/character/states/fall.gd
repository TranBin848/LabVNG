extends FSMState

func _enter() -> void:
	#Change animation to fall
	obj.change_animation("fall")
	pass

func _update(_delta: float) -> void:
	#Control moving
	var is_moving: bool = obj.control_moving()
	#Control throw
	var is_throw = obj.control_throw()
	if not is_throw:
		#Control attack
		obj.control_attack()
	#If on floor change to idle if not moving and not jumping
	if obj.is_on_floor() and not is_moving:
		change_state(fsm.states.idle)
	pass
