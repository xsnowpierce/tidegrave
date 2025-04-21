extends Node

class_name PlayerMovement

@export var character3d : Player;
@export var player_input : PlayerInput;
@export var SPEED : float = 4.0;
@export var RUNNING_SPEED : float = 6;
@export var JUMPING_VELOCITY : float = 5;
@export var JUMPING_STAMINA_COST : float = 4;
var current_speed : float;
var player_has_control : bool

var character : Player

func _ready() -> void:
	character = get_parent()

func _process(delta: float) -> void:
	if(!character.can_player_move()):
		return
	if not character3d.is_on_floor():
		character3d.velocity += character3d.get_gravity() * delta;
	
	if(player_has_control):
		if(player_input.sprinting):
			current_speed = RUNNING_SPEED;
		else:
			current_speed = SPEED;
		
		var direction := (character3d.transform.basis * Vector3(player_input.move_direction.x, 0, player_input.move_direction.y));
		if direction:
			character3d.velocity.x = direction.x * current_speed;
			character3d.velocity.z = direction.z * current_speed;
		else:
			character3d.velocity.x = move_toward(character3d.velocity.x, 0, current_speed);
			character3d.velocity.z = move_toward(character3d.velocity.z, 0, current_speed);

		if(Input.is_action_just_pressed("jump") and character3d.is_on_floor()):
			character3d.get_player_stats().current_stamina = 0;
			character3d.velocity.y = JUMPING_VELOCITY;

	character3d.move_and_slide();

func get_velocity_magnitude() -> float:
	var horiz_velocity = character3d.velocity;
	horiz_velocity.y = 0;
	return horiz_velocity.length();


func _on_player_player_state_changed(new_state: Player.PLAYER_STATE) -> void:
	match(new_state):
		Player.PLAYER_STATE.PLAYER_CONTROL:
			player_has_control = true
		Player.PLAYER_STATE.BOAT:
			player_has_control = false
