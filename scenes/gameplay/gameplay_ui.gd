extends Control

onready var inventory_ui = $Inventory/InventoryContainer
onready var message_label = $Message
var empty_slot_tex = preload("res://assets/model/texture/empty_slot.tres")

func _ready():
	pass

func _on_inventory_changed(inv):
	var idx = 0
	for i in inv.item_list:
		var slot = inventory_ui.get_child(idx)
		
		if idx == inv.equipped_pointer:
			slot.get_node("Focus").visible = true
		else:
			slot.get_node("Focus").visible = false
		
		if i["item_res"]:
			var icon = i["item_icon"]
			var stack = i["stack"]
			
			slot.set_texture(icon)
			slot.get_node("Label").set_text(str(stack))
		else:
			slot.set_texture(empty_slot_tex)
			slot.get_node("Label").set_text("0")
		
		idx += 1

func _highlight_equipped(_item, idx):
	inventory_ui.get_child(idx)
	pass

func _show_msg(desc):
	match desc:
		"INVENTORY_FULL":
			message_label.text = "The inventory is full."
		"INVALID_QUANTITY":
			message_label.text = "The amount of quantity is invalid."
		"NO_ENOUGH_MONEY":
			message_label.text = "No enough money."
		_:
			message_label.text = "Wait, how did you can print this?"
	yield(get_tree().create_timer(1.5), "timeout")
	message_label.text = ""
	pass
