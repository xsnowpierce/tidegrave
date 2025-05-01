extends Node

class_name EnemyAI

@export var character : CharacterBody3D
@onready var enemy : Enemy = $".."
@onready var animation_player : AnimationPlayer = $"../AnimationPlayer"
@onready var audio_player : AudioStreamPlayer3D = $"../AudioStreamPlayer3D"

var aggression_player : Player
var has_player : bool

var is_attacking : bool
var is_being_hit : bool
var is_dying : bool

var hit_flash_tween : Tween
var hit_flash_speed : float = 0.18
@export var use_surface_material_override : bool = false
@export var albedo_color_path : String = "albedo_color"

@export var collision_collider : CollisionShape3D

func _on_wakeup_area_body_entered(body : Node3D) -> void:
	if(body is Player):
		aggression_player = body
		has_player = true
	else:
		print("body entered that was not player player, ", body.get_class())

func _on_wakeup_area_body_exited(body : Node3D) -> void:
	if(body is Player):
		aggression_player = null
		has_player = false

func _physics_process(delta: float) -> void:
	if not has_player:
		return
	
	if(is_attacking or is_being_hit or is_dying):
		return
	
	var angle_to_player : float = get_player_angle()
	
	if(angle_to_player > 180):
		# turn to the left
		character.rotate_y(-enemy.turn_speed * delta)
	else:
		# turn to the right
		character.rotate_y(enemy.turn_speed * delta)
	
	
	var can_enemy_attack : bool = true
	if((angle_to_player > 180 and angle_to_player < 360 - enemy.max_angle_to_player_acceptable / 2) or (angle_to_player < 180 and angle_to_player > enemy.max_angle_to_player_acceptable / 2)):
		# outside of target angle
		can_enemy_attack = false
	
	var distance_to_player : float = get_player_distance()
	
	if(distance_to_player > enemy.target_distance_to_player):
		can_enemy_attack = false
	
	if(can_enemy_attack):
		attack_player()
	
	if(enemy.stop_walking_near_player and distance_to_player < enemy.target_distance_to_player):
		character.velocity.x = move_toward(character.velocity.x, 0, enemy.move_speed);
		character.velocity.z = move_toward(character.velocity.z, 0, enemy.move_speed);
	else:
		character.velocity.x = character.transform.basis.z.x * enemy.move_speed;
		character.velocity.z = character.transform.basis.z.z * enemy.move_speed;

	character.move_and_slide()
	animate()

func get_player_distance() -> float:
	var player_non_y : Vector3 = aggression_player.global_position
	player_non_y.y = 0
	
	var our_non_y : Vector3 = character.global_position
	our_non_y.y = 0
	
	return our_non_y.distance_to(player_non_y)

func get_player_angle() -> float:
	var to_player = (aggression_player.global_position - character.global_position)
	to_player.y = 0
	to_player = to_player.normalized()

	var forward = -character.transform.basis.z
	forward.y = 0
	forward = forward.normalized()

	var dot = clamp(forward.dot(to_player), -1.0, 1.0)
	var angle = rad_to_deg(acos(dot))
	var signed_angle = angle * sign(forward.cross(to_player).y) + 180

	return signed_angle

func animate() -> void:
	
	if(is_attacking or is_being_hit or is_dying):
		return
	
	if(character.velocity.length() > 0 and !enemy.move_animation_name.is_empty()):
		animation_player.play(enemy.move_animation_name)
	else:
		if(!enemy.idle_animation_name.is_empty()):
			animation_player.play(enemy.idle_animation_name)
		else:
			animation_player.play("RESET")

func attack_player() -> void:
	if(enemy.attack_animation_name.is_empty() or is_attacking or is_dying):
		return
		
	is_attacking = true
	animation_player.play(enemy.attack_animation_name)
	await animation_player.animation_finished
	is_attacking = false

func attacked_from_player() -> void:
	if(is_being_hit or is_dying):
		return
		
	is_being_hit = true
	
	audio_player.stream = enemy.attacked_sound
	audio_player.play()
	
	play_hit_animation()
	play_hit_flash()

func play_hit_flash() -> void:
	if(hit_flash_tween):
		hit_flash_tween.kill()
	
	hit_flash_tween = create_tween()
	var target_color : Color = Color.RED
	
	if(!use_surface_material_override):
		var starting_albedo : Color = enemy.mesh.get_active_material(0).albedo_color
		hit_flash_tween.tween_property(enemy.mesh.get_active_material(0), albedo_color_path, target_color, hit_flash_speed)
		hit_flash_tween.tween_property(enemy.mesh.get_active_material(0), albedo_color_path, starting_albedo, hit_flash_speed)
	else:
		var starting_albedo : Color = enemy.mesh.get_surface_override_material(0).get_shader_parameter("albedo_color")
		hit_flash_tween.tween_property(enemy.mesh.get_surface_override_material(0), albedo_color_path, target_color, hit_flash_speed)
		hit_flash_tween.tween_property(enemy.mesh.get_surface_override_material(0), albedo_color_path, starting_albedo, hit_flash_speed)

func play_hit_animation() -> void:
	is_being_hit = true
	if(!enemy.hit_animation_name.is_empty()):
		animation_player.play(enemy.hit_animation_name)
		await animation_player.current_animation_length
	else:
		await get_tree().create_timer(0.2).timeout
	is_being_hit = false

func death() -> void:
	is_dying = true
	if(enemy.death_animation_name.is_empty()):
		enemy.queue_free()
		return
	
	play_hit_flash()
	animation_player.play(enemy.death_animation_name)
	
	aggression_player.add_experience(enemy.experience)
	audio_player.stream = enemy.death_sound
	audio_player.play()
	
	await animation_player.animation_finished
	
	try_drop_item()
	
	enemy.queue_free()

func try_drop_item() -> void:
	var spawn_location : Vector3 = get_parent().global_position + Vector3(0, 1, 0)
	
