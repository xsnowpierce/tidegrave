extends Control

class_name PauseMenu

var currently_selected : UIMenuItem

var pause_menu_open : bool

var character : Player 

@onready var stats: UIMenuStats = $"Background/Main Panel/Stats"
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D
const MENU_SELECT = preload("res://audio/SFX/MENU B_Select.wav")
const MENU_BACK = preload("res://audio/SFX/MENU B_Back.wav")
const MENU_PICK = preload("res://audio/SFX/MENU_Pick.wav")
var current_panel : UIPausePanel

enum PANEL {
	MAIN,
	EQUIPMENT,
	INVENTORY,
	SYSTEM
}

func _ready() -> void:
	close_pause_menu()
	character = get_parent()

func _process(delta: float) -> void:
	
	if(Input.is_action_just_released("pause")):
		if(!pause_menu_open):
			open_pause_menu()
		else:
			cancel_pressed()
	
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
	
	$"Background/Main Panel".hide_panel()
	$"Background/Equipment Panel".hide_panel()
	$"Background/Item Select Panel".hide_panel()
	$"Background/Inventory Panel".hide_panel()
	$"Background/System Panel".hide_panel()

func select_pressed() -> void:
	play_accept_sound()

func cancel_pressed() -> void:
	if(current_panel):
		current_panel.cancel_pressed()
	play_cancel_sound()

func switch_menu_panel(panel : PANEL) -> void:
	if(current_panel):
		current_panel.hide_panel()
	match(panel):
		PANEL.MAIN:
			current_panel = $"Background/Main Panel"
		PANEL.EQUIPMENT:
			current_panel = $"Background/Equipment Panel"
		PANEL.INVENTORY:
			current_panel = $"Background/Inventory Panel"
		PANEL.SYSTEM:
			current_panel = $"Background/System Panel"
	current_panel.show_panel()

func play_accept_sound() -> void:
	audio_stream_player_3d.stream = MENU_SELECT
	audio_stream_player_3d.play()

func play_cancel_sound() -> void:
	audio_stream_player_3d.stream = MENU_BACK
	audio_stream_player_3d.play()

func play_move_sound() -> void:
	audio_stream_player_3d.stream = MENU_PICK
	audio_stream_player_3d.play()
