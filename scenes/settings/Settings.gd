extends Node

var current_config = {
	"player_move_speed" : 5.0,
	"mouse_sensivity" : 30.0,
	"bg_music_level" : -5.0,
	"sfx_level" : 0.0
}
var config = ConfigFile.new()
#var loaded = false

func _init():
	var err = config.load("user://settings.cfg")
	if err == OK: # Ada file
		print("File settings.cfg is found.")
		var settings_sec = config.get_section_keys("settings")
		if settings_sec:
			for con in current_config:
				current_config[con] = config.get_value("settings", con)
	else: # Tidak ada file
		print("File settings.cfg is NOT found. Creating setting.cfg...")
		for con in current_config:
			config.set_value("settings", con, current_config[con])
		save_config()

func _ready():
#	if loaded:
#		OS.alert("The game is still running. Close the game and try again.", "The game is already loaded")
#		get_tree().notification(NOTIFICATION_WM_QUIT_REQUEST)
#	else:
#		loaded = true
	pass

#func _notification(what):
#	match what:
#		NOTIFICATION_WM_QUIT_REQUEST:
#			call_deferred("free")

func save_config():
	for con in current_config:
			config.set_value("settings", con, current_config[con])
	config.save("user://settings.cfg")
	print("Config saved.")

func add_to_config(section, key, value):
	config.set_value(section, key, value)
	config.save("user://settings.cfg")

func read_config_partial(section, key):
	return config.get_value(section, key)
