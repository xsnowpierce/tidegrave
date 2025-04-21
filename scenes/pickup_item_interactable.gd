extends WorldInteractable

class_name PickupItemInteractable

@export var holding_item : InventoryItem
@export var held_amount : int = 1

func interact(player : Player) -> void:
	player.pickup_item(self)

func get_item_mesh_holder() -> Node3D:
	return $"Mesh Centre"
