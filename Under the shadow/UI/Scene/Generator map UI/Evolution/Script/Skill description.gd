extends VBoxContainer

@onready var skill_icon : TextureRect = $"Skill/Skill icon"
@onready var skill_name : Label = $Skill/Name
@onready var description_skill : Label = $"Description skill"
@onready var prop : Label = $Prop
@onready var prop_grid : GridContainer = $"Prop Grid"

const LABEL_UI : Theme = preload("res://UI/All theme/Label/Label_Ui.tres")

func _input(event : InputEvent) -> void:
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
	for property in skill.skill_prop:
		create_prop_des(property, skill.skill_prop.get(property))
	
	
func create_prop_des(key : String, value : String) -> void:
	var prop_label : Label = Label.new()
	var value_label : Label = Label.new()
	prop_label.theme = LABEL_UI
	prop_label.text = key
	prop_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	prop_label.size_flags_horizontal = Control.SIZE_EXPAND
	value_label.theme = LABEL_UI
	value_label.text = value
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	
	prop_grid.add_child(prop_label)
	prop_grid.add_child(value_label)
	
