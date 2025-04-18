extends Area3D

class_name PlayerAttackHitbox

var attack_damage : int = 0

func _ready() -> void:
	monitoring = false
	monitorable = false

func enable_attack_hitbox( weapon : InventoryWeapon, time : float = 0.3) -> void:
	attack_damage = weapon.damage.damage_amount_slash
	$AttackBoxTimer.start(time)
	monitoring = true
	monitorable = true
	await $AttackBoxTimer.timeout
	disable_attack_hitbox()

func disable_attack_hitbox() -> void:
	$AttackBoxTimer.stop()
	attack_damage = 0
	monitoring = false
	monitorable = false
