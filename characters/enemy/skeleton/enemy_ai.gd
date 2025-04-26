extends Node

class_name EnemyAI

@export var character : CharacterBody3D
@onready var enemy : Enemy = $".."
@onready var animation_player : AnimationPlayer = $"../AnimationPlayer"
var player : CharacterBody3D
var has_player : bool

var is_attacking : bool
var is_being_hit : bool


func _on_wakeup_area_body_entered(body : Node3D) -> void:
	if(body is CharacterBody3D):
		player = body
		has_player = true
	else:
		print("body entered that was not player player, ", body.get_class())

func _on_wakeup_area_body_exited(body : Node3D) -> void:
	has_player = false
	player = null

func _physics_process(delta: float) -> void:
	if not has_player:
		return
	
	if(is_attacking or is_being_hit):
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
	
	if distance_to_player > enemy.target_distance_to_player:
		character.velocity.x = character.transform.basis.z.x * enemy.move_speed;
		character.velocity.z = character.transform.basis.z.z * enemy.move_speed;
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, enemy.move_speed);
		character.velocity.z = move_toward(character.velocity.z, 0, enemy.move_speed);

	character.move_and_slide()
	animate()

func get_player_distance() -> float:
	var player_non_y : Vector3 = player.global_position
	player_non_y.y = 0
	
	var our_non_y : Vector3 = character.global_position
	our_non_y.y = 0
	
	return our_non_y.distance_to(player_non_y)

func get_player_angle() -> float:
	var to_player = (player.global_position - character.global_position)
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
	
	if(is_attacking or is_being_hit):
		return
	
	if(character.velocity.length() > 0 and !enemy.move_animation_name.is_empty()):
		animation_player.play(enemy.move_animation_name)
	else:
		if(!enemy.idle_animation_name.is_empty()):
			animation_player.play(enemy.idle_animation_name)
		else:
			animation_player.play("RESET")

func attack_player() -> void:
	if(enemy.attack_animation_name.is_empty() or is_attacking):
		return
		
	is_attacking = true
	animation_player.play(enemy.attack_animation_name)
	await animation_player.animation_finished
	is_attacking = false

func attacked_from_player() -> void:
	if(enemy.hit_animation_name.is_empty() or is_being_hit):
		return
		
	is_being_hit = true
	
	play_hit_animation()
	play_hit_flash()

func play_hit_flash() -> void:
	var current_tint_alpha : float = .5
	for mesh in enemy.meshes:
		mesh.get_surface_override_material(0).set_shader_parameter("HitEffect", .5)
		
	while(current_tint_alpha > 0):
		for mesh in enemy.meshes:
			mesh.get_surface_override_material(0).set_shader_parameter("HitEffect", current_tint_alpha)
		current_tint_alpha -= get_process_delta_time() * enemy.hit_effect_speed
		await get_tree().process_frame

func play_hit_animation() -> void:
	if(!enemy.hit_animation_name.is_empty()):
		animation_player.play(enemy.hit_animation_name)
		await animation_player.animation_finished
	else:
		await get_tree().create_timer(0.2).timeout
	is_being_hit = false

func death() -> void:
	if(enemy.death_animation_name.is_empty()):
		enemy.queue_free()
		return
	
	play_hit_flash()
	animation_player.play(enemy.death_animation_name)
	await animation_player.animation_finished
	enemy.queue_free()
