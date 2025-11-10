extends FSMState

var _timer = 0
const TIME_OUT = 0.5
const PUSH_BACK_VELOCITY_Y = -300
func _enter() -> void:
	obj.change_animation("hurt")
	obj.velocity.y = PUSH_BACK_VELOCITY_Y
	obj.velocity.x = -0.5*obj.velocity.x
	(obj as Player).set_invulnerable(true)
	pass

func _exit() -> void:
	_timer = 0
	pass

func _update( _delta ):
	_timer += _delta
	if _timer >= TIME_OUT:
		change_state(fsm.states.idle)
	pass
