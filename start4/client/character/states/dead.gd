extends FSMState


func _enter() -> void:
	obj.stop_move()
	obj.change_animation("dead")
	timer = 2
	# turn off hurt collision
	var hurt_collision: CollisionShape2D = obj.get_node("Direction/HurtArea2D/CollisionShape2D")
	if hurt_collision != null:
		hurt_collision.disabled = true
	pass


func _exit() -> void:
	pass


func _update( _delta ):
	if update_timer(_delta):
		resetScene()
	pass


func resetScene():
	get_tree().reload_current_scene()
