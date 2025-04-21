extends Node

class_name GameLoader

@export var player_scene : PackedScene

@export var start_scene : PackedScene

@export var player_spawn_location : Vector3

var player : Player
var current_scene : Node3D

func _ready() -> void:
	if(start_scene):
		current_scene = start_scene.instantiate()
		add_child(current_scene)
	
	if(player_scene):
		player = player_scene.instantiate()
		add_child(player)
		player.global_position = player_spawn_location

func load_new_level(loadlevel : LoadLevel) -> void:
	current_scene.queue_free()
	current_scene = loadlevel.level_scene.instantiate()
	add_child(current_scene)
	
	if(current_scene is DungeonInformation):
		player.global_position = current_scene.spawnpoint.global_position
