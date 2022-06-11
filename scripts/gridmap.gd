extends GridMap

func _ready():
	pass # Replace with function body.

func get_item(global_position):
	var loc_pos = world_to_map(global_position)
	var idx_tanah = get_cell_item(loc_pos.x, loc_pos.y, loc_pos.z)
	print(loc_pos)	###debug
	print(idx_tanah)	###debug
	if idx_tanah == 1:
		set_cell_item(loc_pos.x, loc_pos.y, loc_pos.z, 0)
	elif idx_tanah == 0:
		set_cell_item(loc_pos.x, loc_pos.y, loc_pos.z, 1)
