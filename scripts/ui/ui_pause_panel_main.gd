extends UIPausePanel


func show_panel() -> void:
	super()
	$"Menu Options/Buttons/EQUIPMENT".grab_focus()

func _on_equipment_pressed() -> void:
	pause_menu.switch_menu_panel(PauseMenu.PANEL.EQUIPMENT)

func _on_quit_pressed() -> void:
	get_tree().quit()

func cancel_pressed() -> void:
	pause_menu.close_pause_menu()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
