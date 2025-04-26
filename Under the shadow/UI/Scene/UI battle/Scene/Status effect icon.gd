extends TextureRect

@onready var duration : Label = $Duration
func update_text(value : String) -> void:
	duration.text = value
func _make_custom_tooltip(for_text: String) -> Object:
	var text_label : RichTextLabel = RichTextLabel.new()
	return 
