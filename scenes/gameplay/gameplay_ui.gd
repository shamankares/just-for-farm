extends Control

onready var inventory_ui = $InventoryContainer
var empty_slot_tex = preload("res://assets/model/texture/empty_slot.tres")

func _ready():
	pass

func _on_inventory_changed(inv):
	var idx = 0
	for i in inv.item_list:
		var slot = inventory_ui.get_child(idx)
		
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
	pass
