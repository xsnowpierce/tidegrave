extends Button

class_name UIItemSelectItem

@export var default_text : String
@export var default_amount : int
var item_held : InventoryItem

signal item_button_pressed(item_held : InventoryItem)
signal item_button_selected(item_held : InventoryItem)

func set_item(item : InventoryItem, amount : int) -> void:
	item_held = item
	$"Margin/Text/Item Name".text = item.name
	$Margin/Text/Quantity.text = "x " + str(amount)

func _on_pressed() -> void:
	item_button_pressed.emit(item_held)

func _on_focus_entered() -> void:
	item_button_selected.emit(item_held)
