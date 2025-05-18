extends ColorRect
class_name ShaderManager


func _ready() -> void:
	Eventbus.connect("change_overlay", change_overlay )
## Change overlay when settings change
func change_overlay(prop : String, value : float) -> void:
	var property := "shader_parameter/" + prop
	material.set(property, value)
