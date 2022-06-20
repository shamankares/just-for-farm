extends Node

signal plant_grew()

export (String) var plant_name
var plant_phase : int = 0
var plant_position : Vector3	# posisi lokal pada tanah
var phase_1_countdown : int = 1
var phase_2_countdown : int = 1
var is_watered : bool = false

func _ready():
	pass # Replace with function body.

func grow():
	match plant_phase:
		0:
			$ToPhase1.start(phase_1_countdown)
		1:
			$ToPhase2.start(phase_2_countdown)

func _on_ToPhase1_timeout():
	self.is_watered = false
	self.plant_phase = 1
	emit_signal("plant_grew", self, plant_position)

func _on_ToPhase2_timeout():
	self.plant_phase = 2
	emit_signal("plant_grew", self, plant_position)

func game_paused():
	pass

func game_resumed():
	pass
