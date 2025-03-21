extends Node2D
@onready var am_p = $AnimationPlayer
@export_enum ("Teleport", "Walk", "Custom") var type_move : String
#???
func _ready() -> void:
	am_p.play("stay")
func move_anima() -> void:
	match type_move:
		"Teleport":
			pass
		"Walk":
			am_p.play("to walk")
			await am_p.animation_finished
			am_p.play("walk")
		"Custom":
			pass
func stop_anima() -> void:
	match type_move:
		"Teleport":
			pass
		"Walk":
			am_p.play("to stay")
			await am_p.animation_finished
			am_p.play("stay")
		"Custom":
			pass
