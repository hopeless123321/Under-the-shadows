extends HBoxContainer

@onready var value : Label = $Value
@onready var minus : Label = $Minus

const TIMER : float = 1.0

func _ready() -> void:
	Eventbus.connect("souls_changed", update)
	Eventbus.connect("get_unit_prop", reveal_dif)
	
func reveal_dif(unit_prop : Resource, check : bool) -> void:
	if !check:
		var tween_reveal_dif : Tween = create_tween()
		tween_reveal_dif.set_ease(Tween.EASE_IN_OUT)
		tween_reveal_dif.set_trans(Tween.TRANS_SINE)
		tween_reveal_dif.set_parallel()
		tween_reveal_dif.tween_property(value, "text", str(GlobalInfo.souls - unit_prop.cost), TIMER)
		tween_reveal_dif.tween_property(minus, "text", "-" + str(unit_prop.cost), TIMER)
		
func revert_dif() -> void:
	var tween_reveal_dif : Tween = create_tween()
	tween_reveal_dif.set_ease(Tween.EASE_IN_OUT)
	tween_reveal_dif.set_trans(Tween.TRANS_SINE)
	tween_reveal_dif.set_parallel()
	tween_reveal_dif.tween_property(value, "text", str(GlobalInfo.souls), TIMER)
	tween_reveal_dif.tween_property(minus, "text", "", TIMER)
	
func update(souls : int) -> void:
	var tween_reveal_dif : Tween = create_tween()
	tween_reveal_dif.set_ease(Tween.EASE_IN_OUT)
	tween_reveal_dif.set_trans(Tween.TRANS_SINE)
	tween_reveal_dif.set_parallel()
	tween_reveal_dif.tween_property(value, "text", str(souls), TIMER)
	tween_reveal_dif.tween_property(minus, "text", "", TIMER)
	
