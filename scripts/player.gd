extends KinematicBody

export var move_speed : float = 5.0
export var gravity : float = 12.0

var min_look_angle : float = -85.0
var max_look_angle : float = 85.0
var look_sensivity : float = 0.8

var mouse_delta : Vector2 = Vector2()
var velocity : Vector3 = Vector3()

onready var camera = $Pivot/Camera
onready var inventory = $Inventory
onready var animation = $AnimationPlayer

func _ready():
	$Pivot/Camera/RayCast.add_exception(self)

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_delta = event.relative
	if Input.is_action_just_pressed("interact"):
		use_item()

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
	var equip_idx = inventory.equipped_pointer
	if equip_idx != null:
		var item = inventory.item_list[equip_idx]
		item.use()