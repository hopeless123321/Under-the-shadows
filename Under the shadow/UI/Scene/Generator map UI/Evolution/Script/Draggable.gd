extends Control
@export var diction : Dictionary
@onready var initial : EvolutionNode = $Initial
var actual : EvolutionNode

func path_to(nameunit : String) -> void: #Посылает сигнал для показа пути и возможых путей
	for evolve_unit : EvolutionNode in get_tree().get_nodes_in_group("Evolution node"):
		if evolve_unit.name == nameunit:
			actual = evolve_unit
			evolve_unit.reveal_unit()
			evolve_unit.activate_con_up()

func new_unit() -> void: #Показывает ветки развития для нового юнита
	for line : LineEvolveNode in get_tree().get_nodes_in_group("Line evolution"):
		line.active = false
	initial.activate_con_up()
	actual = initial

func _on_gui_input(_event: InputEvent) -> void:
	if Input.is_action_pressed("MMB"):
		global_position += Input.get_last_mouse_velocity() / 100
