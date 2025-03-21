extends PointLight2D


func _physics_process(delta):
	texture_scale += randi_range(-1, 1) * delta 
	texture_scale = clamp(texture_scale, 1.2, 1.4)
