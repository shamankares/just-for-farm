extends RigidBody

export (String) var item_name
var sell_price

onready var mesh = $MeshInstance

func _init():
	var item = ItemResLoader.get_item(item_name)
	mesh.set_mesh(item.item_mesh)
	sell_price = item.sell_price

func _ready():
	pass

func sell_item():
	pass
