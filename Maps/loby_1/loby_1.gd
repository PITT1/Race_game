extends Node3D

var num_checkpoints: int = 0

func _ready() -> void:
	var childs = get_children()
	for item in childs:
		if item.get_class() == "VehicleBody3D":
			item.is_on_race = true
