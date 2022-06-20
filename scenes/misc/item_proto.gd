class_name ItemResource
extends Resource

enum ItemType { EQUIPMENT, SEED, HARVEST }

export (String) var item_name
export (ItemType) var item_type
export (Mesh) var item_mesh
export (Texture) var item_icon
export (Script) var script_methods
export (bool) var stackable
export (int) var max_stack = 1
export (int) var sell_price
export (int) var buy_price

func _init():
	pass
