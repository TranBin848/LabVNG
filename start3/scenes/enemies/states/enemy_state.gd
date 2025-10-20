extends FSMState
class_name EnemyState

func take_damage(_damage_dir, damage: int) -> void:
	#obj.velocity.x = _damage_dir.x * 150
	obj.take_damage(damage)
	if obj.health <= 0:
		change_state(fsm.states.dead)
	else:
		change_state(fsm.states.hurt)
