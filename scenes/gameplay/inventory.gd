class_name Inventory
extends Node

signal item_equipped(item, idx)
signal inventory_changed(inv)
signal msg_inv_error(msg)

const MAX_STACK = 99
const slot : int = 10
var equipped_pointer = null
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

func check_free_slot():
	for item in item_list:
		if item["item_res"] == null:
			return true
	
	return false

func get_equipped_item():
	if equipped_pointer != null and equipped_pointer < item_list.size():
		return item_list[equipped_pointer]["item_res"]
	else:
		return null

func add_to_inventory(item, quantity):
	var stack_pointer = _get_free_slot()
	if stack_pointer == null:
		emit_signal("msg_inv_error", "INVENTORY_FULL")
		return false
	else:
		var added_item = item.instance()
		item_list[stack_pointer] = {
			"item_name": added_item.item_name,
			"item_res" : added_item,
			"item_icon" : added_item.item_icon,
			"stack" : quantity
		}
		return true

func add_existed_item(item_name, quantity):
	if quantity <= 0:
		emit_signal("msg_inv_error", "INVALID_QUANTITY")
		return false
	
	var success
	var item = ItemResLoader.get_item(item_name)
	var idx = _get_item_free_stack_id(item_name)
	if idx != null:
		while MAX_STACK > item_list[idx]["stack"]:
			item_list[idx]["stack"] += 1
			quantity -=1
			if quantity == 0:
				success = true
				break

		if quantity > 0:
			success = add_to_inventory(item, quantity)
	else:
		success = add_to_inventory(item, quantity)
	
	if success:
		emit_signal("inventory_changed", self)
	return success
	#print("inventory.gd: ", item_list)	###debug
	#print(item_list[0]["item_res"].item_name)	###debug

func remove_item():
	item_list[equipped_pointer] = {
		"item_name": null,
		"item_res" : null,
		"item_icon" : null,
		"stack" : 0
	}
	unequip_item()

func throw_item():
	if equipped_pointer == null:
		return
	else:
		item_list[equipped_pointer]["stack"] -= 1
		if item_list[equipped_pointer]["stack"] == 0:
			remove_item()
		call_deferred("emit_signal", "inventory_changed", self)
	#print("inventory.gd: ", item_list)	###debug

func swap_equipped_item(direction):
	if equipped_pointer == null:
		equipped_pointer = 0
		equip_item(equipped_pointer)
		#print("Equipped pointer:", _equipped_pointer)	###debug
		return
	if direction < 0:
		if equipped_pointer == 0:
			equipped_pointer = item_list.size() - 1
		else:
			equipped_pointer -= 1
	elif direction > 0:
		if equipped_pointer < item_list.size() - 1:
			equipped_pointer += 1 
		else:
			equipped_pointer = 0
	#print("Equipped pointer:", _equipped_pointer)	###debug
	equip_item(equipped_pointer)

func equip_item(idx):
	var item = item_list[idx]["item_res"]
	emit_signal("item_equipped", item, idx)
	emit_signal("inventory_changed", self)

func unequip_item():
	equipped_pointer = null
	var item = null
	emit_signal("item_equipped", item, null)
	emit_signal("inventory_changed", self)
	#print("Equipped: ", _equipped_pointer)	###debug

func _get_free_slot():
	for i in item_list:
		if i["item_res"] == null:
			return item_list.find(i)
	
	return null

func _get_item_free_stack_id(item_name):
	for i in item_list:
		if i["item_name"] == item_name and i["stack"] < MAX_STACK:
			return item_list.find(i)
	
	return null
