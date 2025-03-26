extends Resource
class_name Unit_prop

@export_category("In game property")
@export var forename : String
@export var max_hp : int
@export var dmg_amp: int
@export var resist_phys_dmg : int
@export var resist_mag_dmg : int
@export var resist_will : int
@export var speed : int
@export var reaction : int
@export var move_after_skill : bool = false
@export var free_move : bool = true
@export var ability : Array[Base_ability]

@export_category("Other info")
@export var icon_select : Texture2D
@export_flags("No class", "Skelet", "Lunar", "Dead", "Ghost") var type
@export var cost : int
@export var move_curve : Curve

@export_category("Enemy")
@export_enum ("Close", 
			"Far", 
			"Low hp", 
			"High hp", 
			"King", 
			"Low will", 
			"High will", 
			"Random") var move_to : String
@export var distance : int
