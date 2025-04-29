extends Resource
## Class that represent actual properties of unit
class_name UnitOnTeam
## Update ProgressBars Hp and Will on battle scene. If prop hp is false, that means will need update
signal update_hp_will(hp_change : bool, value: int) 

var forename : String
var max_hp : int
var hp : int: 
	set(value):
		hp = clamp(value, 0, max_hp)
		emit_signal("update_hp_will", true, value)
var will : int :
	set(value):
		will = clamp(value, 0, 100)
		emit_signal("update_hp_will", false, value)
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
var initial_status : Array[StatusEffect]
var animation_trans : Tween.TransitionType
var animation_ease : Tween.EaseType
var duration : int = 1
var distance : int
var enemy_move_to : UnitProp.EnemyTarget

