extends Control

signal item_brought()

onready var item_store = $StoreContainer/GridContainer
var hoe_dis = false
var watering_can_dis = false

func _ready():
	for con in item_store.get_children():
		var button = con.get_child(2)
		button.connect("pressed", self, "brought_item", [button, button.get_name(), button.get_text()])

func save_data():
	var button_status = {
		"hoe_dis" : hoe_dis,
		"watering_can_dis" : watering_can_dis
	}
	return button_status

func load_data(data):
	if data is Dictionary:
		for con in item_store.get_children():
			var button = con.get_child(2)
			match button.get_name():
				"Penyiram":
					button.disabled = data["watering_can_dis"]
					watering_can_dis = data["watering_can_dis"]
					continue
				"Cangkul":
					button.disabled = data["hoe_dis"]
					hoe_dis = data["hoe_dis"]
					continue

func brought_item(button, button_name, price):
	match button_name:
		"Penyiram":
			button.disabled = true
			watering_can_dis = true
			continue
		"Cangkul":
			button.disabled = true
			hoe_dis = true
			continue
		_:
			emit_signal("item_brought", button_name, int(price))
