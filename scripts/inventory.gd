class_name Inventory
extends Node

signal item_equipped(item)
signal inventory_changed
signal inventory_full

const slot : int = 10
var stack_pointer : int = 0
var equipped_pointer = 0
var item_list : Array

func _init():
	pass
#	var item_details = {
#		item_res = null,
#		stack = 0
#	}
#	for i in range(slot):
#		item_list.append(item_details)
#	emit_signal("inventory_changed", self)

func _ready():
	pass

func add_to_inventory(item, quantity):
	if stack_pointer > item_list.size():
		emit_signal("inventory_full")
	else:
		item_list[stack_pointer] = item
		stack_pointer += 1
		emit_signal("inventory_changed", self)

func remove_item(idx):
	
	pass

func swap_equipped_item(direction):
	if direction < 0:
		pass
	elif direction > 0:
		pass

func equip_item(item):
	emit_signal("item_equipped", item)
	pass

func _get_item_idx(item):
	for i in item_list:
		if i == item:
			return i.get_index()
	
	return null
