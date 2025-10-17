class_name PlayerState
extends FSMState

var cling_cooldown = 0.1
var cling_timer = 0.0

#Control moving and changing state to run
#Return true if moving
func control_moving() -> bool:
	var dir: float = Input.get_action_strength("right") - Input.get_action_strength("left")
	var is_moving: bool = abs(dir) > 0.1
	if is_moving:
		dir = sign(dir)
		obj.change_direction(dir)
		obj.velocity.x = obj.movement_speed * dir
		if obj.is_on_floor():
			change_state(fsm.states.run)
		return true
	else:
		obj.velocity.x = move_toward(obj.velocity.x, 0, obj.FRICTION * obj.movement_speed / 45)
		if(obj.is_on_floor()):
			if obj.velocity.x == 0:
				change_state(fsm.states.idle)
			else:
				change_state(fsm.states.run)
		else: change_state(fsm.states.fall)
	return false

#Control jumping
#Return true if jumping
func control_jump() -> bool:
	if (Input.is_action_just_pressed("jump") and (obj.is_on_floor() || obj.is_jumped_one)): 
		obj.jump()
		change_state(fsm.states.jump)
		return true
	return false
	
# Control climbing (wall cling)
# Return true if character is currently clinging
func control_climbing(delta: float) -> bool:
	if cling_timer > 0:
		cling_timer -= delta
		return false

	if obj.just_wall_jumped:
		return false

	if obj.is_on_wall() and Input.is_action_pressed("climb") and not obj.is_on_floor():
		cling_timer = cling_cooldown
		change_state(fsm.states.climb)
		return true
	return false
	
func control_dash() -> bool:
	if Input.is_action_just_pressed("dash") and not obj.is_dashing and obj.can_dash:
		change_state(fsm.states.dash)
		return true
	return false

func control_attack() -> bool:
	if Input.is_action_just_pressed("attack"):
		change_state(fsm.states.attack)
		return true
	elif Input.is_action_just_pressed("knife"):
		change_state(fsm.states.throwknife)
		return true
	return false

func take_damage(damage) -> void:
	if(obj.is_invulnerable == true && obj.health > 0):
		return
	#Player take damage
	obj.take_damage(damage)
	#Player die if health is 0 and change to dead state
	#Player hurt if health is not 0 and change to hurt state
	print(obj.health)
	if obj.health <= 0:
		change_state(fsm.states.dead)
	else:
		change_state(fsm.states.hurt)
