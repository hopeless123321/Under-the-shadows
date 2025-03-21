extends TextureButton

var text : String
var ability_theme = preload("res://UI/All theme/Richtextlabel/ability_slot.tres")
var unit : Unit
var data_ability : Base_ability
var number_skill : int
var action_button : String = "Num_"

func init() -> void:
	if data_ability.cooldown != 0:
		if data_ability.cooldown_timer != 0:
			$PanelContainer.visible = true
			$PanelContainer/Label.text = str(data_ability.cooldown_timer)
	action_button += str(number_skill)

func _shortcut_input(_event) -> void:
	if Input.is_action_just_pressed(action_button):
		_on_pressed()

func _make_custom_tooltip(_for_text):
	var tooltip = RichTextLabel.new()
	tooltip.bbcode_enabled = true
	tooltip.theme = ability_theme
	tooltip.text = text
	tooltip.fit_content = true
	tooltip.custom_minimum_size = Vector2(300,300)
	return tooltip

func _on_pressed() -> void:
	if unit.current_state == unit._st.wait:
		unit._st.spell_cast.ability = data_ability
		unit.change_state(unit._st.spell_cast)
