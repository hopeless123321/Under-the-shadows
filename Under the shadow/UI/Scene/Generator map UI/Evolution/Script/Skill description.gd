extends VBoxContainer

@onready var skill_icon : TextureRect = $"Skill/Skill icon"
@onready var skill_name : Label = $Skill/Name
@onready var description_skill : Label = $"Description skill"
@onready var prop : Label = $Prop
@onready var prop_grid : GridContainer = $"Prop Grid"

const LABEL_UI : Theme = preload("res://UI/All theme/Label/Label_Ui.tres")
const CONVERT_VARUABLE : Dictionary = {
}
func _input(event : InputEvent) -> void:
	if Input.is_action_just_pressed("Add info"):
		prop.visible = true
		prop_grid.visible = true
	elif Input.is_action_just_released("Add info"):
		prop.visible = false
		prop_grid.visible = false

func create_skill(skill : Skill) -> void:
	if skill != null:
		skill_icon.texture = skill.icon
		skill_name.text = skill.forename
		description_skill.text = skill.description
		for property : String in skill.PROP_TO_REVEAL:
			match typeof(skill.get(property)):
				1: #bool
					if skill.get(property):
						create_prop_des(property, "+")
					else:
						create_prop_des(property, '-')
				2: #int
					create_prop_des(property, str(skill.get(property)))
				4: #string
					create_prop_des(property, skill.get(property))
	
func create_prop_des(key : String, value : String) -> void:
	var prop_label : Label = Label.new()
	var value_label : Label = Label.new()
	prop_label.theme = LABEL_UI
	prop_label.text = key.replace("_", " ").capitalize()
	prop_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	prop_label.size_flags_horizontal = Control.SIZE_EXPAND
	value_label.theme = LABEL_UI
	value_label.text = value
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	prop_grid.add_child(prop_label)
	prop_grid.add_child(value_label)
	
