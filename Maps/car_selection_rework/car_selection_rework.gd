extends Node3D
var car_list_global: Dictionary

var global_var = load("res://global_var.gd").new()
var car_names: Array = []
@onready var spawner: Marker3D = $spawner

#variables necesarias de escenas de los vehiculos
var laps_to_finish: int
var laps_num_to_finish: int = 0
var num_checkpoints: int = 0
var is_race = false


func _ready() -> void:
	
	car_list_global = global_var.car_list
	car_names = car_list_global.keys()
	print(car_list_global[car_names[0]][0])
	print(name)
	var car: PackedScene = load(car_list_global[car_names[0]][0])
	var car_instantia: VehicleBody3D = car.instantiate()
	car_instantia.position = spawner.position
	car_instantia.rotate_y(2)
	car_instantia.axis_lock_linear_x = true
	add_child(car_instantia)
	car_instantia.steering = 0.5
	
