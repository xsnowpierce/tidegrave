extends Area3D

var interactables : Array[WorldInteractable]

func _on_area_entered(area: Area3D) -> void:
	print("area entered: ", area.get_parent().name)
	if(area is WorldInteractable):
		interactables.append(area)

func _on_area_exited(area: Area3D) -> void:
	if(area is WorldInteractable):
		interactables.erase(area)
