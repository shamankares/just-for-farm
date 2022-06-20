extends KinematicBody

signal ground_clicked(item_name, glo_pos)

export var move_speed : float = 5.0
export var gravity : float = 12.0

var min_look_angle : float = -85.0
var max_look_angle : float = 85.0
var look_sensivity : float = 0.8

var mouse_delta : Vector2 = Vector2()
var velocity : Vector3 = Vector3()

var equipped_item

onready var camera = $Pivot/Camera
onready var ray = $Pivot/Camera/RayCast
onready var inventory = $Inventory
onready var animation = $AnimationPlayer
onready var item_pivot = $Pivot/Camera/ItemPosition

func _ready():
	ray.add_exception(self)
	inventory.connect("item_equipped", self, "_on_equipped_item")

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_delta = event.relative
	if Input.is_action_just_pressed("interact"):
		if is_instance_valid(equipped_item):
			use_item()
		else:
			take_item()
	if Input.is_action_just_pressed("focus_foward"):
		inventory.swap_equipped_item(1)
	if Input.is_action_just_pressed("focus_backward"):
		inventory.swap_equipped_item(-1)

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

func use_item():
	var col_point = ray.get_collision_point()
	var obj_col = ray.get_collider()
	var item_name = equipped_item.item_name
	
	match equipped_item.item_type:
		equipped_item.ItemType.EQUIPMENT:
			equipped_item.use_item()
			#emit_signal("ground_clicked", item_name, col_point)
			call_deferred("emit_signal", "ground_clicked", item_name, col_point)
		
		equipped_item.ItemType.SEED:
			if obj_col:
				if obj_col.get_name() == "Bin":
					print("Kena!")
					equipped_item.sell_item()
					inventory.throw_item()
				# Jika kena tanah
				elif obj_col.get_name() == "Tanah":
					if ray.is_tanah():
						var plant_seed_name = equipped_item.get_seed_name()
						emit_signal("ground_clicked", plant_seed_name, col_point)
						inventory.throw_item()
			
		equipped_item.ItemType.HARVEST:
			if obj_col:
				if obj_col.get_name() == "Bin":
					equipped_item.sell_item()
					inventory.throw_item() 	# Simpan state fungsi

func take_item():
	var item_passed = ray.get_collider()
	pass


func _on_equipped_item(item, _idx):
	if is_instance_valid(equipped_item):
		equipped_item.queue_free()
	if item:
		equipped_item = item.duplicate()
		item_pivot.add_child(equipped_item)
