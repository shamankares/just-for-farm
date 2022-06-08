extends Node

var item_list : Array

func _ready():
	#
	# Buka direktori item dan tambahkan ke array ketika beriterasi
	#
	var item_dir = Directory.new()
	var dir_path = "res://proto/item/"
	if item_dir.open(dir_path) == OK:
		item_dir.list_dir_begin(true, true)
		var item_file = item_dir.get_next()
		
		while item_file:
			if not item_dir.current_is_dir():
				item_list.append(load(dir_path + item_file))
			item_file = item_dir.get_next()
		item_dir.list_dir_end()
	else:
		print("Error while opening the directory.")

func get_item(name):
	for item in item_list:
		if item.item_name == name:
			return item

	return null
