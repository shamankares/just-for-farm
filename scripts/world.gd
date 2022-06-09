extends Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _init():
	var node_tes = Node.new()
	self.add_child(node_tes)
	node_tes.name = "Hantu"
