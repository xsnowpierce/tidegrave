extends Node3D

class_name Enemy

@export var enemy_stats : EnemyStats

var current_health : int

var tween : Tween

var hit_effect_time : float = 0.4

func _ready() -> void:
	current_health = enemy_stats.health

func _on_enemy_hitbox_area_entered(area: Area3D) -> void:
	print("area entered: " , area.name)
	if(area is PlayerAttackHitbox):
		take_damage(area.attack_damage)

func take_damage(amount : int) -> void:
	if(tween):
		tween.kill()
	
	print("damage")
	
	current_health -= amount
	
	if(current_health <= 0):
		death()
		return
	
	tween = create_tween()
	
	tween.tween_property($slime/Sphere, "material:shader_parameter/HitEffect", 0.5, hit_effect_time / 2)
	tween.tween_property($slime/Sphere, "material:shader_parameter/HitEffect", 0.0, hit_effect_time / 2)
	
func death() -> void:
	queue_free()
