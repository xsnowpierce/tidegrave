extends ColorRect

class_name UIMenuItem

@export var selected_colour : Color
@export var deselected_colour : Color

var selected : bool = false

signal menu_item_mouse_event(item : UIMenuItem)
signal menu_item_mouse_leave_event(item : UIMenuItem)

func set_selected(value : bool) -> void:
	selected = value
	if(value):
		color = selected_colour
	else:
		color = deselected_colour
	

func _on_mouse_entered() -> void:
	menu_item_mouse_event.emit(self)


func _on_mouse_exited() -> void:
	menu_item_mouse_leave_event.emit(self)
