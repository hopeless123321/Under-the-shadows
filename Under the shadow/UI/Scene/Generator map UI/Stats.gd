extends GridContainer

const BLOODBEND = preload("res://All ability/Skills/Bloodbend.tres")
const SKILL_DESCRIPTION = preload("res://UI/Scene/Generator map UI/skill description.tscn")
@onready var color_rect = $"../Skills stores"

func _ready():
	call_deferred("lol")
func lol():
	var skill = SKILL_DESCRIPTION.instantiate()
	color_rect.add_child(skill)
	skill.size = size
	skill.create_skill(BLOODBEND)
