extends Node

class_name PlayerCombat

var is_attacking : bool

var character : Player

func _ready() -> void:
	character = get_parent()

func _on_player_input_attack_pressed() -> void:
	
	if(!character.can_player_attack()):
		return
	
	# Don't continue if we're attacking, don't have a weapon or don't have maximum stamina.
	if(is_attacking or !%PlayerInventory.equipped_weapon or %PlayerStats.current_stamina < %PlayerStats.max_stamina):
		return
	
	is_attacking = true
	%ArmAnimator.play("swing")
	
	%PlayerStats.current_stamina = 0
	
	await get_tree().create_timer(0.5).timeout
	
	%AttackHitbox.enable_attack_hitbox(%PlayerInventory.equipped_weapon, 0.6)
	
	await get_tree().create_timer(1.0).timeout
	
	is_attacking = false
	%ArmAnimator.play("RESET")
