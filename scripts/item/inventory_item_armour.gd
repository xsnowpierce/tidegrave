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

@export var slash_defence : int
@export var pierce_defence : int
@export var blunt_defence : int
