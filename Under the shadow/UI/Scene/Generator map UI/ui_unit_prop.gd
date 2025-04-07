extends Control

@onready var team_container = $"PanelContainer/Teaminfo/Team container"

func _ready() -> void:
	Eventbus.connect("update_end_battle", update)
	
func update() -> void:
	for unit_b in team_container.get_children():
		if unit_b.name != "New button":
			unit_b.queue_free()
	for unit in Teaminfo.team:
		var unit_b : Button = Button.new()
		


func _on_new_button_pressed() -> void:
	pass # Replace with function body.
