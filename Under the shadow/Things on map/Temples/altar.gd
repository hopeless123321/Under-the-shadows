extends CharacterBody2D
class_name  Altars 

@onready var altar: Sprite2D = $Altar



func _on_mouse_entered() -> void:
	altar.material.set("shader_parameter/select", true)

func _on_mouse_exited() -> void:
	altar.material.set("shader_parameter/select", false)
