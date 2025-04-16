extends CharacterBody3D

class_name Player

var move_direction : Vector2
var sprinting : bool

var default_parent : Node

enum PLAYER_STATE {
	PLAYER_CONTROL,
	BOAT
}

@export var playerStats : PlayerStats

var playerState : PLAYER_STATE = PLAYER_STATE.PLAYER_CONTROL

signal player_state_changed(new_state : PLAYER_STATE)

func _ready() -> void:
	default_parent = get_parent()
	playerStats.current_health = playerStats.max_health
	playerStats.current_stamina = playerStats.max_stamina
	change_player_state(playerState)

func _process(delta: float) -> void:
	if(playerStats.current_stamina < playerStats.max_stamina):
		playerStats.current_stamina += delta * playerStats.stamina_recover_speed
	else:
		playerStats.current_stamina = playerStats.max_stamina
	
	if(Input.is_action_just_pressed("enter_boat")):
		if(playerState == PLAYER_STATE.PLAYER_CONTROL):
			change_player_state(PLAYER_STATE.BOAT)
			reparent(%Boat.player_position_node)
			position = Vector3.ZERO
		elif(playerState == PLAYER_STATE.BOAT):
			change_player_state(PLAYER_STATE.PLAYER_CONTROL)
			reparent(default_parent)
	
	if(Input.is_action_just_pressed("interact")):
		if(!$"Head/Player Camera/Interact Area".interactables.is_empty()):
			var interactable : WorldInteractable = $"Head/Player Camera/Interact Area".interactables[0]
			interactable.interact()
	
func change_player_state(new_state : PLAYER_STATE):
	playerState = new_state
	player_state_changed.emit(new_state)
