extends Area3D

class_name WorldInteractable

func interact(player : Player):
	pass

func item_interact(item : InventoryItem) -> PlayerUseItem.USE_ITEM_RESULT:
	return PlayerUseItem.USE_ITEM_RESULT.NOTHING_HAPPENED
