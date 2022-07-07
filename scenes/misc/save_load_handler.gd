extends Node

class_name SaveHandler

signal finished()

var file = "user://save.tres"

func _ready():
	pass

func save_data():
	var saving_data = SaveData.new()
	if is_inside_tree():
		for node in get_tree().get_nodes_in_group("saveable"):
			saving_data.data[node.get_name()] = node.save_data()
		var err = ResourceSaver.save(file, saving_data)
		if err == OK:
			var file_hash = hash_file(file)
			Settings.add_to_config("checksum", "save", file_hash)
			print("Progress is saved successfully.")
		else:
			print("ERROR: Can't save the progress.")
	else:
		print("Can't save file when the game is forced to close.")
	emit_signal("finished")

func load_data():
	var file_handler = File.new()
	
	if file_handler.file_exists(file):
		var save_file = ResourceLoader.load(file)
		print("Save file is found! Loading...")
		if verify_file(file):
			for node in get_tree().get_nodes_in_group("saveable"):
				node.load_data(save_file.data[node.get_name()])
		else:
			print("Save file might be corrupted or no checksum was saved.")
		#save_file.free()
	else:
		print("Save file is not found.")
	emit_signal("finished")

func verify_file(file):
	var file_hash = hash_file(file)
	var saved_hash = Settings.read_config_partial("checksum", "save")
	
	if file_hash == saved_hash:
		return true
	else:
		return false

func hash_file(file):
	var file_handle = File.new()
	var hasher = HashingContext.new()
	
	if not file_handle.file_exists(file):
		return null
	
	return file_handle.get_sha256(file)
