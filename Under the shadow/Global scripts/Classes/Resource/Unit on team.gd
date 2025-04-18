extends Resource
## Class that represent actual properties of unit on team.
class_name UnitOnTeam

var forename : String
var max_hp : int
var hp : int
var dmg_amp: int
var resist_phys_dmg : int
var resist_mag_dmg : int
var resist_will : int
var speed : int
var reaction : int
var move_after_skill : bool = false
var free_move : bool = true
var skills : Array[Skill]
var icon : Texture2D
var icon_select : Texture2D
var type : Array[String]
var cost : int
var initial_status : Array[Status_effect]
var animation_trans : Tween.TransitionType
var animation_ease : Tween.EaseType
var duration : int = 1
var distance : int
var move_to : Array[String]
