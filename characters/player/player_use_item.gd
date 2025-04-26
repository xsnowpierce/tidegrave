extends Node

class_name PlayerUseItem

signal attempt_use_item_result(result : USE_ITEM_RESULT)

@onready var hud : PlayerHUD = %HUD

enum USE_ITEM_RESULT {
	
	NOTHING_HAPPENED,
	SUCCESS,
	IGNORE
}

func try_use_item(item : InventoryItem) -> void:
	print($ShapeCast3D.get_collision_count(), " colliders")
	if($ShapeCast3D.get_collision_count() == 0):
		send_interact_message(USE_ITEM_RESULT.NOTHING_HAPPENED)
		return
	
	for col in $ShapeCast3D.get_collision_count():
		if($ShapeCast3D.get_collider(col) is WorldInteractable):
			var interactable : WorldInteractable = $ShapeCast3D.get_collider(col)
			
			send_interact_message(interactable.item_interact(item))
			
	
	return

func send_interact_message(type : USE_ITEM_RESULT) -> void:
	match(type):
		USE_ITEM_RESULT.NOTHING_HAPPENED:
			hud.show_interact_message("NOTHING HAPPENED")
		USE_ITEM_RESULT.SUCCESS:
			return
		USE_ITEM_RESULT.IGNORE:
			return
