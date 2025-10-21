extends AnimatableBody2D

@export var move_speed: float = 100.0
@export var move_distance: float = 200.0
@export var acceleration: float = 200.0   # tốc độ tăng/giảm vận tốc
@export var wait_time: float = 0.5        # dừng lại một chút ở hai đầu

var start_position: Vector2
var direction: int = 1
var velocity: float = 0.0
var target_velocity: float = 0.0
var is_waiting: bool = false

func _ready():
	start_position = global_position

func _physics_process(delta):
	if is_waiting:
		return

	var target_y = start_position.y + (move_distance * direction)

	# Nếu gần tới giới hạn thì chuẩn bị đổi hướng
	if direction == 1 and global_position.y >= target_y:
		direction = -1
		_start_wait()
	elif direction == -1 and global_position.y <= start_position.y - move_distance:
		direction = 1
		_start_wait()

	# Xác định vận tốc mục tiêu (hướng lên hoặc xuống)
	target_velocity = move_speed * direction

	# Dùng move_toward để thay đổi vận tốc dần dần
	velocity = move_toward(velocity, target_velocity, acceleration * delta)

	# Di chuyển platform
	global_position.y += velocity * delta

func _start_wait() -> void:
	is_waiting = true
	velocity = 0.0
	await get_tree().create_timer(wait_time).timeout
	is_waiting = false
