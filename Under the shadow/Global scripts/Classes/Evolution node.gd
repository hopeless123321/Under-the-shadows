extends Button
class_name EvolutionNode

@export var unit_prop : Unit_prop
@export var connected_down : Array[EvolutionNode]
@export var connected_up : Array[EvolutionNode]

@onready var team_container = $"../../../UI Evolve/PanelContainer/Teaminfo/Team container"
@onready var hbox = $"../../../UI Evolve/Souls container/MarginContainer/Hbox"
@onready var draggable = $".."


var connected_lines : Array[Line_evolve_node]

const OFFSET : Vector2 = Vector2(32, 32)

func _ready() -> void:
	if name == "Crossbow":
		connected_down.pop_front()
	disabled = true
	add_to_group("Evolution node")
	if unit_prop != null:
		icon = unit_prop.icon_select
		connect("mouse_entered", reveal_unit)
		connect("pressed", upgrade_unit)
		connect("mouse_exited", cancel)
	for unit_node in connected_up:
		connected_lines.append(create_line(unit_node))

func create_line(unit_node : EvolutionNode) -> Line_evolve_node: #создает линии
	var line : Line_evolve_node = Line_evolve_node.new()
	line.link(self, unit_node)
	add_child(line)
	return line

func link(unit_node : EvolutionNode, line : Line_evolve_node) -> void: #подключает линию и юнита снизу
	connected_down.append(unit_node)
	connected_lines.append(line)

func activate_con_up() -> void: #дает развилку существ
	for line in connected_lines:
		if line.end != self:
			line.active = true

func reveal_unit() -> void: #При наведении на существо показывает путь до него и его хар-ки
	for line in get_tree().get_nodes_in_group("Line evolution"):
		line.active = false
	Eventbus.emit_signal("get_unit_prop", unit_prop, false)
	reveal_path(self)

func upgrade_unit() -> void: # Улучшает юнита если кто-то выбран и есть души
	
	if team_container.unit_select() and GlobalInfo.check_price(unit_prop.cost) and check_prev():
		GlobalInfo.add_souls(-unit_prop.cost)
		activate_con_up()
		for evolve_unit in connected_down:
			evolve_unit.cut_excess(self)
		team_container.upgrade_unit(unit_prop)

func cut_excess(target_evolve_node : EvolutionNode) -> void: # Удаляет все лишние пути оставля только к юниту
	for lines in connected_lines:
		if lines.end != self:
			lines.active = false
			if lines.end == target_evolve_node:
				lines.active = true

func reveal_path(target_evolve_node : EvolutionNode) -> void: # Для всех юнитов снизу создает путь рекурсивно
	if connected_down.is_empty() == false:
		for lines in connected_lines:
			if lines.end == target_evolve_node:
				lines.active = true
				lines.init.reveal_path(lines.init)

func cancel() -> void: # сброс при выходе мышки
	team_container.reveal_path()
	hbox.revert_dif()
	
func check_prev() -> bool:
	for evolve_node in connected_down:
		if draggable.actual == evolve_node:
			return true
	return false
