extends Resource
## Resource that storage initial information about every unit on game. 
class_name UnitProp

enum EnemyTarget {Close, Far, LowHp, HighHp, LowWill, HighWill, King, Random}
enum ClassUnit {NoClass, Skelet, Lunar, Ghost}

@export_group("In game property")
## Name unit. Need for UI and load character from resourcce
@export var forename : String
## Init and maximum hp 
@export var max_hp : int
## spread of Damage
@export var damage : Vector2i
## Resist from physical damage skill and status effect 
@export var resist_phys_dmg : int
## Resist from magical damage skill and status effect 
@export var resist_mag_dmg : int
## Resist from magical will effected skill and status effect 
@export var resist_will : int
## Count of move points at the begin turn
@export var speed : int
## Place in queue of turns
@export var reaction : int
## Can move after skill cast
@export var move_after_skill : bool = false
## Can move through some obstacle
@export var free_move : bool = true
## Skill have unit
@export var skills : Array[Skill]
@export_group("Other info")
## Poster of character 
@export var icon : Texture2D
## Mini icon character
@export var icon_minimap : Texture2D
## Class of unit 
@export var class_unit : Array[ClassUnit]
## Price on the evolution tree, reward for kill enemy and generate level compute 
@export var cost : int
## Debuff ot buff implement to unit if he has low will on fight
@export var status_effect_low_will : StatusEffect
@export_group("Move")
@export var animation_trans : Tween.TransitionType
@export var animation_ease : Tween.EaseType
## Duration move from one cell to next
@export var duration : int = 1
@export_group("Enemy")
## Target if unit enemy
@export var enemy_move_to : EnemyTarget
## Maximum distance to target unit
@export var distance : int
