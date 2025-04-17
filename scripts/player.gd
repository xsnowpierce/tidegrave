extends CharacterBody3D

class_name Player

var move_direction : Vector2
var sprinting : bool

var default_parent : Node

enum PLAYER_STATE {
	PLAYER_CONTROL,
	BOAT
}

var playerState : PLAYER_STATE = PLAYER_STATE.PLAYER_CONTROL

signal player_state_changed(new_state : PLAYER_STATE)

func _ready() -> void:
	default_parent = get_parent()
	
	change_player_state(playerState)

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("interact")):
		if(!$"Head/Player Camera/Interact Area".interactables.is_empty()):
			var interactable : WorldInteractable = $"Head/Player Camera/Interact Area".interactables[0]
			interactable.interact(self)
	
func change_player_state(new_state : PLAYER_STATE):
	playerState = new_state
	player_state_changed.emit(new_state)

func enter_boat(boat : VehicleInteractable) -> void:
	change_player_state(PLAYER_STATE.BOAT)
	reparent(boat.get_player_position_node())
	position = Vector3.ZERO

func exit_boat() -> void:
	change_player_state(PLAYER_STATE.PLAYER_CONTROL)
	reparent(default_parent)

func get_player_stats() -> PlayerStats:
	return $PlayerStats
