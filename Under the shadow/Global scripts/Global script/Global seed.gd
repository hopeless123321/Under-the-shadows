extends Node

func _ready() -> void:
	pass
	
func set_seed(new_seed : String) -> void:
	seed(new_seed.hash())
