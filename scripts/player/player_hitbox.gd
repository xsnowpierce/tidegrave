extends Area3D

signal player_attacked(damage : DamageValue)


func _on_area_entered(area: Area3D) -> void:
	if(area is DamagePlayerHitbox):
		var damage : DamageValue = area.damage
		player_attacked.emit(damage)
	elif(area is AreaPlayerEffect):
		match(area.effect_type):
			AreaPlayerEffect.EFFECT_TYPE.DEATH:
				var damage : DamageValue = DamageValue.new()
				damage.damage_amount_blunt = 10000000
				damage.damage_amount_pierce = 10000000
				damage.damage_amount_slash = 10000000
				player_attacked.emit(damage)
