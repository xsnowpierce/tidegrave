extends Node

class_name PlayerMovement

@export_category("Nodes")
@export var character : Player
@export var player_input: PlayerInput

@export_category("Speeds")
@export var SPEED: float = 4.0
@export var RUNNING_SPEED: float = 6.0
@export var JUMPING_VELOCITY: float = 5.0
@export var JUMPING_STAMINA_COST: float = 4.0
@export var ACCELERATION: float = 10.0
@export var DECELERATION: float = 8.0

@export_category("Falling")
@export_group("Fall Damage")
@export var FALL_DAMAGE_CUTOFF : float = 2.7
@export var FALL_DAMAGE_MULTIPLIER : float = 10
@export_group("Falling Animation")
@export var FALL_TILT_MULTIPLIER: float = 5.0
@export var FALL_SMOOTH_SPEED: float = 8.0


var current_head_tilt: float = 0.0
var current_speed: float
var player_has_control: bool
var air_fall_velocity : float = 0

func _process(delta: float) -> void:
	
	player_falling_animation()
	
	if not character.can_player_move():
		print("cant move")
		return
		
	if not character.is_on_floor():
		character.velocity += character.get_gravity() * delta
		if(character.velocity.y < 0.0):
			air_fall_velocity -= character.velocity.y * delta
	
	if(character.is_on_floor()):
		check_fall_damage(air_fall_velocity)
		air_fall_velocity = 0
	
	if player_has_control and character.is_on_floor():
		
		var target_speed := SPEED
		if player_input.sprinting:
			target_speed = RUNNING_SPEED
			
		var move_input := Vector2(player_input.move_direction.x, player_input.move_direction.y)
		var direction := (character.transform.basis * Vector3(move_input.x, 0, move_input.y)).normalized()
		
		var horizontal_velocity := Vector2(character.velocity.x, character.velocity.z)

		if direction.length() > 0:
			var target_velocity := Vector2(direction.x, direction.z) * target_speed
			horizontal_velocity = horizontal_velocity.move_toward(target_velocity, ACCELERATION * delta)
		else:
			horizontal_velocity = horizontal_velocity.move_toward(Vector2.ZERO, DECELERATION * delta)

		character.velocity.x = horizontal_velocity.x
		character.velocity.z = horizontal_velocity.y

		if Input.is_action_just_pressed("jump") and character.is_on_floor():
			character.get_player_stats().current_stamina = 0
			character.velocity.y = JUMPING_VELOCITY

	character.move_and_slide()


func get_velocity_magnitude() -> float:
	var horiz_velocity = character.velocity
	horiz_velocity.y = 0
	return horiz_velocity.length()

func _on_player_player_state_changed(new_state: Player.PLAYER_STATE) -> void:
	match new_state:
		Player.PLAYER_STATE.PLAYER_CONTROL:
			player_has_control = true
		Player.PLAYER_STATE.BOAT:
			player_has_control = false

func player_falling_animation() -> void:
	var head = $"../Head"
	var head_animator = $"../Head/HeadAnimator"

	var base_x_rotation = head.rotation_degrees.x
	var max_total_tilt = 90.0
	var min_total_tilt = -90.0

	var target_tilt: float
	if character.is_on_floor() or character.velocity.y >= -2.42:
		target_tilt = 0.0
	else:
		target_tilt = (character.velocity.y + 2.42) * FALL_TILT_MULTIPLIER

	current_head_tilt = lerp(current_head_tilt, target_tilt, FALL_SMOOTH_SPEED * get_process_delta_time())

	var combined_rotation = base_x_rotation + current_head_tilt
	if combined_rotation > max_total_tilt:
		current_head_tilt = max_total_tilt - base_x_rotation
	elif combined_rotation < min_total_tilt:
		current_head_tilt = min_total_tilt - base_x_rotation

	head_animator.rotation_degrees.x = current_head_tilt

func check_fall_damage(velocity : float) -> void:
	velocity -= FALL_DAMAGE_CUTOFF
	if(velocity <= 0):
		return
	
	velocity *= FALL_DAMAGE_MULTIPLIER
	var fall_damage : int = ceili(velocity)
	
	var damage_value : DamageValue = DamageValue.new()
	damage_value.damage_amount_unscaled = fall_damage
	
	$"../PlayerHitbox".player_attacked.emit(damage_value)
