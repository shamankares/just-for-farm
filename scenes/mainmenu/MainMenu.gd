extends Control

func _ready():
	$BGMusicMenu.set_volume_db(Settings.bg_music_level)
	$SettingsUI.previous_ui = $Main

func _process(_delta):
	$BGMusicMenu.set_volume_db(Settings.bg_music_level)

func _on_Play_pressed():
	get_tree().change_scene("res://scenes/gameplay/Gameplay.tscn")

func _on_Settings_pressed():
	$Main.visible = false
	$SettingsUI.visible = true

func _on_Credits_pressed():
	$Main.visible = false
	$Credits.visible = true

func _on_Exit_pressed():
	get_tree().quit(0)
				
func _on_HowToPlay_pressed():
	$Main.visible = false
	$HowToPlay.visible = true


func _on_Back_pressed():
	$Main.visible = true
	$HowToPlay.visible = false
	$Credits.visible = false
