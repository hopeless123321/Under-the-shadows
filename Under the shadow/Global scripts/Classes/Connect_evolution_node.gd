extends Line2D
class_name Line_evolve_node

const LINE_2D_ACTIVE = preload("res://UI/All theme/Line 2d sprite/Line 2D active.png")
const LINE_2D_DISABLE = preload("res://UI/All theme/Line 2d sprite/Line 2D disable.png")
const OFFSET = Vector2(32, 32)

var init : EvolutionNode
var end : EvolutionNode
var active: bool:
	set(value):
		active = value
		if value:
			texture = LINE_2D_ACTIVE
			end.disabled = false
		else:
			texture = LINE_2D_DISABLE
			end.disabled = true

func _ready() -> void:
	add_to_group("Line evolution")
	texture = LINE_2D_DISABLE
	show_behind_parent = true
	texture_mode = Line2D.LINE_TEXTURE_TILE
	z_index = -1

func link(init_node : EvolutionNode, end_node : EvolutionNode) -> void:
	init = init_node
	end = end_node
	add_point(Vector2(0,0) + OFFSET)
	add_point(end_node.global_position - init_node.global_position + OFFSET)
	end_node.link(init_node, self)
