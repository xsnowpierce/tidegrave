extends Control

@export var player : Player

var health_starting_size_x
var stamina_starting_size_x

@export var damage_flash_colour : Color
@export var damage_flash_time : float = 0.15

@export var interact_message_fade_time : float = 0.4
@export var interact_message_stay_time : float = 3
var interact_message_list : Array[String]

var damage_flash_tween : Tween

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
	set_font_colour(Color(1,1,1,0))
	$"Interact Text".text = interact_message_list[0]
	
	var tween : Tween = create_tween()
	tween.tween_method(set_font_colour, Color(1,1,1,0), Color(1,1,1,1), interact_message_fade_time)
	tween.tween_method(set_font_colour, Color(1,1,1,1), Color(1,1,1,0), interact_message_fade_time).set_delay(interact_message_stay_time)
	
	await tween.finished
	
	interact_message_list.remove_at(0)
	$"Interact Text".text = ""
	
	if(!interact_message_list.is_empty()):
		play_interact_messages()

func set_font_colour(colour : Color) -> void:
	$"Interact Text".add_theme_color_override("font_color", colour)
