extends RigidBody3D
class_name BoatBody3D

@export var float_force : float = 1.0
@export var water_drag : float = 0.05
@export var water_angular_drag : float = 0.05

@onready var gravity : Vector3 = Vector3(0, -9.8, 0)

@export var max_thrust_force : float = 1024
@export var max_steering : float = 128
@export var backwards_force_multiplier : float = 0.2

var steering: float = 0 # steering rudder angle in radians
var thrust_force: float = 0 # forward thrust force in Newtons


func _process(delta: float) -> void:
	if(Input.is_action_pressed("move_left") and $VehicleInteractable.player_in_boat):
		steer_left()
	if(Input.is_action_pressed("move_right") and $VehicleInteractable.player_in_boat):
		steer_right()
	if(Input.is_action_pressed("move_up") and $VehicleInteractable.player_in_boat):
		thrust()
	if(Input.is_action_pressed("move_down") and $VehicleInteractable.player_in_boat):
		backpedal()

func _physics_process(delta):
	apply_central_force(-self.global_transform.basis.z.normalized() * Vector3(1, 0, 1) * thrust_force)
	apply_torque(Vector3.UP * steering)
	
	##apply_torque(-global_transform.basis.z.normalized() * steering * 0.05) # for sideways motion
	
	reset_forces()

func _integrate_forces(state: PhysicsDirectBodyState3D):
	state.linear_velocity *=  1 - water_drag
	state.angular_velocity *= 1 - water_angular_drag 

func thrust():
	thrust_force = max_thrust_force

func backpedal():
	thrust_force = -max_thrust_force * backwards_force_multiplier

func steer_right():
	steering = -PI * max_steering

func steer_left():
	steering = PI * max_steering


func reset_forces():
	thrust_force = 0
	steering = 0
