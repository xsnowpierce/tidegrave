extends Area3D

class_name PlayerAttackHitbox

var attack_damage : int = 0

var hitbox_stay_time : float = 0.3

func _ready() -> void:
	$CollisionShape3D.disabled = true

func enable_attack_hitbox( weapon : InventoryWeapon, time : float = 0.3) -> void:
	attack_damage = weapon.damage.damage_amount_slash
	$CollisionShape3D.disabled = false
	await get_tree().create_timer(hitbox_stay_time).timeout
	disable_attack_hitbox()

func disable_attack_hitbox() -> void:
	$AttackBoxTimer.stop()
	attack_damage = 0
	$CollisionShape3D.disabled = true


func _on_area_entered(area: Area3D) -> void:
	if(area is EnemyHitbox):
		print("attacked")
