extends CharacterBody3D

class_name Enemy

@export var enemy_stats : EnemyStats
@export var meshes : Array[MeshInstance3D]

@export_category("Animations")
@export var move_animation_name : String = ""
@export var hit_animation_name : String = ""
@export var attack_animation_name : String = ""
@export var idle_animation_name : String = ""
@export var block_animation_name : String = ""
@export var death_animation_name : String = ""

@export_category("AI")
@export var turn_speed : float = 1
@export var move_speed : float = 1
@export var target_distance_to_player : float = 2
@export var max_angle_to_player_acceptable : float = 10
@export var can_attack : bool = true
@export var can_block_attack : bool = true
@export_range(0, 1) var block_chance : float = 0.2

@export_category("Audio")
@export var attacked_sound : AudioStream
@export var death_sound : AudioStream

var current_health : int

var hit_effect_speed : float = 1

func _ready() -> void:
	current_health = enemy_stats.health
	
func _on_enemy_hitbox_area_entered(area: Area3D) -> void:
	if(area is PlayerAttackHitbox):
		take_damage(area.attack_damage)

func take_damage(amount : int) -> void:
	current_health -= amount
	
	if(current_health > 0):
		$EnemyAI.attacked_from_player()
	else:
		$EnemyAI.death()
