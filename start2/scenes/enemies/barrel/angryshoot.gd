extends EnemyState

# Độ trễ giữa các lần bắn trong cùng một loạt (nếu cần)
@export var burst_delay: float = 0.3
# Số lượng đạn bắn ra
@export var bullet_count: int = 3

@export var initial_shoot_delay: float = 1.2 # Độ trễ ban đầu trước khi bắt đầu bắn
var shoot_timer: float = 0.0
var burst_counter: int = 0

func _enter() -> void:
	# Vẫn giữ animation bắn
	obj.change_animation("shoot")
	# Đặt timer cho độ trễ ban đầu
	shoot_timer = initial_shoot_delay
	# Đặt tổng thời gian ở trong trạng thái này (phụ thuộc vào animation)
	timer = 2
	# Reset bộ đếm loạt đạn
	burst_counter = 0

func _update(delta: float) -> void:
	# 1. Logic đợi độ trễ ban đầu
	if shoot_timer > 0:
		shoot_timer -= delta
		# Khi timer ban đầu hết, bắt đầu logic bắn loạt
		if shoot_timer <= 0:
			burst_counter = 1 # Bắn viên đầu tiên
			obj.fire() # Bắn viên đạn đầu tiên
			shoot_timer = burst_delay # Đặt timer cho viên tiếp theo
			
	# 2. Logic bắn loạt
	elif burst_counter > 0 and burst_counter < bullet_count:
		shoot_timer -= delta
		if shoot_timer <= 0:
			burst_counter += 1
			obj.fire() # Bắn viên tiếp theo
			shoot_timer = burst_delay # Đặt timer cho viên kế tiếp
			
	# 3. Logic chuyển trạng thái khi DeadState kết thúc
	if update_timer(delta):
		change_state(fsm.previous_state)
