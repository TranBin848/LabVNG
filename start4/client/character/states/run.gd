extends FSMState

func _enter() -> void:
	#Change animation to run
	obj.change_animation("run")
	pass

func _update(_delta: float):
	#Control jump
	if obj.control_jump():
		return
	#Control throw
	var is_throw = obj.control_throw()
	if not is_throw:
		#Control attack
		obj.control_attack()

	#Control moving and idle
	obj.control_moving()

	#If not on floor change to fall
	if not obj.is_on_floor():
		change_state(fsm.states.fall)
	pass
