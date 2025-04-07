extends VBoxContainer

@onready var skill_icon = $"Skill/Skill icon"
@onready var skill_name = $Skill/Name
@onready var description_skill = $"Description skill"
@onready var prop = $Prop
@onready var prop_grid = $"Prop Grid"

const LABEL_UI = preload("res://UI/All theme/Label/Label_Ui.tres")

func _input(event) -> void:
	if Input.is_action_just_pressed("Add info"):
		prop.visible = true
		prop_grid.visible = true
	elif Input.is_action_just_released("Add info"):
		prop.visible = false
		prop_grid.visible = false
func create_skill(skill : Skill) -> void:
	skill_icon.texture = skill.icon
	skill_name.text = skill.name
	description_skill.text = skill.description
	for prop in skill.skill_prop:
		create_prop_des(prop, skill.skill_prop.get(prop))
	
	
func create_prop_des(key : String, value : String) -> void:
	var prop_label = Label.new()
	var value_label = Label.new()
	prop_label.theme = LABEL_UI
	prop_label.text = key
	prop_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	prop_label.size_flags_horizontal = Control.SIZE_EXPAND
	value_label.theme = LABEL_UI
	value_label.text = value
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	
	prop_grid.add_child(prop_label)
	prop_grid.add_child(value_label)
	
