extends FSMState

func _enter() -> void:
	#Change animation to jump
	obj.change_animation("jump")
	pass

func _update(_delta: float):
	#Control moving
	obj.control_moving()
	#Control throw
	var is_throw = obj.control_throw()
	if not is_throw:
		#Control attack
		obj.control_attack()
	#If velocity.y is greater than 0 change to fall
	if obj.velocity.y > 0:
		change_state(fsm.states.fall)
	pass
