extends VehicleBody3D

@export var MAX_STEER = 0.7
@export var ENGINE_POWER = 1500
var is_on_race = false
var dificulty: int = 0
var min_distance_to_point: int = 0
var poitn_desviation: int = 0


@export var is_player: bool = true
@export var path_to_follow: int = 0
@onready var path_follow = [$"../Path3D/PathFollow_0", $"../Path3D/PathFollow_1", $"../Path3D/PathFollow_2", $"../Path3D/PathFollow_3", $"../Path3D/PathFollow_4", $"../Path3D/PathFollow_5", $"../Path3D/PathFollow_6", $"../Path3D/PathFollow_7"]

var checkpoint_store = []
var all_checkpoints: int
var laps_num: int = 1
var checkpoints_object: Array = []

var distance_to_next_checkpoint: float = 0.0
var point_checkpoint: int = 0

func _ready() -> void:
	all_checkpoints = get_parent().num_checkpoints #esto hay que cambiarlo para el futuro ya que no se podra entrar al loby ni eventos de destruccion
	var brothers = get_parent().get_children()
	for bro in brothers:
		if bro.name == "checkpoints_sistem":
			for point in bro.get_children():
				checkpoints_object.append(point) #obteniendo los checkpoint de toda la pista



func _physics_process(delta: float) -> void:
	if is_player and is_on_race:
		steering = move_toward(steering, Input.get_axis("ui_right", "ui_left") * MAX_STEER, delta * 10)
		engine_force = Input.get_axis("ui_down", "ui_up") * ENGINE_POWER
		
	if get_parent().is_race == true:
		distance_to_next_checkpoint = global_position.distance_to(checkpoints_object[point_checkpoint].global_position)
		print(distance_to_next_checkpoint)


func _on_checkpoint_sensor_area_entered(area: Area3D) -> void:
	if not checkpoint_store.has(area.name):
		checkpoint_store.append(area.name)
		point_checkpoint += 1
	if checkpoint_store.size() == all_checkpoints and area.name == "point_0":
		laps_num += 1
		print(name," lap: ", laps_num)
		checkpoint_store = ["point_0"]
		point_checkpoint = 0
		
		if laps_num >= get_parent().laps_num_to_finish:
			print("FIN DE LA CARRERA")
			is_on_race = false
			engine_force = 0
			steering = 0
			brake = 20
		

func start_race():
	is_on_race = true
	
