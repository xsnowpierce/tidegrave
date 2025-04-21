extends Container

class_name UIPausePanel

@onready var pause_menu: PauseMenu = $"../.."

func _ready() -> void:
	hide_panel()

func show_panel() -> void:
	show()

func hide_panel() -> void:
	hide()

func cancel_pressed() -> void:
	pass
