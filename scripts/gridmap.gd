extends GridMap

func _ready():
	pass # Replace with function body.

func get_item(global_position):
	var loc_pos = world_to_map(global_position)
	print(loc_pos)
	print(get_cell_item(loc_pos.x, loc_pos.y, loc_pos.z))
