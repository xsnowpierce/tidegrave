extends Control

class_name PlayerHUD

@export var player : Player

@onready var hp_amount: Label = $"MarginContainer/VBoxContainer/HBoxContainer/HP Amount"
@onready var stamina_change: ColorRect = $"MarginContainer/VBoxContainer/Stamina/Stamina Change"

var stamina_starting_size_x

@export var damage_flash_colour : Color
@export var damage_flash_time : float = 0.15


@export var interact_message_fade_time : float = 0.4
@export var interact_message_stay_time : float = 3
var interact_message_list : Array[String]

var damage_flash_tween : Tween
var text_tween : Tween

func _ready() -> void:
	await get_tree().process_frame
	stamina_starting_size_x = stamina_change.size.x

func _process(delta: float) -> void:
	hp_amount.text = str(floori(player.get_player_stats().current_health))
	
	var staminaPercent = player.get_player_stats().current_stamina / player.get_player_stats().max_stamina
	stamina_change.size.x = stamina_starting_size_x * staminaPercent

func _on_player_hitbox_player_attacked() -> void:
	play_player_damaged_flash()

func play_player_damaged_flash() -> void:
	if(damage_flash_tween):
		damage_flash_tween.kill()
	damage_flash_tween = $DamagedFlash.create_tween()
	var nulled_colour = damage_flash_colour
	nulled_colour.a = 0
	damage_flash_tween.tween_property($DamagedFlash, "color", damage_flash_colour, damage_flash_time)
	damage_flash_tween.tween_property($DamagedFlash, "color", nulled_colour, damage_flash_time)

func show_interact_message(message : String) -> void:
	interact_message_list.append(message)
	play_interact_messages()

func play_interact_messages() -> void:
	
	if(!interact_message_list[0]):
		return
		
	if(text_tween):
		text_tween.kill()
		
	$"Interact Text".text = interact_message_list[0]
	interact_message_list.remove_at(0)
	
	$"Interact Text".position = Vector2(0, 172.8)
	text_tween = create_tween()
	
	text_tween.tween_property($"Interact Text", "position", Vector2(0, 300), interact_message_fade_time).set_delay(interact_message_stay_time)
	
	await text_tween.finished
	
	if(!interact_message_list.is_empty()):
		play_interact_messages()
