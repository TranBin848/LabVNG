extends AnimatableBody2D

@export var move_speed: float = 100.0
@export var move_distance: float = 300.0

var start_position: Vector2
var is_moving: bool = false
var direction: int = -1  # -1 = đi lên, 1 = đi xuống

func _ready():
	start_position = global_position


func _physics_process(delta):
	if not is_moving:
		return

	global_position.y += move_speed * direction * delta

	# Nếu đi lên tới giới hạn trên
	if direction == -1 and global_position.y <= start_position.y - move_distance:
		global_position.y = start_position.y - move_distance
		is_moving = false
		direction = 1 

	# Nếu đi xuống tới giới hạn dưới
	elif direction == 1 and global_position.y >= start_position.y:
		global_position.y = start_position.y
		is_moving = false
		direction = -1 

func _on_interactive_area_2d_interacted() -> void:
	if not is_moving:
		is_moving = true
