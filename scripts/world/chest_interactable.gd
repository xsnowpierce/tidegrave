extends WorldInteractable

class_name ChestInteractable

@export var holding_item : InventoryItem
@export var item_amount : int
@export var item_spawn_offset : Vector3 = Vector3(0, 0.1, 0)
@onready var animation_player: AnimationPlayer = $chest/AnimationPlayer

const PICKUP_ITEM = preload("res://resources/items/pickup_item.tscn")

var chest_is_open : bool

func interact(player : Player) -> PlayerUseItem.USE_ITEM_RESULT:
	if(!chest_is_open):
		open_chest()
	return PlayerUseItem.USE_ITEM_RESULT.IGNORE

func open_chest() -> void:
	$CollisionShape3D.disabled = true
	animation_player.play("Open")
	await animation_player.animation_finished
	spawn_item()
	chest_is_open = true

func spawn_item() -> void:
	var item : Node3D = PICKUP_ITEM.instantiate()
	item.set_item(holding_item, item_amount)
	$chest.add_child(item)
	item.position = item_spawn_offset
