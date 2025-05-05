extends Area3D

class_name PlayerAttackHitbox

var attack_damage : DamageValue
@onready var player: Player = $"../../../.."

@export var coll : CollisionShape3D

func _ready() -> void:
	coll.disabled = true

func enable_attack_hitbox( weapon : InventoryWeapon, time : float = 0.3) -> void:
	attack_damage = weapon.damage
	coll.disabled = false
	await get_tree().create_timer(time).timeout
	disable_attack_hitbox()

func disable_attack_hitbox() -> void:
	attack_damage = null
	coll.disabled = true
