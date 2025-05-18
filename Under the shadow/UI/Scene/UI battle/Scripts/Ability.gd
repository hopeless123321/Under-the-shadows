extends Button

const ABILITY_THEME : Theme = preload("res://UI/Themes/Richtextlabel/Ability slot.tres")
const TYPE_APPLICARION_SKILL : Dictionary = {
	Skill.TypeApplication.AllWorld : "All unit on map",
	Skill.TypeApplication.AllArea : "All unit on radius",
	Skill.TypeApplication.TargetsWorld : "Unit(s) on map",
	Skill.TypeApplication.TargetsArea : "Unit(s) on radius",
	Skill.TypeApplication.Directional : "On line",
	Skill.TypeApplication.DirectionalWithPreset : "Directional area",
	Skill.TypeApplication.Self : "Self",
	Skill.TypeApplication.BombLike : "Area around unit", 
	Skill.TypeApplication.TilesEffects : "On ground",
	Skill.TypeApplication.Spawn : "Spawn",
	}
var action_button : String
var unit : Unit
var data_skill : Skill


func init() -> void:
	action_button = "Num_" + str(get_parent().get_child_count())
	tooltip_text = set_text_tooltip(data_skill)
	if data_skill.cooldown != 0:
		if data_skill.cooldown_timer != 0:
			disabled = true
			$Label.text = str(data_skill.cooldown_timer)

func _unhandled_key_input(event: InputEvent) -> void:
	if Input.is_action_just_released(action_button):
		button_pressed = true
		
func set_text_tooltip(skill : Skill) -> String:
	var text : String
	text += "[center] [font_size=22] " + skill.forename + " [/font_size] [/center]"
	text += "[fill]" + skill.description + ' [/fill] \n'
	text += "[table=2]"
#//
	if skill.cost_hp != 0:
		text += '[cell bg=#32211f,#1e1e1c]HP cost [/cell][cell bg=#32211f,#1e1e1c]' + str(skill.cost_hp) + '[/cell]'
	if skill.cost_will != 0:
		text += '[cell bg=#32211f,#1e1e1c]Will cost: [/cell][cell bg=#32211f,#1e1e1c]' + str(skill.cost_will) +'[/cell]'
#//
	if skill.active:
		text += "[cell bg=#32211f,#1e1e1c]Spell type[/cell] [cell bg=#32211f,#1e1e1c]Active[/cell]"
		if skill.cooldown != 0:
			text += '[cell bg=#32211f,#1e1e1c]Cooldown[/cell] [cell bg=#32211f,#1e1e1c]' + str(skill.cooldown) + ' turn(s)[/cell]'
	else:
		text += "[cell bg=#32211f,#1e1e1c]Spell type[/cell] [cell bg=#32211f,#1e1e1c]Passive[/cell]"
#//
	text += "[cell bg=#32211f,#1e1e1c]Type spell[/cell][cell bg=#32211f,#1e1e1c]"
	match skill.type_spell:
		Skill.TypeSpell.NoType:
			text += "No type"
		Skill.TypeSpell.Lunar:
			text += "[wave amp=10.0 freq=5.0 connected=1][color=beige] Lunar [/color][/wave]"
		Skill.TypeSpell.Blood:
			text += "[wave amp=10.0 freq=5.0 connected=1][color=crimson] Blood [/color][/wave]"
		Skill.TypeSpell.Suicide:
			text += "[wave amp=10.0 freq=5.0 connected=1][color=dim_gray] Suicide [/color][/wave]"
	text += "[/cell]"
#//
	text += '[cell bg=#32211f,#1e1e1c]Type application                [/cell][cell bg=#32211f,#1e1e1c][skill_application][/cell]'.replace("[skill_application]",TYPE_APPLICARION_SKILL[skill.type_application])
	for property : String in skill.PROP_TO_REVEAL.slice(4):
		property = property.replace("_", " ").capitalize()
		match typeof(skill.get(property)):
			1: #bool
				if skill.get(property):
					text += "[cell bg=#32211f,#1e1e1c]" + property + "[/cell][cell bg=#32211f,#1e1e1c]+[/cell]"
				else:
					text += "[cell bg=#32211f,#1e1e1c]" + property + "[/cell][cell bg=#32211f,#1e1e1c]-[/cell]"
			2: #int
				text += "[cell bg=#32211f,#1e1e1c]" + property + "[/cell][cell bg=#32211f,#1e1e1c]" + str(skill.get(property)) + "[/cell]"
			4: #string
				text += "[cell bg=#32211f,#1e1e1c]" + property + "[/cell][cell bg=#32211f,#1e1e1c]" + skill.get(property) + "[/cell]"
	return text 

func _make_custom_tooltip(for_text) -> RichTextLabel:
	var tooltip : RichTextLabel = RichTextLabel.new()
	tooltip.bbcode_enabled = true
	tooltip.theme = ABILITY_THEME
	tooltip.text = for_text
	tooltip.fit_content = true
	tooltip.custom_minimum_size = Vector2(500,300)
	return tooltip

func _on_pressed() -> void:
	if unit.current_state == unit._st.wait:
		unit._st.spell_cast.skill = data_skill
		unit.change_state(unit._st.spell_cast)
