extends UIPausePanel

class_name UIPausePanelSystem


func _on_quit_game_pressed() -> void:
	get_tree().quit()

func show_panel() -> void:
	super()
	$"Menu/Buttons/QUIT GAME".grab_focus()
