extends WorldInteractable

class_name WallDoorInteractable

var door_is_opened : bool

@export var door_is_locked : bool
@export var required_key : InventoryItem

func interact(player : Player) -> PlayerUseItem.USE_ITEM_RESULT:
	if(!door_is_locked):
		open_door()
		return PlayerUseItem.USE_ITEM_RESULT.IGNORE
	else:
		return PlayerUseItem.USE_ITEM_RESULT.LOCKED

func item_interact(item : InventoryItem) -> PlayerUseItem.USE_ITEM_RESULT:
	if(!door_is_opened and door_is_locked and item == required_key):
		door_is_locked = false
		open_door()
		return PlayerUseItem.USE_ITEM_RESULT.SUCCESS
		
	return PlayerUseItem.USE_ITEM_RESULT.NOTHING_HAPPENED

func open_door() -> void:
	if(!door_is_opened):
		$AnimationPlayer.play("wall_door_open")
		door_is_opened = true
