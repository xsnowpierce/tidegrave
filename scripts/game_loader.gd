extends Node

class_name GameLoader

@export var player_scene : PackedScene

@export var start_level : LoadLevel

@export var player_spawn_location : Vector3

var player : Player
var current_scene : Node3D

func _ready() -> void:
	if(player_scene):
		player = player_scene.instantiate()
		add_child(player)
		player.global_position = player_spawn_location
	
	if(start_level):
		load_new_level(start_level)

func load_new_level(loadlevel : LoadLevel) -> void:
	if(current_scene):
		current_scene.queue_free()
	current_scene = loadlevel.level_scene.instantiate()
	add_child(current_scene)
	
	print(current_scene.get_class())
	
	if(current_scene is LevelInformation):
		player.global_position = current_scene.spawnpoint.global_position
		player.set_camera_far_culling(current_scene.camera_far_culling)
