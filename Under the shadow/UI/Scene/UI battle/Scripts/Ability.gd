extends TextureButton

const ABILITY_THEME : Theme = preload("res://UI/All theme/Richtextlabel/ability_slot.tres")
const TYPE_APPLICARION_SKILL : Dictionary = {
	"All world" : "All unit on map",
	"All area" : "All unit on radius",
	"Targets world" : "Unit(s) on map",
	"Targets area" : "Unit(s) on radius",
	"Directional" : "On line",
	"Directional with preset" : "Directional area",
	"Self" : "Self",
	"Bomb like" : "Area around unit", 
	"Tiles effects" : "On ground",
	"Spawn" : "Spawn"}
const COLOR_SPELL : Dictionary = {
	
}
var action_button : String
var unit : Unit
var data_skill : Skill


func init() -> void:
	action_button = "Num_" + str(get_parent().get_child_count())
	tooltip_text = set_text_tooltip(data_skill)
	if data_skill.cooldown != 0:
		if data_skill.cooldown_timer != 0:
			$PanelContainer.visible = true
			$PanelContainer/Label.text = str(data_skill.cooldown_timer)

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
	match skill.class_spell:
		"No type":
			text += skill.class_spell 
		"Lunar":
			text += "[wave amp=20.0 freq=5.0 connected=1][color=beige] " + skill.class_spell + "[/color][/wave]"
		"Blood":
			text += "[wave amp=20.0 freq=5.0 connected=1][color=crimson]" + skill.class_spell + "[/color][/wave]"
		"Suicide":
			text += "[wave amp=20.0 freq=5.0 connected=1][color=dim_gray]" + skill.class_spell + "[/color][/wave]"
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
