class_name BaseCharacter
extends CharacterBody2D

## Base character class that provides common functionality for all characters
const FRICTION = 2.5
@export var movement_speed: float = 200.0
@export var gravity: float = 700.0
@export var direction: int = 1

var just_wall_jumped := false
var wall_jump_block_time := 0.75
var wall_jump_block_timer := 0.0

var is_dashing: bool = false
var dash_speed: float = 500.0
var dash_time: float = 0.15
var dash_timer: float = 0.0

var can_dash: bool = true
var dash_cooldown: float = 0.8
var dash_cooldown_timer: float = 0.0

@export var attack_damage: int = 1
@export var max_health: int = 3
var health: int = max_health

@onready var hit_area_2d: HitArea2D = $Direction/HitArea2D

var jump_speed: float = 320.0
var is_jumped_one = false
var fsm: FSM = null
var current_animation = null

var animated_sprite: AnimatedSprite2D = null
@onready var extra_sprites: Array[AnimatedSprite2D] = []


var _next_animation = null
var _next_direction: int = 1
var _next_animated_sprite: AnimatedSprite2D = null

func _ready() -> void:
	set_animated_sprite($Direction/AnimatedSprite2D)
	
	
func _physics_process(delta: float) -> void:
	# Animation
	_check_changed_animation()
	
	if wall_jump_block_timer > 0:
		wall_jump_block_timer -= delta
		if wall_jump_block_timer <= 0:
			just_wall_jumped = false
			
	if not can_dash:
		dash_cooldown_timer -= delta
		if dash_cooldown_timer <= 0:
			can_dash = true
	
	if fsm != null:
		fsm._update(delta)

	# Chỉ cập nhật movement nếu KHÔNG phải đang climb
	if fsm == null or not fsm.is_in_state("climb"):
		_update_movement(delta)

	# Direction
	_check_changed_direction()


func _update_movement(delta: float) -> void:
	velocity.y += gravity * delta
	move_and_slide()
	pass


func turn_around() -> void:
	if _next_direction != direction:
		return
	_next_direction = -direction

func is_left() -> bool:
	return direction == -1

func is_right() -> bool:
	return direction == 1

func turn_left() -> void:
	_next_direction = -1

func turn_right() -> void:
	_next_direction = 1

func jump() -> void:
	if(is_on_floor()): is_jumped_one = true;
	else: is_jumped_one = false
	velocity.y = -jump_speed

func stop_move() -> void:
	velocity.x = 0
	velocity.y = 0

func take_damage(damage: int) -> void:
	health -= damage

# Change the animation of the character on the next frame
func change_animation(new_animation: String) -> void:
	_next_animation = new_animation

# Change the direction of the character on the last frame
func change_direction(new_direction: int) -> void:
	_next_direction = new_direction

# Get the name of the current animation
func get_animation_name() -> String:
	return current_animation.name

func set_animated_sprite(new_animated_sprite: AnimatedSprite2D) -> void:
	_next_animated_sprite = new_animated_sprite

# Check if the animation or animated sprite has changed and play the new animation
func _check_changed_animation() -> void:
	var need_play := false
	if _next_animation != current_animation:
		current_animation = _next_animation
		need_play = true
	if _next_animated_sprite != animated_sprite:
		if animated_sprite != null:
			animated_sprite.hide()
		animated_sprite = _next_animated_sprite
		animated_sprite.show()
		need_play = true
	if need_play and current_animation != null:
		if animated_sprite != null:
			animated_sprite.play(current_animation)
		for sprite in extra_sprites:
			if sprite != null:
				sprite.play(current_animation)


# Check if the direction has changed and set the new direction
func _check_changed_direction() -> void:
	if _next_direction != direction:
		direction = _next_direction
		_on_changed_direction()
		if direction == -1:
			$Direction.scale.x = -1
		if direction == 1:
			$Direction.scale.x = 1

# On changed direction
func _on_changed_direction() -> void:
	pass

func is_touching_wall() -> bool:
	if is_on_wall():
		# Kiểm tra hướng va chạm có cùng hướng di chuyển
		var wall_normal = get_last_slide_collision().get_normal()
		if wall_normal != null:
			# Nếu nhân vật đang facing phải mà tường ở bên phải → dính
			if (direction == 1 and wall_normal.x < 0) or (direction == -1 and wall_normal.x > 0):
				return true
	return false
