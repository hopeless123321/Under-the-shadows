extends TextureRect

const TOOLTIP_THEME = preload("res://UI/All theme/Richtextlabel/ability_slot.tres")
@onready var duration : Label = $Duration

func update_text(value : String) -> void:
	duration.text = value
	
func _make_custom_tooltip(for_text: String) -> Object:
	var tooltip : RichTextLabel = RichTextLabel.new()
	tooltip_text = for_text
	tooltip.bbcode_enabled = true
	tooltip.theme = TOOLTIP_THEME
	tooltip.text = for_text
	tooltip.fit_content = true
	tooltip.custom_minimum_size = Vector2(400,0)
	tooltip.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return tooltip
