extends RigidBody

signal item_sold(item_name, price)

enum ItemType { EQUIPMENT, SEED, HARVEST }

export (String) var item_name
export (ItemType) var item_type
export (Texture) var item_icon
export (bool) var stackable
export (int) var max_stack = 1
export (int) var sell_price
export (int) var buy_price
export (String) var animation
var has_sfx = get_node_or_null("Sfx")
var holded := true

func _init():
	pass

func _ready():
	connect("item_sold", get_node("/root/Gameplay"), "add_coin")
	if has_sfx:
		$Sfx.set_volume_db(Settings.sfx_level)

func _process(_delta):
	if has_sfx:
		$Sfx.set_volume_db(Settings.sfx_level)

func use_item():
	if $AnimationPlayer and $Sfx:
		$Sfx.play()
		$AnimationPlayer.play(animation)
		yield($AnimationPlayer, "animation_finished")
		$AnimationPlayer.play("RESET")

func throw_item():
	#var ray = get_node("/root/Gameplay/Player/Pivot/Camera/RayCast")
	#var glo_pos = get_global_transform()
	#set_as_toplevel(true)
	#self.global_transform = glo_pos
	#apply_impulse(global_transform.origin, Vector3(0, -1, 0))
	
	pass

func get_seed_name():
	var plant_name = item_name
	plant_name = plant_name.trim_prefix("Pouch ")
	plant_name = plant_name.to_lower()
	return plant_name

func sell_item():
	emit_signal("item_sold", item_name, sell_price)

func get_name():
	return item_name

func get_icon():
	return item_icon
