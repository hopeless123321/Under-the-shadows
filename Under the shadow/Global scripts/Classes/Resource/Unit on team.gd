extends Resource
## Class that represent actual properties of unit
class_name UnitOnTeam

var forename : String
var max_hp : int
var hp : int: 
	set(value):
		hp = clamp(value, 0, max_hp)
var will : int :
	set(value):
		will = clamp(value, 0, 100)
var damage : Vector2i
var resist_phys_dmg : int
var resist_mag_dmg : int
var resist_will : int
var speed : int
var reaction : int
var move_after_skill : bool = false
var free_move : bool = false
var skills : Array[Skill]
var icon : Texture2D
var icon_minimap : Texture2D
var class_unit : Array[UnitProp.ClassUnit]
var cost : int
var initial_status : Array[Status_effect]
var animation_trans : Tween.TransitionType
var animation_ease : Tween.EaseType
var duration : int = 15
var distance : int
var enemy_move_to : UnitProp.EnemyTarget

