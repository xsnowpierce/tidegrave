extends UIPausePanel

class_name UIPausePanelInventory

@onready var item_select_panel: UIPausePanelItemSelect = $"../Item Select Panel"

var is_in_item_selection : bool

func show_panel() -> void:
	load_inventory()
	super()
	$"VBoxContainer/Weapon Item".grab_focus()
	is_in_item_selection = false

func cancel_pressed() -> void:
	if(is_in_item_selection):
		item_select_panel.cancel_pressed()
		show_panel()
	else:
		pause_menu.switch_menu_panel(PauseMenu.PANEL.MAIN)

func hide_panel() -> void:
	if(is_in_item_selection):
		item_select_panel.hide_panel()
		show_panel()
	else:
		super()
		reset_inventory_item_strings()

func load_inventory() -> void:
	var inventory : PlayerInventory = pause_menu.character.get_inventory()
	
	reset_inventory_item_strings()
	
	if(inventory.equipped_weapon):
		$"VBoxContainer/Weapon Item/MarginContainer/HBoxContainer/Value".text = inventory.equipped_weapon.name
	if(inventory.equipped_shield):
		$"VBoxContainer/Shield Item/MarginContainer/HBoxContainer/Value".text = inventory.equipped_shield.name
	if(inventory.equipped_chestplate):
		$"VBoxContainer/Body Item/MarginContainer/HBoxContainer/Value".text = inventory.equipped_chestplate.name
	if(inventory.equipped_gauntlets):
		$"VBoxContainer/Arms Item/MarginContainer/HBoxContainer/Value".text = inventory.equipped_gauntlets.name
	if(inventory.equipped_leggings):
		$"VBoxContainer/Feet Item/MarginContainer/HBoxContainer/Value".text = inventory.equipped_leggings.name
	if(inventory.equipped_item):
		$"VBoxContainer/Item Item/MarginContainer/HBoxContainer/Value".text = inventory.equipped_item.name

func reset_inventory_item_strings() -> void:
	$"VBoxContainer/Weapon Item/MarginContainer/HBoxContainer/Value".text = ""
	$"VBoxContainer/Shield Item/MarginContainer/HBoxContainer/Value".text = ""
	$"VBoxContainer/Body Item/MarginContainer/HBoxContainer/Value".text = ""
	$"VBoxContainer/Arms Item/MarginContainer/HBoxContainer/Value".text = ""
	$"VBoxContainer/Feet Item/MarginContainer/HBoxContainer/Value".text = ""
	$"VBoxContainer/Item Item/MarginContainer/HBoxContainer/Value".text = ""

enum ITEM_PANEL_TYPE {
	WEAPON,
	SHIELD,
	HELMET,
	CHESTPLATE,
	ARMS,
	LEGGINGS,
	ACCESSORIES
}

func show_item_select_panel(panel_type : ITEM_PANEL_TYPE) -> void:
	hide()
	item_select_panel.load_item_type(panel_type)
	item_select_panel.show()
	is_in_item_selection = true
	
func _on_weapon_item_pressed() -> void:
	show_item_select_panel(ITEM_PANEL_TYPE.WEAPON)
func _on_shield_item_pressed() -> void:
	show_item_select_panel(ITEM_PANEL_TYPE.SHIELD)
func _on_head_item_pressed() -> void:
	show_item_select_panel(ITEM_PANEL_TYPE.HELMET)
func _on_body_item_pressed() -> void:
	show_item_select_panel(ITEM_PANEL_TYPE.CHESTPLATE)
func _on_arms_item_pressed() -> void:
	show_item_select_panel(ITEM_PANEL_TYPE.ARMS)
func _on_feet_item_pressed() -> void:
	show_item_select_panel(ITEM_PANEL_TYPE.LEGGINGS)
func _on_item_item_pressed() -> void:
	pass # Replace with function body.

func _on_item_select_panel_item_selected(item: InventoryItem) -> void:
	item_select_panel.hide_panel()
	if(item == null):
		match(item_select_panel.item_panel_type):
			ITEM_PANEL_TYPE.WEAPON:
				pause_menu.character.get_inventory().equipped_weapon = null
			ITEM_PANEL_TYPE.SHIELD:
				pause_menu.character.get_inventory().equipped_shield = null
			ITEM_PANEL_TYPE.HELMET:
				pause_menu.character.get_inventory().equipped_helmet = null
			ITEM_PANEL_TYPE.CHESTPLATE:
				pause_menu.character.get_inventory().equipped_chestplate = null
			ITEM_PANEL_TYPE.ARMS:
				pause_menu.character.get_inventory().equipped_gauntlets = null
			ITEM_PANEL_TYPE.LEGGINGS:
				pause_menu.character.get_inventory().equipped_leggings = null
			ITEM_PANEL_TYPE.ACCESSORIES:
				pause_menu.character.get_inventory().equipped_item = null
	else:
		pause_menu.character.get_inventory().equip_item(item)
	show_panel()
	
