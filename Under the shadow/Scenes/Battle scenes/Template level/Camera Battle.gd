extends Camera2D
const OFFSET = 256

func _ready() -> void: 
	Eventbus.connect('target_camera_to', target_to)
	Eventbus.connect("reveal_map",reveal_hide_map )
	call_deferred("_def")

func _unhandled_input(event : InputEvent) -> void:
	var viewport_half_x : float = get_viewport_rect().size.x/2 * (1 / zoom.x)
	var viewport_half_y : float = get_viewport_rect().size.y/2 * (1 / zoom.y)
	if Input.is_action_pressed("MMB") and enabled:
		global_position -= Input.get_last_mouse_velocity() / 100
	global_position.x = clamp(position.x, limit_left + viewport_half_x, limit_right - viewport_half_x)
	global_position.y = clamp(position.y, limit_top + viewport_half_y, limit_bottom - viewport_half_y)
	zoom = clamp(zoom, Vector2(0.7, 0.7), Vector2(2, 2))
	if event is InputEventMouseButton:
		if Input.is_action_pressed("zoomin"):
			zoom -= Vector2(0.02, 0.02)
		if Input.is_action_pressed("zoomout"):
			zoom += Vector2(0.02, 0.02)

func target_to(tile_pos : Vector2i) -> void:
	global_position = tile_pos

func _def() -> void:
	limit_bottom = GlobalInfo.size_map.size.y + OFFSET
	limit_right = GlobalInfo.size_map.size.x + OFFSET
	global_position = Vector2(GlobalInfo.size_map.size.x / 2, GlobalInfo.size_map.size.y / 2)

func reveal_hide_map() -> void:
	enabled = !enabled
