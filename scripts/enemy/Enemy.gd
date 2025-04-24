extends Node3D

class_name Enemy

@export var enemy_stats : EnemyStats
@export var meshes : Array[MeshInstance3D]
@export var attacked_animation_name : String = "slime_attacked"

var current_health : int

var hit_effect_speed : float = 1

func _ready() -> void:
	current_health = enemy_stats.health
	
func _on_enemy_hitbox_area_entered(area: Area3D) -> void:
	if(area is PlayerAttackHitbox):
		take_damage(area.attack_damage)

func take_damage(amount : int) -> void:
	current_health -= amount
	
	hit_effect()
	
	if(current_health <= 0):
		death()
		return

func hit_effect() -> void:
	var current_tint_alpha : float = .5
	
	$AnimationPlayer.play(attacked_animation_name)
	
	for mesh in meshes:
		mesh.get_surface_override_material(0).set_shader_parameter("HitEffect", .5)
		
	while(current_tint_alpha > 0):
		for mesh in meshes:
			mesh.get_surface_override_material(0).set_shader_parameter("HitEffect", current_tint_alpha)
		current_tint_alpha -= get_process_delta_time() * hit_effect_speed
		await get_tree().process_frame

func death() -> void:
	queue_free()
