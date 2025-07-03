extends Node3D
@onready var pCam: PhantomCamera3D = $PhantomCamera3D

var num_checkpoints: int = 0
var global_var = load("res://global_var.gd").new()
var is_race = false

func _ready() -> void:
	var data = JSON.parse_string(global_var.load_data())
	var car_name = data.car
	var car_adrees = global_var.car_list[car_name]
	
	var car_selected = load(car_adrees)
	var car_instantia = car_selected.instantiate()
	add_child(car_instantia)
	car_instantia.global_position = Vector3(0, 5, 0)
	pCam.follow_target = car_instantia
	pCam.look_at_target = car_instantia
	
	var childs = get_children()
	for item in childs:
		if item.get_class() == "VehicleBody3D":
			item.is_on_race = true
