extends Node

class_name PlayerInteract

var character : Player

@onready var interact_area: Area3D = $"../Head/HeadAnimator/Player Camera/Interact Area"

func _ready() -> void:
	character = get_parent()

func _on_player_input_interact_pressed() -> void:
	if(!interact_area.interactables.is_empty()):
		var interactable : WorldInteractable = interact_area.interactables[0]
		var interact_result : PlayerUseItem.USE_ITEM_RESULT = interactable.interact(character)
		%PlayerUseItem.send_interact_message(interact_result)
