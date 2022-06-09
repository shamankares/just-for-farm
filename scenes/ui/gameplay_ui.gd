extends Control

onready var inventory_ui = $InventoryContainer

func _ready():
	pass

func _on_inventory_changed(inv):
	for i in inv.item_list:
		if i["item_res"]:
			var idx = inv.item_list.find(i)
			var icon = i["item_res"].item_icon
			inventory_ui.get_child(idx).set_texture(icon)
		pass

func _highlight_equipped(_item, idx):
	inventory_ui.get_child(idx)
	pass

func _show_msg(desc):
	pass
