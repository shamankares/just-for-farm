extends Node

var item_list : Array

func _ready():
	#
	# Buka direktori item dan tambahkan ke array ketika beriterasi
	#
	var item_dir = Directory.new()
	var dir_path = "res://assets/item/"
	if item_dir.open(dir_path) == OK:
		item_dir.list_dir_begin(true, true)
		var item_file = item_dir.get_next()
		
		while item_file:
			if (not item_dir.current_is_dir()) and item_file != "Item.gd":
				item_list.append(load(dir_path + item_file))
			item_file = item_dir.get_next()
		item_dir.list_dir_end()
		
		#print(item_list)
	else:
		print("Error while opening the directory.")

func get_item(name):
	for item in item_list:
		var item_data = item.get_state()
		
		for idx in range(item_data.get_node_count()):
			for prop_idx in range(item_data.get_node_property_count(idx)):
				if item_data.get_node_property_name(idx, prop_idx) == "item_name":
					if item_data.get_node_property_value(idx, prop_idx) == name:
						return item

	return null

func get_item_icon(item_id):
	var item_data = item_id.get_state()
	
	for idx in range(item_data.get_node_count()):
		for prop_idx in range(item_data.get_node_property_count(idx)):
			if item_data.get_node_property_name(idx, prop_idx) == "item_icon":
					return item_data.get_node_property_value(idx, prop_idx)

	return null
