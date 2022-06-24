extends Control

signal item_brought()

onready var item_store = $StoreContainer/GridContainer

func _ready():
	for con in item_store.get_children():
		var button = con.get_child(2)
		button.connect("pressed", self, "brought_item", [button, button.get_name(), button.get_text()])

func brought_item(button, button_name, price):
	match button_name:
		"Penyiram":
			button.disabled = true
			continue
		"Cangkul":
			button.disabled = true
			continue
		_:
			emit_signal("item_brought", button_name, int(price))
