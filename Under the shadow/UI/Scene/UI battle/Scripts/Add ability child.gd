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

@export var timer : float = 1.0
var skill_container : PackedScene = preload("res://UI/Scene/UI battle/Scene/Ability slot.tscn")


func _ready() -> void:
	Eventbus.connect('select_char',update_ui)

func update_ui(unit : Unit) -> void:
	clear_skill_slots()
	icon.texture = unit.icon_select
	update_progress_bar(unit.hp, unit.will, unit.max_hp)

	hp_value_l.text = str(unit.max_hp) + "/" + str(unit.hp)
	will_value_l.text = "100 /" + str(unit.will)
	speed_value_l.text = str(unit.speed)
	reaction_speed_l.text = str(unit.reaction)
	damage_amp_value_l.text = str(unit.dmg_amp)
	mag_resist_value_l.text = str(unit.resist_mag_dmg)
	phys_resist_value_l.text = str(unit.resist_phys_dmg)
	will_resist_value_l.text = str(unit.resist_will)

	if !unit.skills.is_empty():
		var skills : Array[Skill] = unit.skills
		for order : int in skills.size():
			var skills_instance = skill_container.instantiate()
			skills_cont.add_child(skills_instance)
			skills_instance.texture_normal = skills[order].icon
			skills_instance.unit = unit
			skills_instance.data_skill = skills[order]
			skills_instance.init()
			

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
	# изменение постепенно хп бара

