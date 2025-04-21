extends Node

class_name PlayerPickupItem

@export var move_speed : float = 1
@export var post_move_rotate_speed : float = 1

var camera_rotation_before_item_pickup 

var current_item_pickup : PickupItemInteractable
var current_item_original_position : Vector3
var current_item_original_rotation : Vector3

var waiting_for_input : bool

var player_accepted_item : bool
var player_declined_item : bool

var character : Player

func _ready() -> void:
	character = get_parent()

func pickup_item(item : PickupItemInteractable) -> void:
	if(current_item_pickup):
		return
	current_item_pickup = item
	current_item_original_position = item.global_position
	current_item_original_rotation = item.global_rotation
	
	var mesh : Node3D = item.get_item_mesh_holder()
	var target_item_position : Vector3 = %"Item Pickup Position".global_position
	var tween : Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(mesh, "global_position", target_item_position, move_speed)
	tween.tween_property(mesh, "global_rotation", %"Item Pickup Position".global_rotation, move_speed)
	
	camera_rotation_before_item_pickup = %"Player Camera".global_rotation
	
	%"Player Camera".look_at(%"Item Pickup Position".global_position)
	
	var new_camera_rotation = %"Player Camera".global_rotation
	
	%"Player Camera".global_rotation = camera_rotation_before_item_pickup
	
	tween.tween_property(%"Player Camera", "global_rotation", new_camera_rotation, move_speed)
	
	%HUD.show_interact_message(current_item_pickup.holding_item.name)
	
	while(tween.is_running()):
		await get_tree().process_frame
	
	waiting_for_input = true
	while(!player_accepted_item and !player_declined_item):
		mesh.rotate_y(post_move_rotate_speed * get_process_delta_time())
		await get_tree().process_frame
	waiting_for_input = false
	
	if(player_accepted_item):
		accept_current_item()
	else:
		decline_current_item()
	
	player_accepted_item = false
	player_declined_item = false

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("item_pickup_accept") and current_item_pickup and waiting_for_input):
		player_accepted_item = true
	
	elif(Input.is_action_just_pressed("item_pickup_decline") and current_item_pickup and waiting_for_input):
		player_declined_item = true

func accept_current_item() -> void:
	%PlayerInventory.add_item_to_inventory(current_item_pickup.holding_item, current_item_pickup.held_amount)
	
	var tween : Tween = create_tween()
	
	var target_item_position : Vector3 = %"Item Accept Pickup Position".global_position
	tween.set_parallel(true)
	tween.tween_property(current_item_pickup.get_item_mesh_holder(), "global_position", target_item_position, move_speed)
	tween.tween_property(%"Player Camera", "global_rotation", camera_rotation_before_item_pickup, move_speed)
	
	while(tween.is_running()):
		await get_tree().process_frame
	
	current_item_pickup.queue_free()
	character.change_player_state(character.PLAYER_STATE.PLAYER_CONTROL)
	
	current_item_pickup = null
	current_item_original_position = Vector3.ZERO
	current_item_original_rotation = Vector3.ZERO

func decline_current_item() -> void:
	var tween : Tween = create_tween()
	
	tween.set_parallel(true)
	tween.tween_property(current_item_pickup.get_item_mesh_holder(), "global_position", current_item_original_position, move_speed)
	tween.tween_property(current_item_pickup.get_item_mesh_holder(), "global_rotation", current_item_original_rotation, move_speed)
	tween.tween_property(%"Player Camera", "global_rotation", camera_rotation_before_item_pickup, move_speed)
	
	while(tween.is_running()):
		await get_tree().process_frame
	
	character.change_player_state(character.PLAYER_STATE.PLAYER_CONTROL)
	
	current_item_pickup = null
	current_item_original_position = Vector3.ZERO
	current_item_original_rotation = Vector3.ZERO
