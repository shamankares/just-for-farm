extends Node

var coin : int = 100
#var plant_planted : int = 0
var details_plant_planted = {
	"Bawang": 0,
	"Jagung": 0,
	"Kangkung": 0,
	"Timun": 0,
	"Tomat": 0,
	"PouchBawang": 0,
	"PouchJagung": 0,
	"PouchKangkung": 0,
	"PouchTimun": 0,
	"PouchTomat": 0
}
#var unlocked : Array = []

signal show_error(desc)

onready var coin_txt = $Statistic/StatisticContainer/KoinCon/Koin
onready var coin_store = $StoreUI/StoreContainer/KoinCon/Koin
onready var statistic_harvest = $Statistic/StatisticContainer/GridContainer

func _init():
	pass

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	coin_txt.text = str(coin)
	coin_store.text = str(coin)
	$BGMusic.set_volume_db(Settings.current_config["bg_music_level"])
	
	self.connect("show_error", $GameplayUI, "_show_msg")
	$Player.connect("ground_clicked", $World/Tanah, "take_act_grid", [], CONNECT_DEFERRED)
	$Player/Inventory.connect("inventory_changed", $GameplayUI, "_on_inventory_changed", [], CONNECT_DEFERRED)
	$Player/Inventory.connect("msg_inv_error", $GameplayUI, "_show_msg")
	$StoreUI.connect("item_brought", self, "add_item_to_inv")
	$PauseScreen.connect("game_resumed", self, "_on_game_resumed")
	$PauseScreen.connect("game_exited", self, "_on_game_exited")
	
	var loader = SaveHandler.new()
	add_child(loader)
	loader.load_data()
	yield(loader, "finished")
	loader.queue_free()

func _process(_delta):
	$BGMusic.set_volume_db(Settings.current_config["bg_music_level"])

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$PauseScreen.visible = true
	if Input.is_action_just_pressed("show_statistcs") and (!$PauseScreen.visible) and (!$StoreUI.visible):
		if $Statistic.visible:
			$Statistic.visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			$Statistic.visible = true
	if Input.is_action_just_pressed("open_store") and (!$PauseScreen.visible) and (!$Statistic.visible):
		if $StoreUI.visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			$StoreUI.visible = false
		else:
			$StoreUI.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#	if Input.is_action_pressed("left_click") and Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
#		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func save_data():
	var saved_stat = {
		"coin" : coin,
		"plant_selled" : details_plant_planted.duplicate(true)
	}
	return saved_stat

func load_data(data):
	if data is Dictionary:
		coin = data["coin"]
		details_plant_planted = data["plant_selled"].duplicate(true)
		
		coin_txt.text = str(coin)
		coin_store.text = str(coin)
		for item in details_plant_planted:
			var item_sale_txt = statistic_harvest.get_node("%sCon/%s" % [item, item])
			item_sale_txt.text = str(details_plant_planted[item])
		

func add_item_to_inv(item_name, price):
	var temp_val = coin - price
	if temp_val < 0:
		emit_signal("show_error", "NO_ENOUGH_MONEY")
	else:
		item_name = item_name.capitalize()
		if $Player/Inventory.add_existed_item(item_name, 1):
			coin -= price
			coin_txt.text = str(coin)
			coin_store.text = str(coin)

func add_coin(item_name, amount):
	coin += amount
	coin_txt.text = str(coin)
	coin_store.text = str(coin)
	item_name = item_name.replace(" ", "")
	details_plant_planted[item_name] += 1
	var item_sale_txt = statistic_harvest.get_node("%sCon/%s" % [item_name, item_name])
	item_sale_txt.text = str(details_plant_planted[item_name])

func _on_game_resumed():
	$PauseScreen.visible = false
#	get_tree().set_pause(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_game_exited():
	var save_obj = SaveHandler.new()
	call_deferred("add_child", save_obj)
	save_obj.call_deferred("save_data")
	yield(save_obj, "finished")
	
	for i in $Player/Inventory.item_list:
		if is_instance_valid(i["item_res"]):
			i["item_res"].queue_free()
	for node in get_children():
		node.queue_free()
	queue_free()

func _notification(what):
	match what:
		NOTIFICATION_WM_QUIT_REQUEST:
			_on_game_exited()
			get_tree().call_deferred("quit")
