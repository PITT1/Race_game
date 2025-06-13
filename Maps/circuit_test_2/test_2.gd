extends Node3D

var car_list = []
var num_checkpoints = 23 #cambiar esta variable cada que cambie el numero de check points en el circuito 


func _ready() -> void:
	for i in get_child_count():
		if get_child(i).get_class() == "VehicleBody3D":
			car_list.append(get_child(i))
