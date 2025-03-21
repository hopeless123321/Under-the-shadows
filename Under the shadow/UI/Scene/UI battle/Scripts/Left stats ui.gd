extends GridContainer

@onready var hp_value = $HP_VALUE
@onready var will_value = $Will_value
@onready var speed_value = $Speed_value
@onready var reaction_speed = $"Reaction speed"


func _ready() -> void:
	Eventbus.connect('select_char', update)
	
func update(data : Dictionary) -> void: 
	hp_value.text =  str(data.get("max_hp")) + "/" + str(data.get("hp"))
	will_value.text = '100/' + str(data.get("will"))
	speed_value.text = str(data.get("speed"))
	reaction_speed.text = str(data.get("reaction"))
