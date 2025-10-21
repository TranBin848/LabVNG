class_name Player
extends BaseCharacter

## Player character class that handles movement, combat, and state management
var is_invulnerable: bool = false
@export var invulnerability_duration: float = 2
var invul_timer: float = 0.0
@export var has_blade: bool = false

@export var knife_speed: float = 300
@onready var knife_factory := $Direction/KnifeFactory

func _ready() -> void:
	super._ready()
	fsm = FSM.new(self, $States, $States/Idle)
	if has_blade:
		collected_blade()
	GameManager.player = self	
func can_attack() -> bool:
	return has_blade

func collected_blade() -> void:
	has_blade = true
	set_animated_sprite($Direction/BladeAnimatedSprite2D)
			
func enable_invulnerability():
	is_invulnerable = true
	invul_timer = invulnerability_duration			

func _process(delta):
	if is_invulnerable:
		invul_timer -= delta
		if invul_timer <= 0:
			is_invulnerable = false

func fire() -> void:
	var knife := knife_factory.create() as RigidBody2D
	var shooting_velocity := Vector2(knife_speed * direction, 0.0)
	var knife_sprite = knife.get_node("Sprite2D")
	if direction < 0:
		knife_sprite.flip_h = true
	knife.apply_impulse(shooting_velocity)

func _on_hurt_area_2d_hurt(_direction: Variant, _damage: Variant) -> void:
	fsm.current_state.take_damage(_damage)

func save_state() -> Dictionary:
	return {
		"position": [global_position.x, global_position.y]
	}

func load_state(data: Dictionary) -> void:
	"""Load player state from checkpoint data"""
	if data.has("position"):
		var pos_array = data["position"]
		global_position = Vector2(pos_array[0], pos_array[1])
