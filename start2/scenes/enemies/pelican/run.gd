extends EnemyState

@export var shoot_interval: float = 2.0
var shoot_cooldown: float = 0.0

func _enter() -> void:
	obj.change_animation("run")
	shoot_cooldown = shoot_interval 
func _update(delta: float) -> void:
	obj.velocity.y = 0
	obj.velocity.x = obj.direction * obj.movement_speed * 0.8
	if _should_turn_around():
		obj.turn_around()
	if fsm.states.has("shoot"):
		shoot_cooldown -= delta
		if shoot_cooldown <= 0:
			change_state(fsm.states.shoot)

func _should_turn_around() -> bool:
	if obj.is_touch_wall():
		return true
	return false
