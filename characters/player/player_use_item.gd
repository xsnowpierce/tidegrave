extends Node

class_name PlayerUseItem

signal attempt_use_item_result(result : USE_ITEM_RESULT)

enum USE_ITEM_RESULT {
	
	NOTHING_HAPPENED,
	SUCCESS,
	IGNORE
}

func try_use_item(item : InventoryItem) -> USE_ITEM_RESULT:
	print($ShapeCast3D.get_collision_count(), " colliders")
	if($ShapeCast3D.get_collision_count() == 0):
		return USE_ITEM_RESULT.NOTHING_HAPPENED
	
	for col in $ShapeCast3D.get_collision_count():
		if($ShapeCast3D.get_collider(col) is WorldInteractable):
			var interactable : WorldInteractable = $ShapeCast3D.get_collider(col)
			
			return interactable.item_interact(item)
	
	return USE_ITEM_RESULT.NOTHING_HAPPENED
