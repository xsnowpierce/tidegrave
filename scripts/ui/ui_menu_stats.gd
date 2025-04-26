extends MarginContainer

class_name UIMenuStats

@onready var experience_item: UIMenuTextItem = $Items/ExperienceItem
@onready var level_item: UIMenuTextItem = $Items/LevelItem
@onready var health_item: UIMenuTextItem = $Items/HealthItem
@onready var gold_item: UIMenuTextItem = $Items/GoldItem
@onready var status_item: UIMenuTextItem = $Items/StatusItem

@onready var pause_menu : PauseMenu = $"../../.."

func load_stats() -> void:
	var player_stats : PlayerStats = pause_menu.character.get_player_stats()
	experience_item.set_text("EXPERIENCE", str(player_stats.current_experience))
	level_item.set_text("LEVEL", str(player_stats.player_level))
	health_item.set_text("HP", str(floori(player_stats.current_health)) + "/ " + str(player_stats.get_max_health()))
	gold_item.set_text("GOLD", str(player_stats.current_gold))
	status_item.set_text("STATUS", StatusCondition.get_string_from_condition(player_stats.current_status))
