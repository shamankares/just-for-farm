class_name Item

extends RigidBody

export (String) var item_name
var sell_price

onready var mesh = $MeshInstance

func _init(name):
	self.item_name = name
	self.set_name(name)

func _ready():
	var item = load("res://proto/item/%s" % item_name)
	mesh.set_mesh(item.item_mesh)
	sell_price = item.sell_price

func sell_item():
	emit_signal("body_entered", self, sell_price)
