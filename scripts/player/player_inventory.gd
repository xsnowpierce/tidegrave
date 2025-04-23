extends Node

class_name PlayerInventory

@export var inventory_items : Dictionary[InventoryItem, int]

@export_group("Equipped Items")
@export var equipped_weapon : InventoryWeapon
@export var equipped_helmet : InventoryArmour
@export var equipped_chestplate : InventoryArmour
@export var equipped_gauntlets : InventoryArmour
@export var equipped_leggings : InventoryArmour
@export var equipped_shield : InventoryArmour
@export var equipped_item : InventoryItem

func _ready() -> void:
	if(equipped_weapon):
		%PlayerStats.set_stamina_recover_speed(equipped_weapon.cooldown_speed)

func add_item_to_inventory(item : InventoryItem, amount : int) -> void:
	if(amount <= 0):
		return
	
	if(inventory_items.has(item)):
		inventory_items[item] += amount
	else:
		inventory_items[item] = amount

func remove_item_from_inventory(item : InventoryItem, amount : int) -> void:
	if(!inventory_items.has(item)):
		return
	
	if(inventory_items[item] - amount <= 0):
		inventory_items.erase(item)
	
	else:
		inventory_items[item] -= amount

func inventory_has_item(item : InventoryItem, amount : int = 1) -> bool:
	if(!inventory_items.has(item)):
		return false
	
	if(inventory_items[item] >= amount):
		return true
	
	return false

func equip_item(item : InventoryEquippable) -> void:
	if(item is InventoryWeapon):
		equipped_weapon = item
		%PlayerStats.set_stamina_recover_speed(item.cooldown_speed)
	
	elif(item is InventoryArmour):
		match(item.equip_type):
			InventoryArmour.EQUIP_TYPE.HELMET:
				equipped_helmet = item
			InventoryArmour.EQUIP_TYPE.CHESTPLATE:
				equipped_chestplate = item
			InventoryArmour.EQUIP_TYPE.GAUNTLETS:
				equipped_gauntlets = item
			InventoryArmour.EQUIP_TYPE.LEGGINGS:
				equipped_leggings = item
			InventoryArmour.EQUIP_TYPE.SHIELD:
				equipped_shield = item
	else:
		printerr("Unhandled equipment: ", item.name)
