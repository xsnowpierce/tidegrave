extends MarginContainer

class_name UIMenuStats

@onready var character_name_item: UIMenuTextItem = $Items/CharacterNameItem
@onready var stamina_item: UIMenuTextItem = $Items/StaminaItem
@onready var health_item: UIMenuTextItem = $Items/HealthItem

@onready var pause_menu : PauseMenu = $"../../.."

func load_stats() -> void:
	character_name_item.set_text("CHARACTER", "John")
	health_item.set_text("HP", str("%0.1f" % pause_menu.character.get_player_stats().current_health) + "/ " + str(pause_menu.character.get_player_stats().max_health))
	stamina_item.set_text("SP", str("%0.1f" % pause_menu.character.get_player_stats().current_stamina) + "/ " + str(pause_menu.character.get_player_stats().max_stamina))
