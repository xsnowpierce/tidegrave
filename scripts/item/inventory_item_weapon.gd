extends InventoryEquippable

class_name InventoryWeapon

enum WEAPON_TYPE {
	MELEE,
	RANGED
}

@export var weapon_type : WEAPON_TYPE
@export var damage : DamageValue
## The speed the stamina bar will fill up again. 1.0 is the default speed. Closer to 0 is slower, and higher is faster.
@export var cooldown_speed : float = 1
