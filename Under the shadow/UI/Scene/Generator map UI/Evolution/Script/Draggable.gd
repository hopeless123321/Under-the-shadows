extends Control

@onready var initial : EvolutionNode = $Initial
var actual : EvolutionNode

func path_to(nameunit : String) -> void: #Посылает сигнал для показа пути и возможых путей
	for evolve_unit : EvolutionNode in get_tree().get_nodes_in_group("Evolution node"):
		if evolve_unit.name == nameunit:
			actual = evolve_unit
			evolve_unit.reveal_unit()
			evolve_unit.activate_con_up()

func new_unit() -> void: #Показывает ветки развития для нового юнита
	for line : Line_evolve_node in get_tree().get_nodes_in_group("Line evolution"):
		line.active = false
	initial.activate_con_up()
	actual = initial

func _unhandled_input(event : InputEvent) -> void:
	if Input.is_action_pressed("MMB"):
		global_position += Input.get_last_mouse_velocity() / 100
	#if event is InputEventMouseButton:
		#scale = clamp(scale, Vector2(0.6, 0.6), Vector2(1.5, 1.5))
		#if Input.is_action_pressed("zoomin"):
			#scale -= Vector2(0.02, 0.02)
		#if Input.is_action_pressed("zoomout"):
			#scale += Vector2(0.02, 0.02)
