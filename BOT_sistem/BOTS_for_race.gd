extends VehicleBody3D

@export var MAX_STEER = 0.7
@export var ENGINE_POWER = 1500
var is_on_race = false

@export_category("BOT")
@export var dificulty : int = 1
@export var path_to_follow: int = 0
@export var min_distance_to_point = 30 
@export var poitn_desviation = 5
@onready var path_follow: Array = []
var random_path
var paths_in_race: Array = []
var speed = 5.0 
var target_progress = 0.0

var checkpoint_store: Array = []
var last_checkpoint
var priority_point_store: Array = []
var all_checkpoints: int
var laps_num: int = 1

@onready var engine_sound: AudioStreamPlayer3D = $engine_sound

#sistema bot para detectar cuando el auto no avanza
@onready var shock_sensor: RayCast3D = $shock_sensor
var recovery_mode: bool = false
@onready var shock_timer_sensor: Timer = $shock_timer_sensor

var race_order: Array = []
var bot_position: int = 0
var player_position: int = 0
var sensor_storage: Array = []
var distance_to_sensor: float = 0.0
var next_dist_sensor: int = 0
var checkpoints_to_sen: Array = [] 

var vel_reduction: float = 0.0

#smoke particles
var wheels: Array = []
var drift: float = 1.0
const WHEEL_SMOKE = preload("res://particles/smoke/wheel_smoke.tscn")
var DRIFT_SOUND = preload("res://sounds/drift_sound/drift_sound.ogg")
var drift_sound: AudioStreamPlayer3D = AudioStreamPlayer3D.new()
var smoke_particles: Array = []

func _ready() -> void:
	gravity_scale = 4
	all_checkpoints = get_parent().num_checkpoints #esto hay que cambiarlo para el futuro ya que no se podra entrar al loby ni eventos de destruccion
	for item in get_parent().get_children():
		if item.get_class() == "Path3D":
			paths_in_race.append(item)
			path_follow = item.get_children()
	
	set_random_path_follow()
	engine_sound.play()
	
	var childs = get_children()
	for item in childs:
		if item.get_class() == "VehicleWheel3D" and item.name.containsn("Wheel"):
			wheels.append(item)
			
			#instantia smoke particles
			#var inst_smoke_particles = WHEEL_SMOKE.instantiate()
			#add_child(inst_smoke_particles)
			#inst_smoke_particles.position = item.position
			#smoke_particles.append(inst_smoke_particles)
	
	if get_parent().name != "LobyRework":
		for item in get_parent().get_children():
			if item.name == "checkpoints_sistem":
				for i in item.get_children():
					if not i.name.contains("priority"):
						checkpoints_to_sen.append(i)


func _physics_process(delta: float) -> void:
	if delta:
		pass
	if is_on_race:
		brake = 0
		bot_sistem()
		if linear_velocity.length() < 10 and shock_sensor.collide_with_bodies: #BOT
			var distance = shock_sensor.get_collision_point().distance_to(global_position)
			if distance < 3:
				recovery_mode = true
				shock_timer_sensor.start()
	else:
		brake = 20
	
	if recovery_mode and is_on_race: #BOT
		engine_force = -ENGINE_POWER
	
	engine_sound_controller()
	
	drift_smoke_system()
	
	dist_sensor_sistem()


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
	
	if vel_reduction > 0:
		if linear_velocity.length() > vel_reduction:
			engine_force = -ENGINE_POWER
		else:
			engine_force = ENGINE_POWER
	else:
		if dificulty == 1: #lento
			engine_force = ENGINE_POWER * 0.9
		elif dificulty == 2: #normal
			engine_force = ENGINE_POWER
		elif dificulty == 3: #rapido
			engine_force = ENGINE_POWER * 1.1
	

func start_race():
	is_on_race = true


func _on_checkpoint_sensor_area_entered(area: Area3D) -> void:
	next_dist_sensor = next_dist_sensor + 1
	if next_dist_sensor >= checkpoints_to_sen.size():
		next_dist_sensor = 0
	
	last_checkpoint = area
	if not checkpoint_store.has(area.name) and not area.name.contains("priority"):
		checkpoint_store.append(area.name)
	elif not checkpoint_store.has(area.name) and area.name.contains("priority"):
		if not priority_point_store.has(area.name):
			priority_point_store.append(area.name)
	
	if checkpoint_store.size() == all_checkpoints and area.name == "point_0":
		laps_num += 1
		next_dist_sensor = 1
		checkpoint_store = ["point_0"]
		priority_point_store.clear()
		set_random_path_follow()
	elif priority_point_store.size() == get_parent().priority_points_num and area.name == "point_0" and get_parent().priority_points_num != 0:
		laps_num += 1
		next_dist_sensor = 1
		checkpoint_store = ["point_0"]
		priority_point_store.clear()
		set_random_path_follow()
	elif area.name == "point_0" and priority_point_store.size() == get_parent().priority_points_num:
		if get_parent().priority_points_num != 0:
			laps_num += 1
			next_dist_sensor = 1
			checkpoint_store = ["point_0"]
			priority_point_store.clear()
			set_random_path_follow()
	
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
	if paths_in_race.size() > 1:
		random_path = paths_in_race.pick_random()
		path_follow = random_path.get_children()
		path_follow[path_to_follow].progress = 0

func call_lakitu():
	if last_checkpoint:
		set_global_position(last_checkpoint.get_global_position() + Vector3(0, 5, 0))
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
		rotation = last_checkpoint.rotation
		path_follow[path_to_follow].progress -= min_distance_to_point
	else:
		for item in get_parent().get_children():
			if item.name == "checkpoints_sistem":
				last_checkpoint = item.get_child(0)
		set_global_position(last_checkpoint.get_global_position() + Vector3(0, 5, 0))
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
		rotation = last_checkpoint.rotation

func engine_sound_controller():
	var speed_car = linear_velocity.length()
	var normalized_speed = clamp(speed_car, 0, 150)
	engine_sound.pitch_scale = 0.0125 * normalized_speed + 0.1

func escort_system():
	race_order = get_parent().race_order
	for i in range(race_order.size()):
		if race_order[i].name == name:
			bot_position = i + 1
		
		if not race_order[i].name.contains("Bot"):
			player_position = i + 1
	
	if player_position > bot_position:
		dificulty = 1
	else:
		dificulty = 3


func _on_escort_system_interval_timeout() -> void:
	escort_system()

func drift_smoke_system():
	#drift_smoke_particles
	#for wheel in wheels:
		#drift = wheel.get_skidinfo()
		#if drift < 1.0:
			#for smoke in smoke_particles:
				#smoke.emitting = true
		#else:
			#for smoke in smoke_particles:
				#smoke.emitting = false
	#sonido de derrape
	if drift < 1.0:
		if drift_sound.playing == false:
			drift_sound.play()
	else:
		if drift_sound.playing == true:
			drift_sound.stop()

func dist_sensor_sistem():
	if get_parent().name != "LobyRework":
		distance_to_sensor = global_position.distance_to(checkpoints_to_sen[next_dist_sensor].global_position)
