extends CharacterBody3D

class_name Player

var move_direction : Vector2
var sprinting : bool

var default_parent : Node

enum PLAYER_STATE {
	PLAYER_CONTROL,
	BOAT,
	PICKUP_ITEM
}

var playerState : PLAYER_STATE = PLAYER_STATE.PLAYER_CONTROL

signal player_state_changed(new_state : PLAYER_STATE)

func _ready() -> void:
	default_parent = get_parent()
	
	change_player_state(playerState)

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

func get_pickup_item_location() -> Node3D:
	return $"Head/Player Camera/Item Pickup Position"

func pickup_item(item : PickupItemInteractable) -> void:
	change_player_state(PLAYER_STATE.PICKUP_ITEM)
	%PlayerPickupItem.pickup_item(item)

func can_player_move() -> bool:
	if(playerState != PLAYER_STATE.PLAYER_CONTROL):
		return false
	return true

func can_player_look() -> bool:
	if((playerState != PLAYER_STATE.PLAYER_CONTROL and playerState != PLAYER_STATE.BOAT) or %"Pause Menu".pause_menu_open):
		return false
	return true

func can_player_attack() -> bool:
	return can_player_move() and !%"Pause Menu".pause_menu_open

func get_inventory() -> PlayerInventory:
	return %"PlayerInventory"

func get_use_item() -> PlayerUseItem:
	return %PlayerUseItem

func get_camera_rotation() -> Vector3:
	return $"%Player Camera".global_rotation
