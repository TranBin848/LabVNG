extends PlayerState

@export var reload_delay: float = 0.4

func _enter():
	obj.change_animation("dead")
	obj.velocity.x = 0
	timer = 2
	#var timer = get_tree().create_timer(reload_delay)
	#await timer.timeout
	#obj.get_tree().call_deferred("reload_current_scene")

func _update(delta: float):
	if update_timer(delta):
		obj.get_tree().reload_current_scene()
