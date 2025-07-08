extends VehicleBody3D

@export var MAX_STEER = 0.7
@export var ENGINE_POWER = 1500
var is_on_race = false

@export_category("BOT")
@export var dificulty : int = 1
@export var path_to_follow: int = 0
@export var min_distance_to_point = 30 
@export var poitn_desviation = 5
@onready var path_follow = [$"../Path3D/PathFollow_0", $"../Path3D/PathFollow_1", $"../Path3D/PathFollow_2", $"../Path3D/PathFollow_3", $"../Path3D/PathFollow_4", $"../Path3D/PathFollow_5", $"../Path3D/PathFollow_6", $"../Path3D/PathFollow_7"]
var random_path
var paths_in_race: Array = []
var speed = 5.0 
var target_progress = 0.0

var checkpoint_store = []
var priority_point_store = []
var all_checkpoints: int
var laps_num: int = 1

#sistema bot para detectar cuando el auto no avanza
@onready var shock_sensor: RayCast3D = $shock_sensor
var recovery_mode: bool = false
@onready var shock_timer_sensor: Timer = $shock_timer_sensor

func _ready() -> void:
	all_checkpoints = get_parent().num_checkpoints #esto hay que cambiarlo para el futuro ya que no se podra entrar al loby ni eventos de destruccion
	for item in get_parent().get_children():
		if item.get_class() == "Path3D":
			paths_in_race.append(item)
	
	set_random_path_follow()

func _physics_process(delta: float) -> void:
	if is_on_race:
		brake = 0
		bot_sistem()
		if linear_velocity.length() < 10 and shock_sensor.collide_with_bodies: #BOT
			var distance = shock_sensor.get_collision_point().distance_to(global_position)
			if distance < 3:
				recovery_mode = true
				shock_timer_sensor.start()
	else:
		brake = 100
	
	if recovery_mode and is_on_race: #BOT
		engine_force = -ENGINE_POWER


func bot_sistem(): #BOT
	var distance_to_point = global_position.distance_to(path_follow[path_to_follow].global_position)
	if distance_to_point < min_distance_to_point:
		path_follow[path_to_follow].progress += min_distance_to_point
		path_follow[path_to_follow].h_offset = randf_range(poitn_desviation, -poitn_desviation)
			
	# Calcular dirección hacia el siguiente puntovar 
	var direction_to_target = path_follow[path_to_follow].global_transform.origin - global_transform.origin
	direction_to_target.y = 0
	direction_to_target = direction_to_target.normalized()
		
		#calculando angulo
	var current_forward = global_transform.basis.z
	var angle_to_target = atan2(direction_to_target.x, direction_to_target.z)
	var current_angle = atan2(current_forward.x, current_forward.z)
		
		# Calcular ángulo relativo al vehículo
	var relative_angle = wrapf(angle_to_target - current_angle, -PI, PI)
		
		#limite al angulo relativo
	relative_angle = clamp(relative_angle, -MAX_STEER, MAX_STEER)
		
		
	steering = relative_angle
		
	if dificulty == 1:
		engine_force = ENGINE_POWER / 1.5
	elif dificulty == 2:
		engine_force = ENGINE_POWER
	elif dificulty == 3:
		engine_force = ENGINE_POWER * 1.1
	

func start_race():
	is_on_race = true


func _on_checkpoint_sensor_area_entered(area: Area3D) -> void:
	if not checkpoint_store.has(area.name) and not area.name.contains("priority"):
		checkpoint_store.append(area.name)
	elif not checkpoint_store.has(area.name) and area.name.contains("priority"):
		if not priority_point_store.has(area.name):
			priority_point_store.append(area.name)
	
	if checkpoint_store.size() == all_checkpoints and area.name == "point_0":
		laps_num += 1
		checkpoint_store = ["point_0"]
	elif priority_point_store.size() == get_parent().priority_points_num and area.name == "point_0" and get_parent().priority_points_num != 0:
		laps_num += 1
		checkpoint_store = ["point_0"]
	elif area.name == "point_0" and priority_point_store.size() == get_parent().priority_points_num:
		if get_parent().priority_points_num != 0:
			laps_num += 1
			checkpoint_store = ["point_0"]
			print("hola")
	
	if laps_num >= get_parent().laps_num_to_finish + 1:
			print("FIN DE LA CARRERA")
			is_on_race = false
			engine_force = 0
			steering = 0
			brake = 20


func _on_shock_timer_sensor_timeout() -> void:
	recovery_mode = false
	shock_timer_sensor.stop()
	print(name, " uso el recovery")
	path_follow[path_to_follow].progress -= min_distance_to_point

func set_random_path_follow():
	random_path = paths_in_race.pick_random()
	path_follow = random_path.get_children()
	
