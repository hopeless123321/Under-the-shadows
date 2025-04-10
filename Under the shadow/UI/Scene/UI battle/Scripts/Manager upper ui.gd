extends HBoxContainer

@onready var turn_label : Label = $Turn
@onready var stage : Label = $Stage
@onready var in_game_timer : Label = $"In Game timer"
@onready var souls : Label = $Souls
@onready var relics_container : HBoxContainer = $"HboxCont relics"
@onready var map_button : Button = $"Map button"

var time : int

func _ready() -> void:
	Eventbus.connect("end_turn", update_turn)
	Eventbus.connect("souls_changed", update_souls)
	stage.text = "Stage: " + str(GlobalInfo.stage)
	souls.text = str(GlobalInfo.souls)
	
func _physics_process(_delta : float) -> void:
	time += 1
	var sec : String = str((time % 3600) / 60).pad_zeros(2)
	var min : String = str((time % 216000) / 3660).pad_zeros(2)
	var hour : String = str(time / 216000).pad_zeros(2)
	in_game_timer.text = hour + ":" + min + ":" + sec

func update_turn(turn : int) -> void:
	turn_label.text = "Turn: " + str(turn)

func update_souls(value : int) -> void:
	var tween_label : Tween = create_tween()
	tween_label.set_ease(Tween.EASE_IN_OUT)
	tween_label.set_trans(Tween.TRANS_BOUNCE)
	tween_label.tween_property(souls, "text", str(value), 1)


func _on_map_button_pressed() -> void:
	Eventbus.emit_signal("reveal_map")
