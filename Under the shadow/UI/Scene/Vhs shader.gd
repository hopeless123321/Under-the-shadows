extends ColorRect

func _ready():
	Eventbus.connect("change_overlay", change_overlay )
	
func change_overlay(prop : String, value : float) -> void:
	var property := "shader_parameter/" + prop
	material.set(property, value)
