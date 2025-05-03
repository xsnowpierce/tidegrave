extends WorldInteractable

class_name DialogueInteractable

@export var dialogue : DialogueResource

var is_interacting : bool = false
@export var animation_player : AnimationPlayer

func interact(player : Player) -> PlayerUseItem.USE_ITEM_RESULT:
	start_dialogue()
	return PlayerUseItem.USE_ITEM_RESULT.IGNORE

func start_dialogue() -> void:
	if(is_interacting):
		return
		
	is_interacting = true
	
	if(animation_player):
		animation_player.play("Talk")
		await get_tree().create_timer(0.666).timeout
		animation_player.pause()
	
	#DialogueManager.show_dialogue_balloon(dialogue, "start")
	#await DialogueManager.dialogue_ended
	
	if(animation_player):
		animation_player.play()
		await get_tree().create_timer(0.666).timeout
	
	is_interacting = false
