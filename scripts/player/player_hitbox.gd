extends Area3D

signal player_attacked(damage : DamageValue)


func _on_area_entered(area: Area3D) -> void:
	if(area is EnemyHitbox):
		var damage : DamageValue = area.damage
		player_attacked.emit(damage)
