extends Node3D

var num_checkpoints: int = 0

var global_var = load("res://global_var.gd").new()
var car_selected = ""

func _ready() -> void:
	var data = JSON.parse_string(global_var.load_data())
	car_selected = data.car
	print(car_selected)
	
	var childs = get_children()
	for item in childs:
		if item.get_class() == "VehicleBody3D":
			item.is_on_race = true
