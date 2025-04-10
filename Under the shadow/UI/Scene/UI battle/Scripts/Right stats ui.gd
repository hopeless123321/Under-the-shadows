extends GridContainer

@onready var mag_resist_value : Label = $"Mag_resist value"
@onready var phys_resist_value : Label = $"Phys_resist value"
@onready var will_resist_value : Label= $"Will_resist value"
@onready var damage_amp_value : Label = $"Damage amp value"


func _ready() -> void:
	Eventbus.connect('select_char', update)
	
func update(data : Dictionary) -> void: 
	damage_amp_value.text = str(data.get('dmg_amp'))
	mag_resist_value.text = str(data.get("resist_mag_dmg"))
	phys_resist_value.text = str(data.get("resist_phys_dmg"))
	will_resist_value.text = str(data.get("resist_will"))
