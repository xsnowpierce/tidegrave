extends RigidBody3D

@export var boat_move_speed : float = 5
@export var boat_deceleration : float = 1
@export var boat_acceleration : float = 1

var boat_current_speed : float = 0
var boat_rotation_speed : float = 0
@export var boat_max_rotation_speed : float = 1

@export var player_position_node : Node3D

func _process(delta: float) -> void:
	
	boat_movement()

func boat_movement() -> void:
	boat_input()
	
	var direction : Vector3 = Vector3($boat.global_basis.x.x, 0, $boat.global_basis.x.z)
	linear_velocity = direction * clampf(boat_current_speed, -boat_move_speed / 2, boat_move_speed)
	angular_velocity = -Vector3(0, clampf(boat_rotation_speed * (boat_current_speed / boat_move_speed), -boat_max_rotation_speed, boat_max_rotation_speed), 0)

func boat_input() -> void:
	if(Input.is_action_pressed("move_up") and $VehicleInteractable.player_in_boat):
		boat_current_speed += boat_acceleration * get_process_delta_time()
		boat_current_speed = clampf(boat_current_speed, -boat_move_speed / 2, boat_move_speed)
	else:
		if(boat_current_speed > 0):
			boat_current_speed -= boat_deceleration * get_process_delta_time()
		elif(boat_current_speed < 0):
			boat_current_speed += boat_deceleration * get_process_delta_time()
			
	var rotation : float = Input.get_axis("move_left", "move_right")
	
	if(rotation != 0.0 and $VehicleInteractable.player_in_boat):
		boat_rotation_speed += rotation * boat_acceleration * get_process_delta_time()
		boat_rotation_speed = clampf(boat_rotation_speed, -boat_max_rotation_speed, boat_max_rotation_speed)
	else:
		if(boat_rotation_speed > 0):
			boat_rotation_speed -= boat_deceleration * get_process_delta_time()
		elif(boat_rotation_speed < 0):
			boat_rotation_speed += boat_deceleration * get_process_delta_time()
