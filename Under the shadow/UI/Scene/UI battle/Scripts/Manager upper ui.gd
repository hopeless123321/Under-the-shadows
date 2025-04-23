extends HBoxContainer

@onready var turn_label : Label = $Turn
@onready var stage : Label = $Stage
@onready var in_game_timer : Label = $"In Game timer"
@onready var souls : Label = $Souls
@onready var relics_container : HBoxContainer = $"Relic Handler"
@onready var switch: Button = $Switch

const EVOLUTION_ICON : Rect2 = Rect2(128, 0, 64, 64)
const MAP_ICON : Rect2 = Rect2(64, 0, 64, 64) 

var time : int

func _ready() -> void:
	Eventbus.connect("new_turn_for_everyone", update_turn)
	Eventbus.connect("souls_changed", update_souls)
	stage.text = "Stage: " + str(GlobalInfo.stage)
	souls.text = str(GlobalInfo.souls)
	turn_label.text = str(GlobalInfo.turns_to_way_out)
	
func _physics_process(_delta : float) -> void:
	time += 1
	var sec : String = str((time % 3600) / 60).pad_zeros(2)
	var minute : String = str((time % 216000) / 3660).pad_zeros(2)
	var hour : String = str(time / 216000).pad_zeros(2)
	in_game_timer.text = hour + ":" + minute + ":" + sec

func update_turn(turn : int) -> void:
	turn_label.text = "Turn: " + str(turn)

func update_souls(value : int) -> void:
	var tween_label : Tween = create_tween()
	tween_label.set_ease(Tween.EASE_IN_OUT)
	tween_label.set_trans(Tween.TRANS_BOUNCE)
	tween_label.tween_property(souls, "text", str(value), 1)

func switch_button(on_fight : bool, left_time : int) -> void:
	if on_fight:
		switch.icon.region = MAP_ICON
		turn_label.text = "Turn: 1"
		stage.text = "Current location: " + str(GlobalInfo.location)
	else:
		switch.icon.region = EVOLUTION_ICON
		turn_label.text = "Left time: " + str(left_time)

func update_left_time(left_time : float) -> void:
	turn_label.text = "Left time" + str(left_time)
