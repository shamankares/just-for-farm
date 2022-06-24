extends Control

signal game_resumed()
signal game_exited()

onready var settings_menu = $SettingsUI

func _ready():
	settings_menu.previous_ui = $PauseContainer

func _on_Resume_pressed():
	emit_signal("game_resumed")

func _on_Settings_pressed():
	settings_menu.visible = true
	$PauseContainer.visible = false

func _on_BackToMenu_pressed():
	emit_signal("game_exited")
	get_tree().change_scene("res://scenes/mainmenu/MainMenu.tscn")
