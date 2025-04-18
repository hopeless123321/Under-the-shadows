extends Resource
# Resource Class that represent items that have unique effect and unique time applicaton tim e
class_name Relic
# Name relics
enum Rarity {Common, Uncommon, Rare, Unique, Specified}
enum TimeApplication {BeginTurn, EndTurn, BeginBattle, EndBattle, EventSpecified, SkillAffect, ChangeGameGlobalVaruable}
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


