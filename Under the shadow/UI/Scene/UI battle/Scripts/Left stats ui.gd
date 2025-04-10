extends GridContainer

@onready var hp_value : Label = $HP_value
@onready var will_value : Label= $Will_value
@onready var speed_value : Label = $Speed_value
@onready var reaction_speed : Label = $"Reaction speed"


func _ready() -> void:
	Eventbus.connect('select_char', update)
	
func update(data : Dictionary) -> void: 
	hp_value.text =  str(data.get("max_hp")) + "/" + str(data.get("hp"))
	will_value.text = '100/' + str(data.get("will"))
	speed_value.text = str(data.get("speed"))
	reaction_speed.text = str(data.get("reaction"))
