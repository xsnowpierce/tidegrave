extends WorldInteractable

class_name TeleportDoorInteractable

@export var level_to_load : LoadLevel

func interact(player : Player) -> PlayerUseItem.USE_ITEM_RESULT:
	get_tree().get_first_node_in_group("SceneManager").load_new_level(level_to_load)
	return PlayerUseItem.USE_ITEM_RESULT.IGNORE
