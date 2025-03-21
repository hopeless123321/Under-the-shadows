extends GPUParticles2D

@onready var tile_map = $"../TileMap"


func _ready():
	call_deferred("get_top_size")
	
func get_top_size() -> void:
	@warning_ignore("integer_division")
	amount = GlobalInfo.size_map.size.x * GlobalInfo.size_map.size.y / 16328
	process_material.emission_box_extents = Vector3(GlobalInfo.size_map.size.x / 2.0, GlobalInfo.size_map.size.y / 2.0 , 0)
	process_material.emission_shape_offset = Vector3(GlobalInfo.size_map.size.x / 2.0 ,0 ,0)
