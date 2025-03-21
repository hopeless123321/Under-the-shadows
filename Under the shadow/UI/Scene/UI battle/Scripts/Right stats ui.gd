extends GridContainer

@onready var mag_resist_value = $"Mag_resist value"
@onready var phys_resist_value = $"Phys_resist value"
@onready var will_resist_value = $"Will_resist value"
@onready var damage_amp_value = $"Damage amp value"


func _ready() -> void:
	Eventbus.connect('select_char', update)
	
func update(data : Dictionary) -> void: 
	damage_amp_value.text = str(data.get('dmg_amp'))
	mag_resist_value.text = str(data.get("resist_mag_dmg"))
	phys_resist_value.text = str(data.get("resist_phys_dmg"))
	will_resist_value.text = str(data.get("resist_will"))
