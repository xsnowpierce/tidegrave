extends Area3D

class_name WorldInteractable

func interact():
	get_parent().get_node("AnimationPlayer").play("Talk")
