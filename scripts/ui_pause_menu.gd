extends Control

class_name PauseMenu

var currently_selected : UIMenuItem

var pause_menu_open : bool

var character : Player 

@onready var stats: UIMenuStats = $"Background/Main Panel/Stats"

var current_panel : UIPausePanel

enum PANEL {
	MAIN,
	EQUIPMENT,
	INVENTORY
}

func _ready() -> void:
	close_pause_menu()
	character = get_parent()
	

func _process(delta: float) -> void:
	
	if(Input.is_action_just_released("pause")):
		
		if(pause_menu_open):
			close_pause_menu()
		elif(!pause_menu_open):
			open_pause_menu()
	
	elif(Input.is_action_just_released("menu_accept") and pause_menu_open):
		select_pressed()
	
	elif(Input.is_action_just_released("menu_cancel") and pause_menu_open):
		cancel_pressed()

func open_pause_menu() -> void:
	stats.load_stats()
	show()
	pause_menu_open = true
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	current_panel = $"Background/Main Panel"
	current_panel.show_panel()

func close_pause_menu() -> void:
	if(current_panel):
		current_panel.hide_panel()
	hide()
	pause_menu_open = false
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func select_pressed() -> void:
	pass

func cancel_pressed() -> void:
	if(current_panel):
		current_panel.cancel_pressed()

func switch_menu_panel(panel : PANEL) -> void:
	if(current_panel):
		current_panel.hide_panel()
	match(panel):
		PANEL.MAIN:
			current_panel = $"Background/Main Panel"
		PANEL.EQUIPMENT:
			current_panel = $"Background/Equipment Panel"
	current_panel.show_panel()
