extends VBoxContainer

const SKILL_DESCRIPTION : PackedScene = preload("res://UI/Scene/Generator map UI/Evolution/Scene/Skill description.tscn")

@onready var name_l : Label = $Name
@onready var preview_unit : TextureRect = $"CenterContainer/Preview unit"
@onready var class_value : Label = $"Class value"
@onready var max_hp_value  : Label= $"Stats/Max hp value"
@onready var hp_value  : Label= $"Stats/Hp value"
@onready var speed_value : Label = $"Stats/Speed value"
@onready var reaction_value : Label = $"Stats/Reaction value"
@onready var phys_resist_value : Label = $"Stats/Phys resist value"
@onready var magic_resist_value : Label = $"Stats/Magic resist value"
@onready var will_resist_value : Label = $"Stats/Will resist value"
@onready var dmg_amp_value : Label = $"Stats/Dmg amp value"
@onready var skills_stores : VBoxContainer = $"Skills stores"
@onready var description : RichTextLabel = $Description

func _ready() -> void:
	Eventbus.connect("get_unit_prop", update)
	Eventbus.connect("get_unit_on_team", update)
	
func update(unit_prop : Resource) -> void:
	for skill in skills_stores.get_children():
		skill.queue_free()
	class_value.text = ""
	preview_unit.texture = unit_prop.icon
	name_l.text = unit_prop.forename
	max_hp_value.text = str(unit_prop.max_hp)
	speed_value.text = str(unit_prop.speed)
	reaction_value.text = str(unit_prop.reaction)
	phys_resist_value.text = str(unit_prop.resist_phys_dmg)
	magic_resist_value.text = str(unit_prop.resist_mag_dmg)
	will_resist_value.text = str(unit_prop.resist_will)
	dmg_amp_value.text = str(unit_prop.damage.x) + "-" + str(unit_prop.damage.y)
	
	if unit_prop is UnitOnTeam:
		hp_value.text = str(unit_prop.hp)
	elif unit_prop is UnitProp:
		hp_value.text = str(unit_prop.max_hp)
	
	for skill : Skill in unit_prop.skills:
		var skill_d : VBoxContainer = SKILL_DESCRIPTION.instantiate()
		skills_stores.add_child(skill_d)
		skill_d.create_skill(skill)
	for unit_class : int in unit_prop.class_unit:
		class_value.text += Translater.UNIT_CLASS[unit_class] + ", "
	class_value.text = class_value.text.left(-2)
