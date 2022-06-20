extends RayCast

signal ground_clicked(global_position)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("left_click") and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var glo_pos = get_collision_point()
		emit_signal("ground_clicked", glo_pos)

func is_tanah():
	var grid = get_node("/root/Gameplay/World/Tanah")
	var glo_pos = get_collision_point()
	var loc_pos = grid.world_to_map(glo_pos)
	var idx_tanah = grid.get_cell_item(loc_pos.x, loc_pos.y, loc_pos.z)
	
	if idx_tanah == grid.daftar_tanaman["tanah"]:
		return true
	else:
		return false
