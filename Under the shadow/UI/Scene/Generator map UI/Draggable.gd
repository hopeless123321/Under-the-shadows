extends Control



func _unhandled_input(event) -> void:
	if Input.is_action_pressed("MMB"):
		global_position += Input.get_last_mouse_velocity() / 100
	#if event is InputEventMouseButton:
		#scale = clamp(scale, Vector2(0.6, 0.6), Vector2(1.5, 1.5))
		#if Input.is_action_pressed("zoomin"):
			#scale -= Vector2(0.02, 0.02)
		#if Input.is_action_pressed("zoomout"):
			#scale += Vector2(0.02, 0.02)
