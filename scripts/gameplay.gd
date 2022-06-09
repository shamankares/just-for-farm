extends Node

var coin : int = 0
var plant_planted : int = 0
var unlocked : Array = []

func _init():
	#
	# Muatkan file simpanan
	#
	
	pass

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$Player/Pivot/Camera/RayCast.connect("ground_clicked", $World/Tanah, "get_item")
	$Player/Inventory.connect("inventory_changed", $GameplayUI, "_on_inventory_changed")
	
	var dummy = ItemResLoader.get_item("Proto")	###debug
	$Player/Inventory.add_existed_item(dummy, 1)	###debug
	$Player/Inventory.add_existed_item(dummy, 1)	###debug

func _input(event):
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_pressed("left_click") and Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
