extends Control

@export var player : Player

var health_starting_size_x
var stamina_starting_size_x

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	health_starting_size_x = $"VBoxContainer/Health/Health Change".size.x
	stamina_starting_size_x = $"VBoxContainer/Stamina/Stamina Change".size.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var healthPercent = player.get_player_stats().current_health / player.get_player_stats().max_health
	$"VBoxContainer/Health/Health Change".size.x = health_starting_size_x * healthPercent
	
	var staminaPercent = player.get_player_stats().current_stamina / player.get_player_stats().max_stamina
	$"VBoxContainer/Stamina/Stamina Change".size.x = stamina_starting_size_x * staminaPercent
