extends Node

class_name PlayerMovement

@export var character3d: Player
@export var player_input: PlayerInput
@export var SPEED: float = 4.0
@export var RUNNING_SPEED: float = 6.0
@export var JUMPING_VELOCITY: float = 5.0
@export var JUMPING_STAMINA_COST: float = 4.0
@export var ACCELERATION: float = 10.0
@export var DECELERATION: float = 8.0

var current_speed: float
var player_has_control: bool
var character: Player

func _ready() -> void:
	character = get_parent()

func _process(delta: float) -> void:
	if not character.can_player_move():
		return

	if not character3d.is_on_floor():
		character3d.velocity += character3d.get_gravity() * delta

	if player_has_control and character.is_on_floor():
		
		var target_speed := SPEED
		if player_input.sprinting:
			target_speed = RUNNING_SPEED
			
		var move_input := Vector2(player_input.move_direction.x, player_input.move_direction.y)
		var direction := (character3d.transform.basis * Vector3(move_input.x, 0, move_input.y)).normalized()
		
		var horizontal_velocity := Vector2(character3d.velocity.x, character3d.velocity.z)

		if direction.length() > 0:
			var target_velocity := Vector2(direction.x, direction.z) * target_speed
			horizontal_velocity = horizontal_velocity.move_toward(target_velocity, ACCELERATION * delta)
		else:
			horizontal_velocity = horizontal_velocity.move_toward(Vector2.ZERO, DECELERATION * delta)

		character3d.velocity.x = horizontal_velocity.x
		character3d.velocity.z = horizontal_velocity.y

		if Input.is_action_just_pressed("jump") and character3d.is_on_floor():
			character3d.get_player_stats().current_stamina = 0
			character3d.velocity.y = JUMPING_VELOCITY

	character3d.move_and_slide()


func get_velocity_magnitude() -> float:
	var horiz_velocity = character3d.velocity
	horiz_velocity.y = 0
	return horiz_velocity.length()

func _on_player_player_state_changed(new_state: Player.PLAYER_STATE) -> void:
	match new_state:
		Player.PLAYER_STATE.PLAYER_CONTROL:
			player_has_control = true
		Player.PLAYER_STATE.BOAT:
			player_has_control = false
