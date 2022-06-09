class_name Inventory
extends Node

signal item_equipped(item)
signal inventory_changed(inv)
signal msg_inv_error(msg)

const slot : int = 10
var _equipped_pointer = 0
var item_list : Array

func _init():
	var item_details = {
		"item_res" : null,
		"stack" : 0
	}
	
	for i in range(slot):
		item_list.append(item_details)
	emit_signal("inventory_changed", self)

func _ready():
	print("inventory.gd: ", item_list)	###debug
	print(item_list.size())	###debug

func get_equipped_item():
	if _equipped_pointer != null and _equipped_pointer < item_list.size():
		return item_list[_equipped_pointer]["item_res"]
	else:
		return null

func add_to_inventory(item, quantity):
	if quantity <= 0:
		emit_signal("msg_inv_error", "INVALID_QUANTITY")
		return false
	
	var idx = _get_item_idx(item)
	if idx != null:
		item_list[idx]["stack"] += quantity
	else:
		var stack_pointer = _get_free_slot()
		if stack_pointer == null:
			emit_signal("msg_inv_error", "INVENTORY_FULL")
			return false
		else:
			item_list[stack_pointer] = {
				"item_res" : item,
				"stack" : quantity
			}
	
	emit_signal("inventory_changed", self)
	print("inventory.gd: ", item_list)	###debug
	return true

func remove_item():
	item_list[_equipped_pointer] = {
		"item_res" : null,
		"stack" : 0
	}
	unequip_item()
	emit_signal("inventory_changed", self)

func throw_item():
	if _equipped_pointer == null:
		return
	else:
		if item_list[_equipped_pointer]["stack"] > 0:
			item_list[_equipped_pointer]["stack"] -= 1
			if item_list[_equipped_pointer]["stack"] == 0:
				remove_item()
	print("inventory.gd: ", item_list)	###debug

func swap_equipped_item(direction):
	if _equipped_pointer == null:
		print("Equipped pointer:", _equipped_pointer)	###debug
		return
	if direction < 0:
		if _equipped_pointer == 0:
			_equipped_pointer = item_list.size() - 1
		else:
			_equipped_pointer -= 1
	elif direction > 0:
		if _equipped_pointer < item_list.size() - 1:
			_equipped_pointer += 1 
		else:
			_equipped_pointer = 0
	print("Equipped pointer:", _equipped_pointer)	###debug
	equip_item(_equipped_pointer)

func equip_item(idx):
	var item = item_list[idx]["item_res"]
	emit_signal("item_equipped", item)
	pass

func unequip_item():
	_equipped_pointer = null
	var item = null
	emit_signal("item_equipped", item)
	print("Equipped: ", _equipped_pointer)	###debug

func _get_free_slot():
	for i in item_list:
		if i["item_res"] == null:
			return item_list.find(i)
	
	return null

func _get_item_idx(item):
	for i in item_list:
		if i["item_res"] == item:
			return item_list.find(i)
	
	return null
