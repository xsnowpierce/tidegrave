extends UIPausePanel

class_name UIPausePanelInventory

@onready var item_select_panel: UIPausePanelItemSelect = $"../Item Select Panel"

var is_in_item_selection : bool = false

var current_selecting_item : InventoryItem
var last_selected_menu_item : Control

func show_panel() -> void:
	item_select_panel.load_item_select_type(UIPausePanelItemSelect.ITEM_SELECT_TYPE.INVENTORY)
	item_select_panel.load_item_type(UIPausePanelEquipment.ITEM_PANEL_TYPE.ALL)
	item_select_panel.show()
	is_in_item_selection = true

func hide_panel() -> void:
	super()
	item_select_panel.hide_panel()
	current_selecting_item = null
	last_selected_menu_item = null
	is_in_item_selection = false
	
func cancel_pressed() -> void:
	pause_menu.switch_menu_panel(PauseMenu.PANEL.MAIN)

func accept_pressed() -> void:
	pass

func _on_item_select_panel_item_selected(item : InventoryItem) -> void:
	if(!is_in_item_selection):
		return
	show()
	current_selecting_item = item
	last_selected_menu_item = get_viewport().gui_get_focus_owner()
	$"Item Use".show()
	$"Item Use/ColorRect/MarginContainer/VBoxContainer/USE BUTTON".grab_focus()

func _on_use_button_pressed() -> void:
	if(current_selecting_item):
		var result : PlayerUseItem.USE_ITEM_RESULT = pause_menu.character.get_use_item().try_use_item(current_selecting_item)
		print(result)
	pause_menu.close_pause_menu()

func _on_cancel_button_pressed() -> void:
	$"Item Use".hide()
	last_selected_menu_item.grab_focus()
	
