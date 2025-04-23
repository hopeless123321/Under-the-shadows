extends GridContainer


@onready var draggable : Control = $"../../../../Clip frame/Draggable"


const BUTTON_GROUP_UNIT_BUTTON = preload("res://UI/Buttongroup/Button group unit button.tres")
const UNIT_BUTTON = preload("res://UI/All theme/Button/Unit button.tres")
var selected_button : Unit_button:
	get:
		return BUTTON_GROUP_UNIT_BUTTON.get_pressed_button()

func _input(_event : InputEvent) -> void: #Сброс при ESC
	if Input.is_action_just_pressed("ESC") and selected_button != null:
		selected_button.button_pressed = false
		for line : LineEvolveNode in get_tree().get_nodes_in_group("Line evolution"):
			line.active = false

func update() -> void: #обновляется каждый раз как появляется меню
	for unit_b : Unit_button in get_children(true):
		if unit_b.name != "New unit":
			unit_b.queue_free()

	for unit_resource : UnitOnTeam in UnitManager.team:
		var new_button : Unit_button = Unit_button.new()
		new_button.name = unit_resource.forename
		new_button.icon = unit_resource.icon_minimap
		new_button.unit_info = unit_resource
		new_button.toggle_mode = true
		new_button.theme = UNIT_BUTTON
		new_button.button_group = BUTTON_GROUP_UNIT_BUTTON
		add_child(new_button)
		move_child(new_button, get_child_count() - 2)

	for unit_b in get_children(true):
		if unit_b.name != "New unit" or unit_b.name != "King":
			unit_b.connect("pressed", reveal_path)

func reveal_path() -> void: #показывает путь до юнита при нажатии на него и сбрысывает пути если никто не выбран
	if unit_select() and selected_button.unit_info != null:
		draggable.path_to(selected_button.unit_info.forename)
	else:
		for line : LineEvolveNode in get_tree().get_nodes_in_group("Line evolution"):
			line.active = false
	
func upgrade_unit(upgrade_to : UnitProp) -> void: #улучшает юнита когда нажимается EvolutionNode. Создает в тиме нового юнта и удаляет старого
	var select_unit : UnitOnTeam = selected_button.unit_info
	select_unit = UnitManager.upgrade_unit(upgrade_to, select_unit)
	selected_button.update(select_unit)
	draggable.path_to(select_unit.forename)
	
func _on_new_unit_pressed() -> void: #Когда нажимается кнопка то создает новую кнопку в тиме и предлагает выбор юнита
	if selected_button == null or selected_button.unit_info != null:
		var new_ally : Unit_button = Unit_button.new()
		new_ally.custom_minimum_size = Vector2(64, 64)
		new_ally.text = "?"
		new_ally.toggle_mode = true
		new_ally.button_group = BUTTON_GROUP_UNIT_BUTTON
		new_ally.button_pressed = true
		new_ally.theme = UNIT_BUTTON
		add_child(new_ally)
		move_child(new_ally, get_child_count() - 2)
		draggable.new_unit()
		new_ally.connect("pressed", reveal_path)

func unit_select() -> bool: #проверка выбран ли юнит
	if selected_button != null:
		return true
	return false
