extends KinematicBody

signal ground_clicked(item_name, glo_pos)

var move_speed : float = Settings.current_config["player_move_speed"]
var gravity : float = 12

var min_look_angle : float = -85.0
var max_look_angle : float = 85.0
var look_sensivity : float = Settings.current_config["mouse_sensivity"] / 100

var mouse_delta : Vector2 = Vector2()
var velocity : Vector3 = Vector3()

var equipped_item

onready var camera = $Pivot/Camera
onready var ray = $Pivot/Camera/RayCast
onready var inventory = $Inventory
onready var animation = $AnimationPlayer
onready var item_pivot = $Pivot/Camera/ItemPosition

func _ready():
	#load_data()
	ray.add_exception(self)
	inventory.connect("item_equipped", self, "_on_equipped_item")

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_delta = event.relative
	if event is InputEventMouseButton and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if Input.is_action_pressed("left_click"):
			var obj_col = ray.get_collider()
			var col_point = ray.get_collision_point()
			if is_instance_valid(equipped_item):
				use_item(obj_col, col_point)
			else:
				take_item(obj_col, col_point)

func _unhandled_input(event):
	if event is InputEventKey and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if Input.is_action_just_released("interact"):
			var obj_col = ray.get_collider()
			var col_point = ray.get_collision_point()
			if is_instance_valid(equipped_item):
				use_item(obj_col, col_point)
			else:
				take_item(obj_col, col_point)
		elif Input.is_action_just_released("inv_focus_foward"):
			inventory.call_deferred("swap_equipped_item", 1)
			#inventory.swap_equipped_item(1)
		elif Input.is_action_just_released("inv_focus_backward"):
			inventory.swap_equipped_item(-1)
		elif Input.is_action_just_released("inv_cancel_focus"):
			inventory.unequip_item()

func _process(delta):
	#
	# Atur pergerakan kamera dengan mouse
	#
	camera.rotation_degrees -= Vector3(rad2deg(mouse_delta.y), 0, 0) * look_sensivity * delta
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, min_look_angle, max_look_angle)
	rotation_degrees -= Vector3(0, rad2deg(mouse_delta.x), 0) * look_sensivity * delta
	
	mouse_delta = Vector2()

func _physics_process(delta):
	#
	# Atur pergerakan tokoh
	#
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var movement : Vector3 = Vector3.ZERO
		var front : Vector3 = global_transform.basis.z
		var side : Vector3 = global_transform.basis.x
		
		if Input.is_action_pressed("move_foward"):
			movement.z -= 1
		if Input.is_action_pressed("move_backward"):
			movement.z += 1
		if Input.is_action_pressed("move_left"):
			movement.x -= 1
		if Input.is_action_pressed("move_right"):
			movement.x += 1
		
		if movement != Vector3.ZERO:
			movement = movement.normalized()
			animation.play("walk")
		else:
			animation.stop()
		
		velocity.x = (front * movement.z + side * movement.x).x * move_speed
		velocity.z = (front * movement.z + side * movement.x).z * move_speed
		velocity.y -= gravity * delta
		velocity = move_and_slide(velocity, Vector3.UP)
	
	move_speed = Settings.current_config["player_move_speed"]
	look_sensivity = Settings.current_config["mouse_sensivity"] / 100

func save_data():
	var char_trans = {
		"position" : get_translation(),
		"rotate" : get_rotation(),
		"camera_rotate" : camera.get_rotation()
	}
	return char_trans

func load_data(data):
	if data is Dictionary:
		set_translation(data["position"])
		set_rotation(data["rotate"])
		camera.set_rotation(data["camera_rotate"])

func use_item(obj, obj_col_point):
	var item_name = equipped_item.item_name
	
	match equipped_item.item_type:
		equipped_item.ItemType.EQUIPMENT:
			equipped_item.use_item()
			yield(get_tree().create_timer(1), "timeout")
			emit_signal("ground_clicked", item_name, obj_col_point)
		
		equipped_item.ItemType.SEED:
			if obj:
				if obj.get_name() == "Bin":
					equipped_item.sell_item()
					inventory.throw_item()
				elif obj.get_name() == "Tanah":
					if obj.is_tanah(obj_col_point):
						var plant_seed_name = equipped_item.get_seed_name()
						emit_signal("ground_clicked", plant_seed_name, obj_col_point)
						inventory.throw_item()
			
		equipped_item.ItemType.HARVEST:
			if obj:
				if obj.get_name() == "Bin":
					equipped_item.sell_item()
					inventory.call_deferred("throw_item")
					#inventory.throw_item()

func take_item(obj, obj_col_point):
	if obj:
		if obj.get_name() == "Tanah":
			var harvest_name = obj.get_plant_name(obj_col_point)
			if obj.is_harvestable(obj_col_point) and inventory.add_existed_item(harvest_name, 1):
				obj.harvest(obj_col_point)

func _on_equipped_item(item, _idx):
	if is_instance_valid(equipped_item):
		equipped_item.queue_free()
	if item:
		equipped_item = item.duplicate()
		item_pivot.add_child(equipped_item)
