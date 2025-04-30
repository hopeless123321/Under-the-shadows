extends TextureRect
class_name RelicUI

const EMPTY_TOOLTIP_THEME = preload("res://UI/All theme/Tooltip/Tooltip empty.tres")
const TOOLTIP_THEME = preload("res://UI/All theme/Richtextlabel/ability_slot.tres")
const CENTER_RELIC_UI : Vector2i = Vector2i(32, 32)
@export var relic : Relic

func _ready() -> void:
	connect("mouse_entered", scale_up)
	connect("mouse_exited", scale_down)
	pivot_offset = CENTER_RELIC_UI
	theme = EMPTY_TOOLTIP_THEME

func added(added_relic : Relic) -> void:
	relic = added_relic
	texture = added_relic.icon
	relic.initiation()
	_make_custom_tooltip(relic.text_tooltip)

func _make_custom_tooltip(for_text: String) -> Object:
	var tooltip : RichTextLabel = RichTextLabel.new()
	tooltip_text = relic.text_tooltip
	tooltip.bbcode_enabled = true
	tooltip.theme = TOOLTIP_THEME
	tooltip.text = for_text
	tooltip.fit_content = true
	tooltip.custom_minimum_size = Vector2(400,0)
	tooltip.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return tooltip

func scale_up() -> void:
	var scale_up_tween : Tween = create_tween()
	scale_up_tween.set_ease(Tween.EASE_IN_OUT)
	scale_up_tween.set_trans(Tween.TRANS_SINE)
	scale_up_tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.5)

func scale_down() -> void:
	var scale_up_tween : Tween = create_tween()
	scale_up_tween.set_ease(Tween.EASE_IN_OUT)
	scale_up_tween.set_trans(Tween.TRANS_SINE)
	scale_up_tween.tween_property(self, "scale", Vector2(1, 1), 0.5)
