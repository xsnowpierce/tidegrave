extends WorldInteractable

class_name VehicleInteractable

var player_in_boat : bool

@export var player_position_node : Node3D

func interact(player : Player):
	if(!player_in_boat):
		player.enter_boat(self)
		player_in_boat = true
	else:
		player.exit_boat()
		player_in_boat = false

func get_player_position_node() -> Node3D:
	return player_position_node
