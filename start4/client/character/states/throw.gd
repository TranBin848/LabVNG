extends FSMState

var throw_timer


func _enter() -> void:
	timer = 0.5
	throw_timer = 0.2
	var animation_name = "throw" if obj.is_on_floor() else "jump_throw"
	obj.change_animation(animation_name)
	pass


func _exit() -> void:
	(obj as Player).removed_blade()
	pass


func _update( _delta ):
	if throw_timer > 0:
		throw_timer -= _delta
		if throw_timer <= 0:
			(obj as Player).throw_blade()
			
	if update_timer(_delta):
		change_state(fsm.previous_state)
	pass
