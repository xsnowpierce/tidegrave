extends WorldInteractable

class_name DoorInteractable

var door_is_opened : bool
var scheduled_to_close : bool

@export var door_is_locked : bool
@export var required_key : InventoryItem

@export var animation_player : AnimationPlayer
@export var open_animation_name : String = "Open"

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
	if(animation_player.is_playing()):
		return
	if(!door_is_opened):
		animation_player.play(open_animation_name)
		door_is_opened = true

func close_door() -> void:
	if(door_is_opened):
		animation_player.play_backwards(open_animation_name)
		door_is_opened = false
		scheduled_to_close = false

func _on_player_exit_area_area_exited(area: Area3D) -> void:
	if(door_is_opened):
		scheduled_to_close = true

func _process(delta: float) -> void:
	if(scheduled_to_close):
		if(!animation_player.is_playing()):
			close_door()
