extends Node

var coin : int = 100
var plant_planted : int = 0
#var unlocked : Array = []

func _init():
	pass

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#$Player/Pivot/Camera/RayCast.connect("ground_clicked", $World/Tanah, "get_item")
	$Player.connect("ground_clicked", $World/Tanah, "take_act_grid", [], CONNECT_DEFERRED)
	$Player/Inventory.connect("inventory_changed", $GameplayUI, "_on_inventory_changed", [], CONNECT_DEFERRED)
	
	$Player/Inventory.add_existed_item("Cangkul", 1)
	$Player/Inventory.add_existed_item("Penyiram", 1)
	$Player/Inventory.add_existed_item("Pouch Bawang", 10)
	$Player/Inventory.add_existed_item("Pouch Kangkung", 10)
	$Player/Inventory.add_existed_item("Pouch Tomat", 10)
	$Player/Inventory.add_existed_item("Pouch Timun", 10)
	$Player/Inventory.add_existed_item("Pouch Jagung", 10)

func _input(event):
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_pressed("left_click") and Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func add_coin(amount):
	coin += amount
	print("Coin: ", coin)
