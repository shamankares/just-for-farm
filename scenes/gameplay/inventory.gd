class_name Inventory
extends Node

signal item_equipped(item, idx)
signal inventory_changed(inv)
signal msg_inv_error(msg)

const MAX_STACK = 99
const slot : int = 10
var _equipped_pointer = null
var item_list : Array

func _init():
	var item_details = {
		"item_name": null,
		"item_res" : null,
		"item_icon" : null,
		"stack" : 0
	}
	
	for i in range(slot):
		item_list.append(item_details)
#	emit_signal("inventory_changed", self)

func _ready():
	print("inventory.gd: ", item_list)	###debug
	print(item_list.size())	###debug

func get_equipped_item():
	if _equipped_pointer != null and _equipped_pointer < item_list.size():
		return item_list[_equipped_pointer]["item_res"]
	else:
		return null

func add_to_inventory(item, quantity):
	var stack_pointer = _get_free_slot()
	if stack_pointer == null:
		emit_signal("msg_inv_error", "INVENTORY_FULL")
#		return false
	else:
		var added_item = item.instance()
		item_list[stack_pointer] = {
			"item_name": added_item.item_name,
			"item_res" : added_item,
			"item_icon" : added_item.item_icon,
			"stack" : quantity
		}
#	return true

func add_existed_item(item_name, quantity):
	if quantity <= 0:
		emit_signal("msg_inv_error", "INVALID_QUANTITY")
		return false
	
	var item = ItemResLoader.get_item(item_name)
	var idx = _get_item_idx(item_name)
	if idx != null:
		var total_item_added = MAX_STACK - item_list[idx]["stack"]
		var quantity_left = quantity - total_item_added
		item_list[idx]["stack"] += total_item_added
		if quantity_left > 0:
			add_to_inventory(item, quantity_left)
	else:
		add_to_inventory(item, quantity)
	
	emit_signal("inventory_changed", self)
	#print("inventory.gd: ", item_list)	###debug
	#print(item_list[0]["item_res"].item_name)	###debug

func remove_item():
	item_list[_equipped_pointer] = {
		"item_res" : null,
		"stack" : 0
	}
	unequip_item()

func throw_item():
	if _equipped_pointer == null:
		return
	else:
		item_list[_equipped_pointer]["stack"] -= 1
		if item_list[_equipped_pointer]["stack"] == 0:
			remove_item()
		emit_signal("inventory_changed", self)
	#print("inventory.gd: ", item_list)	###debug

func swap_equipped_item(direction):
	if _equipped_pointer == null:
		_equipped_pointer = 0
		equip_item(_equipped_pointer)
		#print("Equipped pointer:", _equipped_pointer)	###debug
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
	#print("Equipped pointer:", _equipped_pointer)	###debug
	equip_item(_equipped_pointer)

func equip_item(idx):
	var item = item_list[idx]["item_res"]
	emit_signal("item_equipped", item, idx)

func unequip_item():
	#_equipped_pointer = null
	var item = null
	emit_signal("item_equipped", item, null)
	#print("Equipped: ", _equipped_pointer)	###debug

func _get_free_slot():
	for i in item_list:
		if i["item_res"] == null:
			return item_list.find(i)
	
	return null

func _get_item_idx(item_name):
	for i in item_list:
		if i["item_name"] == item_name:
			return item_list.find(i)
	
	return null
