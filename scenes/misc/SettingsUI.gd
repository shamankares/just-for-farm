extends Control

var previous_ui
onready var move_speed_slider = $ColorRect/VBoxContainer/PlayerMoveSpeed/HSlider
onready var mouse_sensivity = $ColorRect/VBoxContainer/MouseSensivity/HSlider2
onready var bg_music_slider = $ColorRect/VBoxContainer/BGLevel/HSlider2
onready var sfx_slider = $ColorRect/VBoxContainer/SfxLevel/HSlider2

func _ready():
	move_speed_slider.value = Settings.current_config["player_move_speed"]
	mouse_sensivity.value = Settings.current_config["mouse_sensivity"]
	bg_music_slider.value = Settings.current_config["bg_music_level"]
	sfx_slider.value = Settings.current_config["sfx_level"]

func _on_move_speed_changed(value):
	Settings.current_config["player_move_speed"] = value

func _on_mouse_settings_changed(value):
	Settings.current_config["mouse_sensivity"] = value

func _on_bg_music_value_changed(value):
	Settings.current_config["bg_music_level"] = value

func _on_sfx_level_value_changed(value):
	Settings.current_config["sfx_level"] = value

func _on_Back_pressed():
	Settings.save_config()
	previous_ui.visible = true
	self.visible = false
