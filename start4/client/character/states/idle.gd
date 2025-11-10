extends FSMState

## Idle state for player character

func _enter() -> void:
	obj.change_animation("idle")

func _update(_delta: float) -> void:
	#Control jump
	obj.control_jump()
	#Control moving
	obj.control_moving()
	
	#Control throw
	var is_throw = obj.control_throw()
	
	if not is_throw:
		#Control attack
		obj.control_attack()
		
	#If not on floor change to fall
	if not obj.is_on_floor():
		change_state(fsm.states.fall)
