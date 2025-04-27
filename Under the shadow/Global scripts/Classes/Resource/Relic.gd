extends Resource
## Resource Class that represent items that have unique effect and unique time applicaton tim e
class_name Relic
## Name relics
enum Rarity {Common = 50 , Uncommon = 30, Rare = 15, Unique = 5, Specified = 0}
enum TimeApplication {BeginTurn, BeginTurnAll, EndTurn, BeginBattle, EndBattle, NewRoom, EventSpecified, SkillAffect, ChangeGameGlobalVaruable}
## Name relics
@export var name : String
## Visual represent on UI
@export var icon : Texture2D
## Text reveal when mouse entered to Icon
@export_multiline var text_tooltip : String
## Rarity relics like a reward
@export var rarity : Rarity
## When relics work. De-facto determine to what global signal connect relic
@export var trigger : TimeApplication


func initiation() -> void: 
	match  trigger:
		TimeApplication.BeginTurn:
			pass
		TimeApplication.BeginTurnAll:
			pass
		TimeApplication.EndTurn:
			pass
		TimeApplication.BeginBattle:
			pass
		TimeApplication.EndBattle:
			pass
		TimeApplication.EventSpecified:
			pass
		TimeApplication.SkillAffect:
			pass
		TimeApplication.ChangeGameGlobalVaruable:
			pass
		TimeApplication.NewRoom:
			Eventbus.connect("new_room", execute)
			
func execute() -> void:
	pass
