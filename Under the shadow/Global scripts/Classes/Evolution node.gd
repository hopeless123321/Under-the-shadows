extends Button
class_name EvolutionNode

@export var unit_prop : Unit_prop
@export var connected_down : Array[EvolutionNode]
@export var connected_up : Array[EvolutionNode]
const LINE_2D_SPRITE = preload("res://UI/All theme/Line 2d sprite/Line 2D sprite.png")
const OFFSET : Vector2 = Vector2(32, 32)

func _ready() -> void:
	if unit_prop != null:
		icon = unit_prop.icon_select
	create_line(connected_up)
	connect("mouse_entered", press)
	

func create_line(con_up : Array[EvolutionNode]) -> void:
	for unit_node in con_up:
		var line : Line2D = Line2D.new()
		line.add_point(Vector2(0,0) + OFFSET)
		line.add_point(unit_node.position - position + OFFSET)
		line.global_position = Vector2(0 ,0)
		line.texture = LINE_2D_SPRITE
		line.texture_mode = Line2D.LINE_TEXTURE_TILE
		line.show_behind_parent = true
		add_child(line)
func press() -> void:
	Eventbus.emit_signal("get_unit_prop", unit_prop)
