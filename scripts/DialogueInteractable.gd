extends WorldInteractable

class_name DialogueInteractable

@export var dialogue : DialogueResource

var is_interacting : bool = false
var animation_player : AnimationPlayer

func _ready() -> void:
	animation_player = get_parent().get_node("AnimationPlayer")

func interact(player : Player) -> PlayerUseItem.USE_ITEM_RESULT:
	if(is_interacting):
		return PlayerUseItem.USE_ITEM_RESULT.IGNORE
		
	is_interacting = true
	
	if(animation_player):
		animation_player.play("Talk")
		await get_tree().create_timer(0.666).timeout
		animation_player.pause()
		
	return PlayerUseItem.USE_ITEM_RESULT.IGNORE
	
	DialogueManager.show_dialogue_balloon(dialogue, "start")
	await DialogueManager.dialogue_ended
	
	if(animation_player):
		animation_player.play()
		await get_tree().create_timer(0.666).timeout
	
	is_interacting = false
