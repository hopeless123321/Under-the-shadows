extends HBoxContainer

const QUICK_BUTTON_TEMP : String = "Num_[number]"

@onready var icon: TextureRect = $Portret/MarginContainer/Icon

@onready var hp_value_l : Label = $Left_stats_cont/HP_value
@onready var will_value_l : Label = $Left_stats_cont/Will_value
@onready var speed_value_l : Label = $Left_stats_cont/Speed_value
@onready var reaction_speed_l : Label = $"Left_stats_cont/Reaction speed"
@onready var damage_amp_value_l : Label = $"Right_stat_cont/Damage amp value"
@onready var mag_resist_value_l : Label = $"Right_stat_cont/Mag_resist value"
@onready var phys_resist_value_l : Label = $"Right_stat_cont/Phys_resist value"
@onready var will_resist_value_l : Label = $"Right_stat_cont/Will_resist value"

@onready var will_bar : TextureProgressBar = $Will
@onready var hp_bar : TextureProgressBar = $Hp

@onready var skills_cont: HBoxContainer = $"Skills cont"

@onready var description: RichTextLabel = $Description

@export var timer : float = 1.0
const SKILL_CONTAINER : PackedScene = preload("res://UI/Scene/UI battle/Scene/Ability slot.tscn")


func _ready() -> void:
	Eventbus.connect("select_char", update_ui)
	Eventbus.connect("reveal_result_skill",set_skill_result_descripton)
	
func update_ui(unit : Unit) -> void:
	var unit_stats : UnitOnTeam = unit.unit_property
	clear_skill_slots()
	icon.texture = unit_stats.icon_minimap
	update_progress_bar(unit_stats.hp, unit_stats.will, unit_stats.max_hp)

	hp_value_l.text = str(unit_stats.max_hp) + "/" + str(unit_stats.hp)
	will_value_l.text = "100 /" + str(unit_stats.will)
	speed_value_l.text = str(unit_stats.speed)
	reaction_speed_l.text = str(unit_stats.reaction)
	damage_amp_value_l.text = str(unit_stats.damage.x) + "-" + str(unit_stats.damage.y)
	mag_resist_value_l.text = str(unit_stats.resist_mag_dmg)
	phys_resist_value_l.text = str(unit_stats.resist_phys_dmg)
	will_resist_value_l.text = str(unit_stats.resist_will)
	
	if !unit_stats.skills.is_empty():
		var skills : Array[Skill] = unit_stats.skills
		for order : int in skills.size():
			var skills_instance = SKILL_CONTAINER.instantiate()
			skills_cont.add_child(skills_instance)
			skills_instance.icon = skills[order].icon
			skills_instance.unit = unit
			skills_instance.data_skill = skills[order]
			skills_instance.init()
	set_description(unit)
	
func set_description(unit : Unit) -> void:
	description.text = unit.unit_property.forename + "\n"
	description.text += "Class: "
	for unit_class : int in unit.unit_property.class_unit:
		description.text += Translater.UNIT_CLASS[unit_class] + ", "
	description.text = description.text.left(-2)

func set_skill_result_descripton(text : String) -> void:
	description.text = text 
	
func clear_skill_slots() -> void:
	for skill in skills_cont.get_children():
		skill.queue_free()

func update_progress_bar(hp_value : int, will_value : int, max_hp : int) -> void:
	var hp_will_tween : Tween = create_tween()
	hp_will_tween.set_parallel()
	hp_will_tween.set_ease(Tween.EASE_IN_OUT)
	hp_will_tween.set_trans(Tween.TRANS_SINE)
	hp_will_tween.tween_property(will_bar, "value", will_value, timer)
	hp_will_tween.tween_property(hp_bar, "value", hp_value, timer)
	hp_will_tween.tween_property(hp_bar, "max_value", max_hp, timer)
