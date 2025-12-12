extends Node3D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var pCam: PhantomCamera3D = $PhantomCamera3D

var car_list = []
var race_order = []
var starting_grid: Array = []
var num_checkpoints
var is_race = true
var player_is_finish = false

@export var reward: int = 3500
@export var countdown: PackedScene
var on_finish_race_hud: PackedScene = preload("res://huds/on_race_huds/on_finish_race_hud.tscn")
var finish_hud_instance
var race_result: int
@export var priority_points_num: int = 0
@export var laps_num_to_finish = 5
@export var vehicle_num: int = 8
@export var min_distance_to_point_BOT: int = 30
@export var poitn_desviation_BOT: int = 5
@export var BOTS_dificulty: int = 2 # 1=facil, 2=normal, 3=dificil
@onready var car_spawners: Array = [$spawners/spawn_point_0, $spawners/spawn_point_1, $spawners/spawn_point_2, $spawners/spawn_point_3, $spawners/spawn_point_4, $spawners/spawn_point_5, $spawners/spawn_point_6, $spawners/spawn_point_7, $spawners/spawn_point_8, $spawners/spawn_point_9, $spawners/spawn_point_10, $spawners/spawn_point_11, $spawners/spawn_point_12]
@onready var checkpoints_sistem: Node3D = $checkpoints_sistem

var global_var = load("res://global_var.gd").new()

func _ready() -> void:
	Ads._on_load_pressed_rewarded_ad()
	num_checkpoints = checkpoints_sistem.get_child_count()
	anim.play("init_race")
	put_cars()
	
	get_cars()
	race_order = car_list
	
	var coutdown_instant = countdown.instantiate()
	await get_tree().create_timer(2).timeout
	add_child(coutdown_instant)
	await get_tree().create_timer(4.2).timeout
	for car in car_list:
		car.start_race()

func _physics_process(delta: float) -> void:
	if delta:
		pass
		
	ordenar_carrera()
	
	if player_is_finish and not finish_hud_instance:
		finish_hud_instance = on_finish_race_hud.instantiate()
		add_child(finish_hud_instance)
		finish_hud_instance.set_finish_result(race_result, reward)
	
func get_cars():
	for i in get_child_count():
		if get_child(i).get_class() == "VehicleBody3D":
			car_list.append(get_child(i))
	pCam.follow_target = car_list[-1]
	pCam.look_at_target = car_list[-1]

func put_cars():
	var player = JSON.parse_string(global_var.load_data())
	var bots: Dictionary = global_var.bot_list
	var bot_adress: Array = bots.values()
	var bots_random: Array
	
	while bots_random.size() <= vehicle_num:
		var pick_random: String = bot_adress.pick_random()
		if not bots_random.has(pick_random):
			bots_random.append(pick_random)
	
	
	starting_grid.append(global_var.car_list[player.car][0])
	for i in vehicle_num: #car_spawners.size() cantidad de carros que apareceran
		starting_grid.append(bots_random[i])
	
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
		car_instantia.dificulty = BOTS_dificulty
		car_instantia.min_distance_to_point = min_distance_to_point_BOT
		car_instantia.poitn_desviation = poitn_desviation_BOT

func ordenar_carrera():
	race_order.sort_custom(Callable(self, "_comparar_posiciones"))

func _comparar_posiciones(a:VehicleBody3D, b:VehicleBody3D):
	if a.laps_num != b.laps_num:
		return a.laps_num > b.laps_num
		
	return a.checkpoint_store.size() > b.checkpoint_store.size()


func _on_abyss_sensor_body_entered(body: Node3D) -> void:
	body.call_lakitu()
