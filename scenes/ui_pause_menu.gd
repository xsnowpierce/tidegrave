extends Control

class_name PauseMenu

var currently_selected : UIMenuItem

var pause_menu_open : bool

func _ready() -> void:
	close_pause_menu()

func _process(delta: float) -> void:
	
	if(Input.is_action_just_pressed("pause")):
		
		if(pause_menu_open):
			close_pause_menu()
		if(!pause_menu_open):
			open_pause_menu()
	
	elif(Input.is_action_just_pressed("menu_accept") and pause_menu_open):
		select_pressed()
	
	elif(Input.is_action_just_pressed("menu_cancel") and pause_menu_open):
		cancel_pressed()

func open_pause_menu() -> void:
	show()
	pause_menu_open = true

func close_pause_menu() -> void:
	hide()
	pause_menu_open = false

func _on_menu_item_menu_item_mouse_event(item : UIMenuItem) -> void:
	
	if(currently_selected):
		currently_selected.set_selected(false)
		
	currently_selected = item
	currently_selected.set_selected(true)

func _on_menu_item_menu_item_mouse_leave_event(item: UIMenuItem) -> void:
	item.set_selected(false)
	if(currently_selected == item):
		currently_selected = null

func select_pressed() -> void:
	pass

func cancel_pressed() -> void:
	close_pause_menu()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
