extends EnemyCharacter

@onready var bullet_factory := $Direction/BulletFactory
@export var angle_deg: float = 60.0 
@export var bullet_speed: float = 200.0 

func _ready() -> void:
	fsm = FSM.new(self, $States, $States/Run)
	super._ready()

func fire() -> void:
	var bullet := bullet_factory.create() as RigidBody2D
	var angle = deg_to_rad(angle_deg)
	var shooting_velocity = Vector2(cos(angle), -sin(angle)) * bullet_speed * direction
	#bullet.linear_velocity = velocity
	#var shooting_velocity := Vector2(0.0, bullet_speed_y)
	bullet.apply_impulse(shooting_velocity) 
