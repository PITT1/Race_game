extends Node3D
@onready var anim: AnimationPlayer = $AnimationPlayer

var car_list = []
var num_checkpoints = 16 #cambiar esta variable cada que cambie el numero de check points en el circuito 
@export var countdown: PackedScene
@export var laps_num_to_finish = 5

func _ready() -> void:
	anim.play("init_race")
	for i in get_child_count():
		if get_child(i).get_class() == "VehicleBody3D":
			car_list.append(get_child(i))
			
	var coutdown_instant = countdown.instantiate()
	await get_tree().create_timer(2).timeout
	add_child(coutdown_instant)
	await get_tree().create_timer(4.2).timeout
	for car in car_list:
		car.start_race()
