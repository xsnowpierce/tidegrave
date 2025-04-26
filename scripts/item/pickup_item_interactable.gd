extends WorldInteractable

class_name PickupItemInteractable

@export var holding_item : InventoryItem
@export var held_amount : int = 1

var current_mesh : Node3D

func _ready() -> void:
	if(holding_item):
		spawn_mesh()

func set_item(item : InventoryItem, amount : int) -> void:
	holding_item = item
	held_amount = amount
	spawn_mesh()

func spawn_mesh() -> void:
	if(current_mesh):
		current_mesh.queue_free()
		
	current_mesh = holding_item.item_scene.instantiate()
	$"Mesh Centre".add_child(current_mesh)
	current_mesh.position = holding_item.centre_mesh_offset

func interact(player : Player) -> PlayerUseItem.USE_ITEM_RESULT:
	player.pickup_item(self)
	return PlayerUseItem.USE_ITEM_RESULT.IGNORE

func get_item_mesh_holder() -> Node3D:
	return $"Mesh Centre"
