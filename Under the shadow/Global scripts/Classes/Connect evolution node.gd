extends Line2D
## Line that link different Evolution node between themself. 
## Every line have direction that represent relationship of every EvolutionNode
class_name LineEvolveNode

const LINE_2D_ACTIVE = preload("res://UI/Themes/Line 2d sprite/Line 2D active.png")
const LINE_2D_DISABLE = preload("res://UI/Themes/Line 2d sprite/Line 2D disable.png")
## Offset for right visualization line on Evolution tree
const OFFSET = Vector2(32, 32)
## Parent EvolutionNode
var init : EvolutionNode
## Child EvolutionNode
var end : EvolutionNode
## Represent relationship between init EvolutionNode and end EvolutionNode
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
##Connect two EvolutionNode and add line between them
func link(init_node : EvolutionNode, end_node : EvolutionNode) -> void:
	init = init_node
	end = end_node
	add_point(Vector2(0,0) + OFFSET)
	add_point(end_node.global_position - init_node.global_position + OFFSET)
	end_node.link(init_node, self)
