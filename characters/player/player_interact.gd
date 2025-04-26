extends Node

class_name PlayerInteract

var character : Player

func _ready() -> void:
	character = get_parent()

func _on_player_input_interact_pressed() -> void:
	if(!$"../Head/Player Camera/Interact Area".interactables.is_empty()):
		var interactable : WorldInteractable = $"../Head/Player Camera/Interact Area".interactables[0]
		var interact_result : PlayerUseItem.USE_ITEM_RESULT = interactable.interact(character)
		%PlayerUseItem.send_interact_message(interact_result)
