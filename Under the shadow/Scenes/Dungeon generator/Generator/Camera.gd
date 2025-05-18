extends Camera2D

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("MMB") and enabled:
		global_position -= Input.get_last_mouse_velocity() / 100
	zoom = clamp(zoom, Vector2(0.7, 0.7), Vector2(2, 2))
	if event is InputEventMouseButton:
		if Input.is_action_pressed("zoomin"):
			zoom -= Vector2(0.02, 0.02)
		if Input.is_action_pressed("zoomout"):
			zoom += Vector2(0.02, 0.02)
