extends PlayerState

func _enter() -> void:
	obj.is_dashing = true
	obj.can_dash = false  # 🔒 khóa dash
	obj.dash_cooldown_timer = obj.dash_cooldown  # bắt đầu cooldown

	obj.velocity = Vector2(obj.direction * obj.dash_speed, 0)
	obj.change_animation("dash")
	obj.dash_timer = obj.dash_time

func _update(delta: float) -> void:
	obj.dash_timer -= delta
	obj.velocity = Vector2(obj.direction * obj.dash_speed, 0)

	if obj.dash_timer <= 0:
		obj.is_dashing = false
		change_state(fsm.states.fall)

func _exit() -> void:
	obj.is_dashing = false
