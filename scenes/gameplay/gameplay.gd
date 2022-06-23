extends Node

var coin : int = 100
var plant_planted : int = 0
var details_plant_planted = {
	"Bawang": 0,
	"Jagung": 0,
	"Kangkung": 0,
	"Timun": 0,
	"Tomat": 0
}
#var unlocked : Array = []
onready var coin_txt = $Statistic/StatisticContainer/KoinCon/Koin
onready var statistic_harvest = $Statistic/StatisticContainer/GridContainer

func _init():
	pass

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$BGMusic.set_volume_db(Settings.bg_music_level)

	$Player.connect("ground_clicked", $World/Tanah, "take_act_grid", [], CONNECT_DEFERRED)
	$Player/Inventory.connect("inventory_changed", $GameplayUI, "_on_inventory_changed", [], CONNECT_DEFERRED)
	$PauseScreen.connect("game_resumed", self, "_on_game_resumed")
	
	coin_txt.text = str(coin)
	
	$Player/Inventory.add_existed_item("Cangkul", 1)
	$Player/Inventory.add_existed_item("Penyiram", 1)
	$Player/Inventory.add_existed_item("Pouch Bawang", 10)
	$Player/Inventory.add_existed_item("Pouch Kangkung", 10)
	$Player/Inventory.add_existed_item("Pouch Tomat", 10)
	$Player/Inventory.add_existed_item("Pouch Timun", 10)
	$Player/Inventory.add_existed_item("Pouch Jagung", 10)

func _process(_delta):
	$BGMusic.set_volume_db(Settings.bg_music_level)

func _input(event):
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$PauseScreen.visible = true
	elif Input.is_action_pressed("show_statistcs") and (!$PauseScreen.visible):
		if $Statistic.visible:
			$Statistic.visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$Statistic.visible = true
#	if Input.is_action_pressed("left_click") and Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
#		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func add_coin(item_name, amount):
	coin += amount
	coin_txt.text = str(coin)
	details_plant_planted[item_name] += 1
	var item_sale_txt = statistic_harvest.get_node("%sCon/%s" % [item_name, item_name])
	item_sale_txt.text = str(details_plant_planted[item_name])

func _on_game_resumed():
	$PauseScreen.visible = false
#	get_tree().set_pause(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
