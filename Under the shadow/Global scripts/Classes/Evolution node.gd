@icon("res://Global scripts/Classes/Icons/Evolution node.svg")
extends Button
## Class that storage UnitProp for can add to Team, and other EvolutionNode that restrict Evolution 
class_name EvolutionNode
## Unit that represent on EvolutionNode
@export var unit_prop : UnitProp
## Parents EvolutionNode
@export var connected_down : Array[EvolutionNode]
## Child EvolutionNode
@export var connected_up : Array[EvolutionNode]
# Заменить на сигналы ?
@onready var team_container : GridContainer = $"../../../UI Evolve/PanelContainer/Teaminfo/Team container"
@onready var hbox : HBoxContainer = $"../../../UI Evolve/Souls container/MarginContainer/Hbox"
@onready var draggable : Control = $".."
## That lines connected to this EvolutionNode
var connected_lines : Array[LineEvolveNode]

func _ready() -> void:
	disabled = true
	add_to_group("Evolution node")
	if unit_prop != null:
		icon = unit_prop.icon_minimap
		connect("mouse_entered", reveal_unit)
		connect("pressed", upgrade_unit)
		connect("mouse_exited", cancel)
	for unit_node in connected_up:
		connected_lines.append(create_line(unit_node))

## Create line between two EvolutionNode
func create_line(unit_node : EvolutionNode) -> LineEvolveNode:
	var line : LineEvolveNode = LineEvolveNode.new()
	line.link(self, unit_node)
	add_child(line)
	return line

## Connect parent EvolutionNode and line to self
func link(unit_node : EvolutionNode, line : LineEvolveNode) -> void:
	connected_down.append(unit_node)
	connected_lines.append(line)

## Reveal posssible way to evolve on line
func activate_con_up() -> void:
	for line in connected_lines:
		if line.end != self:
			line.active = true

## Reveal exclusive path to that unit on Evolution Tree
func reveal_unit() -> void: 
	for line : LineEvolveNode in get_tree().get_nodes_in_group("Line evolution"):
		line.active = false
	Eventbus.emit_signal("get_unit_prop", unit_prop)
	reveal_path(self)

## Evolve unit to next  
func upgrade_unit() -> void: # maybe return function
	if team_container.unit_select() and GlobalInfo.check_price(unit_prop.cost) and check_prev():
		GlobalInfo.add_souls(-unit_prop.cost)
		activate_con_up()
		for evolve_unit in connected_down:
			if evolve_unit != null:
				evolve_unit.cut_excess(self)
		team_container.upgrade_unit(unit_prop)

## Remain parent node connected 
func cut_excess(target_evolve_node : EvolutionNode) -> void:
	for lines in connected_lines:
		if lines.end != self:
			lines.active = false
			if lines.end == target_evolve_node:
				lines.active = true

## Recusion function for all parent EvolutionNode
func reveal_path(target_evolve_node : EvolutionNode) -> void:
	if connected_down.is_empty() == false:
		for lines in connected_lines:
			if lines.end == target_evolve_node:
				lines.active = true
				lines.init.reveal_path(lines.init)

## Disactivate all lines
func cancel() -> void:
	team_container.reveal_path()
	hbox.revert_dif()

## Return true if parent EvolutionNode is actual
func check_prev() -> bool:
	for evolve_node in connected_down:
		if draggable.actual == evolve_node:
			return true
	return false
