extends InventoryEquippable

class_name InventoryArmour

enum EQUIP_TYPE {
	HELMET,
	CHESTPLATE,
	GAUNTLETS,
	LEGGINGS,
	SHIELD
}
@export var equip_type : EQUIP_TYPE

@export var defence : int
