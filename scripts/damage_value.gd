extends Resource

class_name DamageValue

@export var damage_amount_slash : int
@export var damage_amount_pierce : int
@export var damage_amount_blunt : int
@export var damage_amount_unscaled : int

func get_magnitude() -> int:
	return damage_amount_blunt + damage_amount_pierce + damage_amount_slash + damage_amount_unscaled

func damage_to_string() -> String:
	return "SLS " + str(damage_amount_slash) + ", PRC " + str(damage_amount_pierce) + ", BLT " + str(damage_amount_blunt) + ", UNSCALED " + str(damage_amount_unscaled)
