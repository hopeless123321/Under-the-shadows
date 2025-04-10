extends CharacterBody2D


@export_enum ("Ally", "Enemy", "Either") var kind_unit : String
func _ready() -> void:
	add_to_group("Altars")
	
func _on_area_2d_body_entered(body : Node2D) -> void:
	match kind_unit:
		"Ally":
			if body is Ally:
				body.dmg_amp * 2
		"Enemy":
			if body is Enemy:
				print(body.hp)
		"Either":
			if body is Unit:
				print(body.hp)


func _on_area_2d_body_exited(body : Node2D) -> void:
	match kind_unit:
		"Ally":
			if body is Ally:
				body.dmg_amp / 2
		"Enemy":
			if body is Enemy:
				print(body.hp)
		"Either":
			if body is Unit:
				print(body.hp)
