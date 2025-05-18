extends VBoxContainer
class_name ShopRelic


@export var sell_item : Relic
var price : int:
	set(value):
		price = clamp(value, 0 , INF)
var discount : bool

@onready var price_label: RichTextLabel = $Price
@onready var item: Button = $Item


func _ready() -> void:
	Eventbus.connect("souls_changed", update_price)
	Eventbus.connect("pressed", buy_item)
	set_param()
	update_price()

func set_param() -> void:
	item.icon = sell_item.icon
	price = sell_item.cost * GlobalInfo.cost_buy_in_shop
	
	if randf() < GlobalInfo.disscount_chance:
		price = price / 2
		discount = true


func update_price() -> void:
	price_label.text = ""
	
	if price <= GlobalInfo.souls:
		price_label.text = str(price)
	else:
		price_label.text = "[color=red] %s [/color]" % [price]
		item.disabled = true
	if discount:
		price_label.text = "[s]%s[/s] " % [price * 2] + price_label.text
		item.disabled = false
	

func buy_item() -> void:
	pass
	
