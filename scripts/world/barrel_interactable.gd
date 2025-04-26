extends WorldInteractable

class_name BarrelInteractable

var item_spawn_offset : Vector3 = Vector3(0, 0.35, 0)
@export var item_inside : InventoryItem
@export var quantity : int = 1

const PICKUP_ITEM = preload("res://resources/items/pickup_item.tscn")

func interact(player : Player) -> PlayerUseItem.USE_ITEM_RESULT:
	if(item_inside):
		var item : PickupItemInteractable = PICKUP_ITEM.instantiate()
		add_child(item)
		item.position = item_spawn_offset
		item.set_item(item_inside, quantity)
		player.pickup_item(item)
		item_inside = null
		quantity = 0
		return PlayerUseItem.USE_ITEM_RESULT.IGNORE
	else:
		return PlayerUseItem.USE_ITEM_RESULT.EMPTY
