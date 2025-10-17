extends EnemyState

@export var shoot_delay: float = 0.1  
@export var burst_delay: float = 0.3   
@export var bullet_count: int = 3        
@export var state_duration: float = 0.9

var shoot_timer: float = 0.0
var burst_counter: int = 0

func _enter() -> void:
	obj.change_animation("shoot")
	obj.velocity.x = 0
	shoot_timer = shoot_delay
	timer = state_duration 
	burst_counter = 0

func _update(delta: float) -> void:
	obj.velocity.y = 0
	if burst_counter < bullet_count:
		shoot_timer -= delta
		if shoot_timer <= 0:
			obj.fire() 
			burst_counter += 1
			if burst_counter < bullet_count:
				shoot_timer = burst_delay 
	if update_timer(delta):
		fsm.previous_state.shoot_cooldown = fsm.previous_state.shoot_interval
		change_state(fsm.previous_state)
