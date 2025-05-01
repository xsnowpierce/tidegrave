extends Resource

class_name EnemyStats

@export_group("Stats")
@export var name : String
@export var health : int

@export_group("Resistances")
@export_range(0, 2) var slash_resistance : float = 1
@export_range(0, 2) var pierce_resistance : float = 1
@export_range(0, 2) var blunt_resistance : float = 1

func get_damage_after_resistances(damage : DamageValue) -> DamageValue:
	var new_damage = DamageValue.new()
	new_damage.damage_amount_slash = (damage.damage_amount_slash / slash_resistance) + 1
	new_damage.damage_amount_pierce = (damage.damage_amount_pierce / pierce_resistance) + 1
	new_damage.damage_amount_blunt = (damage.damage_amount_blunt / blunt_resistance) + 1
	return new_damage
