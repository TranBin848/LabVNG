extends FSMState


func _enter() -> void:
	timer = 0.2
	obj.velocity.x = 0
	var animation_name = "attack" if obj.is_on_floor() else "jump_attack"
	obj.change_animation(animation_name)
	(obj as Player).set_disable_hit_collision(false)
	pass


func _exit() -> void:
	(obj as Player).set_disable_hit_collision(true)
	pass


func _update( _delta ):
	if update_timer(_delta):
		change_state(fsm.previous_state)
	pass
