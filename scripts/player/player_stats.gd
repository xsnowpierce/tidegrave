extends Node

class_name PlayerStats

@export var max_health : float
var current_health : float

@export var max_stamina : float
var current_stamina : float
@export var default_stamina_recover_speed : float = 5
@export var stamina_recovery_multiplier : float = 1
@export var sprinting_stamina_decrease_speed : float = 10

func _ready() -> void:
	current_health = max_health
	current_stamina = max_stamina

func _process(delta: float) -> void:
	if(%PlayerInput.sprinting and current_stamina > 0):
		current_stamina -= sprinting_stamina_decrease_speed * delta
	elif(can_stamina_regen()):
		if(current_stamina < max_stamina):
			current_stamina += delta * (default_stamina_recover_speed * stamina_recovery_multiplier)
		else:
			current_stamina = max_stamina

func can_stamina_regen() -> bool:
	return true

func set_stamina_recover_speed(speed : float) -> void:
	stamina_recovery_multiplier = speed
