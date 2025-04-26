extends Node

class_name PlayerCombat

@onready var weapon_parent: Node3D = $"../Head/Player Camera/arm/Armature/Skeleton3D/BoneAttachment3D/WeaponParent"

@export_flags_3d_render var weapon_render_layer : int

var is_attacking : bool
var character : Player

enum ATTACK_ANIMATION_STYLE {
	SWING,
	JAB,
	SMASH
}

func _ready() -> void:
	character = get_parent()

func _on_player_input_attack_pressed() -> void:
	
	if(!character.can_player_attack()):
		return
	
	# Don't continue if we're attacking, don't have a weapon or don't have maximum stamina.
	if(is_attacking or !%PlayerInventory.equipped_weapon or %PlayerStats.current_stamina < %PlayerStats.max_stamina):
		return
	
	var weapon : Node3D = %PlayerInventory.equipped_weapon.item_scene.instantiate()
	weapon_parent.add_child(weapon)
	weapon.position = Vector3.ZERO
	weapon.rotation = Vector3.ZERO
	
	is_attacking = true
	
	match(%PlayerInventory.equipped_weapon.attack_animation_type):
		ATTACK_ANIMATION_STYLE.SWING:
			%ArmAnimator.play("Swing")
		ATTACK_ANIMATION_STYLE.JAB:
			%ArmAnimator.play("Stab")
	
	%PlayerStats.current_stamina = 0
	
	await get_tree().create_timer(%ArmAnimator.current_animation_length / %ArmAnimator.speed_scale / 2, false).timeout
	
	%AttackHitbox.enable_attack_hitbox(%PlayerInventory.equipped_weapon, 0.6)
	
	await get_tree().create_timer(%ArmAnimator.current_animation_length / %ArmAnimator.speed_scale / 2, false).timeout
	
	is_attacking = false
	%ArmAnimator.play("RESET")
	
	weapon.queue_free()
