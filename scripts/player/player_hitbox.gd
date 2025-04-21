extends Area3D

signal player_attacked()


func _on_area_entered(area: Area3D) -> void:
	player_attacked.emit()
