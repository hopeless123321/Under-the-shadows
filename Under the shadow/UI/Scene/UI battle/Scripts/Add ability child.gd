extends HBoxContainer

@onready var will = $Will
@onready var hp = $Hp

var ability_container = preload("res://UI/Scene/UI battle/Scene/Ability slot.tscn")

@onready var icon = $Icon/MarginContainer/Icon

func _ready() -> void:
	Eventbus.connect('select_char',update_ui)
func update_ui(data : Dictionary) -> void:
	icon.texture = data.get('icon')
	hp.max_value = data["max_hp"]
	update_progress_bar(data["hp"], data["will"], data["max_hp"])
	if get_children().size() > 6:
			for child in range(6, get_children().size()):
				get_child(child).queue_free()
	if data.get('ability') != []:
		var ability = data.get('ability')
		for i in ability.size():
			var ability_instance = ability_container.instantiate()
			ability_instance.number_skill = i + 1
			add_child(ability_instance)
			ability_instance.texture_normal = ability[i].icon
			ability_instance.text = text_tooltip(ability[i])
			ability_instance.unit = data.get("unit")
			ability_instance.data_ability = ability[i]
			ability_instance.init()
			
func text_tooltip(ability : Skill) -> String:
	var text : String
	text = ability.description + '\n'
	text += 'HP cost: ' + str(ability.cost_hp) + '\n'
	text += 'Will cost: ' + str(ability.cost_will) +'\n'
	text += 'Cooldown: ' + str(ability.cooldown) + ' turn(s)' + '\n'
	text += 'Type spell: '
	match ability.class_spell:
		"No type":
			text += ability.class_spell 
		"Lunar":
			text += "[wave amp=20.0 freq=5.0 connected=1][color=beige] " + ability.class_spell + "[/color][/wave]"
		"Blood":
			text += "[wave amp=20.0 freq=5.0 connected=1][color=crimson]" + ability.class_spell + "[/color][/wave]"
		"Suicide":
			text += "[wave amp=20.0 freq=5.0 connected=1][color=dim_gray]" + ability.class_spell + "[/color][/wave]"
	text += '\nUnit: '
	match ability.type_unit:
		"Ally":
			text += "[color=green]" + ability.type_unit + "[/color]"
		"Enemy":
			text += "[color=red]" + ability.type_unit + "[/color]"
		"Either":
			text += ability.type_unit
	if ability.active:
		text += "active"
		text += "\n" + "Cooldown : " + str(ability.cooldown) + "\n"
	elif ability.active == false:
		text += "passive"
	text += "class: " + ability.class_spell
	return text 

func update_progress_bar(hp_v : int, will_v : int, max_hp : int) -> void:
	var hp_will_tween = create_tween()
	hp_will_tween.set_parallel()
	hp_will_tween.set_ease(Tween.EASE_IN_OUT)
	hp_will_tween.set_trans(Tween.TRANS_CUBIC)
	hp_will_tween.tween_property(will, "value", will_v, 1)
	hp_will_tween.tween_property(hp, "value", hp_v, 1)
	hp_will_tween.tween_property(hp, "max_value", max_hp, 1)
	# изменение постепенно хп бара

