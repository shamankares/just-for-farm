extends GridMap

signal grid_updated()

var plant_scene = preload("res://scenes/gameplay/Plant.tscn")
var daftar_tanaman = {
	"lapangan" : 0,
	"rumput" : 1,
	"tanah" : 2,
	"seed" : [3, 4],
	"bawang": {
		"1" : [5, 6],
		"2" : 7
	},
	"timun": {
		"1" : [8, 9],
		"2" : 10
	},
	"tomat": {
		"1" : [11, 12],
		"2" : 13
	},
	"jagung": {
		"1" : [14, 15],
		"2" : 16
	},
	"kangkung": {
		"1" : [17, 18],
		"2" : 19
	}
}
var countdown_tanaman = {
	"kangkung": {
		"1" : 1,
		"2" : 2
	},
	"tomat": {
		"1" : 2,
		"2" : 5
	},
	"jagung": {
		"1" : 3,
		"2" : 9
	},
	"timun": {
		"1" : 5,
		"2" : 7
	},
	"bawang": {
		"1" : 1,
		"2" : 1
	}
}

func _ready():
	pass # Replace with function body.

func get_plant_name(glo_position):
	var loc_pos = world_to_map(glo_position)
	for tanaman in get_children():
		if tanaman.plant_position == loc_pos:
			return tanaman.plant_name.capitalize()

func harvest(global_position):
	var loc_pos = world_to_map(global_position)
	var found_plant
	
	for tanaman in get_children():
		if tanaman.plant_position == loc_pos and tanaman.plant_phase == 2:
			found_plant = tanaman
	
	if found_plant:
#		var plant_name = found_plant.plant_name
#
#		plant_name = plant_name.capitalize()
		set_cell_item(loc_pos.x, loc_pos.y, loc_pos.z, daftar_tanaman["tanah"])
		found_plant.queue_free()
#		return plant_name
	else:
		return null

func is_harvestable(glo_pos):
	var loc_pos = world_to_map(glo_pos)
	
	for tanaman in get_children():
		if tanaman.plant_position == loc_pos and tanaman.plant_phase == 2:
			return true
	
	return false

func is_tanah(glo_pos):
	var loc_pos = world_to_map(glo_pos)
	var idx_tanah = get_cell_item(loc_pos.x, loc_pos.y, loc_pos.z)
	
	if idx_tanah == daftar_tanaman["tanah"]:
		return true
	else:
		return false
	pass

func take_act_grid(item_name, glo_pos):
	var loc_pos = world_to_map(glo_pos)
	var idx_tanah = get_cell_item(loc_pos.x, loc_pos.y, loc_pos.z)
	
	match item_name:
		"Cangkul":
			if idx_tanah == daftar_tanaman["rumput"]:
				set_cell_item(loc_pos.x, loc_pos.y, loc_pos.z, daftar_tanaman["tanah"])
			elif idx_tanah == daftar_tanaman["tanah"]:
				set_cell_item(loc_pos.x, loc_pos.y, loc_pos.z, daftar_tanaman["rumput"])
		"Penyiram":
			if not idx_tanah in [daftar_tanaman["rumput"], daftar_tanaman["lapangan"]]:
				for tanaman in get_children():
					if tanaman.plant_position == loc_pos and (not tanaman.is_watered) and (tanaman.plant_phase < 2):
						tanaman.is_watered = true
						if idx_tanah == daftar_tanaman["seed"][0]:
							set_cell_item(loc_pos.x, loc_pos.y, loc_pos.z, daftar_tanaman["seed"][int(tanaman.is_watered)])
							tanaman.grow()
						else:
							var plant_name = tanaman.plant_name
							set_cell_item(loc_pos.x, loc_pos.y, loc_pos.z, daftar_tanaman[plant_name][str(tanaman.plant_phase)][int(tanaman.is_watered)])
							tanaman.grow()
		_:
			set_cell_item(loc_pos.x, loc_pos.y, loc_pos.z, daftar_tanaman["seed"][0])
			spawn_plant(item_name, loc_pos)
	

func spawn_plant(plant, loc):
	var new_plant = plant_scene.instance()
	new_plant.plant_name = plant
	new_plant.plant_position = loc
	new_plant.phase_1_countdown = countdown_tanaman[plant]["1"]
	new_plant.phase_2_countdown = countdown_tanaman[plant]["2"]
#	plants.append({
#		"plant_id": new_plant,
#		"plant_name": plant,
#	})
	add_child(new_plant, true)
	new_plant.connect("plant_grew", self, "update_plant", [], CONNECT_DEFERRED)

#func grow_plant(plant_id):
#	plant_id.grow()

func update_plant(plant_id, location):
	var plant_name = plant_id.plant_name
	var phase = plant_id.plant_phase
	match phase:
		1:
			set_cell_item(location.x, location.y, location.z, daftar_tanaman[plant_name][str(phase)][int(plant_id.is_watered)])
		2:
			set_cell_item(location.x, location.y, location.z, daftar_tanaman[plant_name][str(phase)])

func remove_plant(loc):
	pass
