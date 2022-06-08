extends RayCast

signal ground_clicked(global_position)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("left_click") and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var glo_pos = get_collision_point()
		emit_signal("ground_clicked", glo_pos)
