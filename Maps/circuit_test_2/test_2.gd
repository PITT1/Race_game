extends Node3D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var pCam: PhantomCamera3D = $PhantomCamera3D

var car_list = []
var starting_grid: Array = []
var num_checkpoints = 23 #cambiar esta variable cada que cambie el numero de check points en el circuito 
@export var countdown: PackedScene
@export var laps_num_to_finish = 5
@onready var car_spawners: Array = [$spawners/spawn_point_0, $spawners/spawn_point_1, $spawners/spawn_point_2, $spawners/spawn_point_3, $spawners/spawn_point_4, $spawners/spawn_point_5, $spawners/spawn_point_6, $spawners/spawn_point_7]

var global_var = load("res://global_var.gd").new()

func _ready() -> void:
	anim.play("init_race")
	put_cars()
	
	get_cars()
	
	var coutdown_instant = countdown.instantiate()
	await get_tree().create_timer(2).timeout
	add_child(coutdown_instant)
	await get_tree().create_timer(4.2).timeout
	for car in car_list:
		car.start_race()

func get_cars():
	for i in get_child_count():
		if get_child(i).get_class() == "VehicleBody3D":
			car_list.append(get_child(i))
	pCam.follow_target = car_list[-1]
	pCam.look_at_target = car_list[-1]

func put_cars():
	var player = JSON.parse_string(global_var.load_data())
	var bots = global_var.bot_list
	bots.sort()
	var bots_sort = bots
	var bot_adress = bots_sort.values()
	starting_grid.append(global_var.car_list[player.car])
	for i in 5: #car_spawners.size()
		starting_grid.append(bot_adress[i])
	
	starting_grid.pop_back()
	starting_grid.reverse() #autos para la linea de partida + el jugador
	
	#empezando a crear instancias para poner los autos en pista
	for i in starting_grid.size():
		var car_load = load(starting_grid[i])
		var car_instantia = car_load.instantiate()
		add_child(car_instantia)
		car_instantia.set_global_position(car_spawners[i].get_global_position())
		car_instantia.set_rotation(car_spawners[i].get_rotation())
		car_instantia.path_to_follow = i
