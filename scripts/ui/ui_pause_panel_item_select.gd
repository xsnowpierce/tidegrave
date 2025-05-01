extends UIPausePanel

class_name UIPausePanelItemSelect

@onready var button_holder: VBoxContainer = $"Items/Control/ScrollContainer/MarginContainer/Button Holder"
const UI_ITEM_SELECT_ITEM = preload("res://characters/player/ui_item_select_item.tscn")
@onready var take_off_button: Button = $"Items/Control/ScrollContainer/MarginContainer/Button Holder/Take Off Button"
@onready var mesh_instance: Node3D = $"Items/Item Image/SubViewportContainer/SubViewport/MeshInstance"

@export_flags_3d_render var item_render_layer : int

var current_buttons : Array[Control]

var item_panel_type : UIPausePanelEquipment.ITEM_PANEL_TYPE

signal item_selected(item : InventoryItem)
var current_item_selected_scene : Node3D

enum ITEM_SELECT_TYPE {
	INVENTORY,
	EQUIPMENT
}

func show_panel() -> void:
	$"Items/Item Image/SubViewportContainer/SubViewport/AnimationPlayer".play("rotate_item")

func cancel_pressed() -> void:
	hide_panel()

func hide_panel() -> void:
	super()
	
	for button in current_buttons:
		button.queue_free()
		
	current_buttons.clear()
	
	if(current_item_selected_scene):
		current_item_selected_scene.queue_free()

func load_item_select_type(type : ITEM_SELECT_TYPE) -> void:
	match(type):
		ITEM_SELECT_TYPE.INVENTORY:
			$"Items/Control/Menu Title".text = "   INVENTORY   "
			take_off_button.hide()
		ITEM_SELECT_TYPE.EQUIPMENT:
			$"Items/Control/Menu Title".text = "   EQUIPMENT   "
			take_off_button.show()

func load_item_type(item_type : UIPausePanelEquipment.ITEM_PANEL_TYPE) -> void:
	item_panel_type = item_type
	var inventory : Dictionary[InventoryItem, int] = pause_menu.character.get_inventory().inventory_items
	var chosen_category_inventory : Dictionary[InventoryItem, int]
	
	if(item_type == UIPausePanelEquipment.ITEM_PANEL_TYPE.ALL):
		chosen_category_inventory = inventory.duplicate()
	else:
		for key in inventory:
			if(key is InventoryWeapon):
				if(item_type == UIPausePanelEquipment.ITEM_PANEL_TYPE.WEAPON):
					chosen_category_inventory[key] = inventory[key]
			if(key is InventoryArmour):
				match(item_type):
					UIPausePanelEquipment.ITEM_PANEL_TYPE.SHIELD:
						if(key.equip_type == key.EQUIP_TYPE.SHIELD):
							chosen_category_inventory[key] = inventory[key]
					UIPausePanelEquipment.ITEM_PANEL_TYPE.HELMET:
						if(key.equip_type == key.EQUIP_TYPE.HELMET):
							chosen_category_inventory[key] = inventory[key]
					UIPausePanelEquipment.ITEM_PANEL_TYPE.CHESTPLATE:
						if(key.equip_type == key.EQUIP_TYPE.CHESTPLATE):
							chosen_category_inventory[key] = inventory[key]
					UIPausePanelEquipment.ITEM_PANEL_TYPE.ARMS:
						if(key.equip_type == key.EQUIP_TYPE.GAUNTLETS):
							chosen_category_inventory[key] = inventory[key]
					UIPausePanelEquipment.ITEM_PANEL_TYPE.LEGGINGS:
						if(key.equip_type == key.EQUIP_TYPE.LEGGINGS):
							chosen_category_inventory[key] = inventory[key]
			elif(key is InventoryItem):
				continue
	
	for key in chosen_category_inventory:
		var new_button = UI_ITEM_SELECT_ITEM.instantiate()
		new_button.set_item(key, chosen_category_inventory[key])
		button_holder.add_child(new_button)
		current_buttons.append(new_button)
		new_button.connect("item_button_pressed", Callable(self, "item_button_pressed"))
		new_button.connect("item_button_selected", Callable(self, "item_button_selected"))
	
	button_holder.move_child(take_off_button, button_holder.get_child_count())
	button_holder.get_child(0).grab_focus()

func _on_take_off_button_pressed() -> void:
	item_selected.emit(null)

func item_button_pressed(item_held : InventoryItem) -> void:
	item_selected.emit(item_held)

func item_button_selected(item_held : InventoryItem) -> void:
	if(current_item_selected_scene):
		current_item_selected_scene.queue_free()
	
	if(item_held):
		current_item_selected_scene = item_held.item_scene.instantiate()
		for child in current_item_selected_scene.get_children():
			if(child is MeshInstance3D):
				child.layers = item_render_layer
		mesh_instance.add_child(current_item_selected_scene)
		current_item_selected_scene.position = Vector3.ZERO
	$"Items/Item Image/SubViewportContainer/SubViewport/AnimationPlayer".stop()
	$"Items/Item Image/SubViewportContainer/SubViewport/AnimationPlayer".play("rotate_item")

func _on_take_off_button_item_button_selected(item_held: InventoryItem) -> void:
	if(current_item_selected_scene):
		current_item_selected_scene.queue_free()
