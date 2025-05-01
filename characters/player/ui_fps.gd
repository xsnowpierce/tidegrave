extends Label

func _process(delta: float) -> void:
	text = "FPS: " + str(floori(Engine.get_frames_per_second()))
