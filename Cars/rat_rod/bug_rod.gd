extends VehicleBody3D

@export var MAX_STEER = 0.7
@export var ENGINE_POWER = 1500
var is_on_race = false

# Sistema BOT
@export var is_player: bool = true
@export_category("BOT")
@export var dificulty : int = 1
@export var path_to_follow: int = 0
@export var min_distance_to_point = 30 
@export var poitn_desviation = 5
@onready var path_follow = [$"../Path3D/PathFollow_0", $"../Path3D/PathFollow_1", $"../Path3D/PathFollow_2", $"../Path3D/PathFollow_3", $"../Path3D/PathFollow_4", $"../Path3D/PathFollow_5", $"../Path3D/PathFollow_6", $"../Path3D/PathFollow_7"]
@onready var path = get_parent().get_child(4)
var speed = 5.0 
var target_progress = 0.0

var checkpoint_store = []
var all_checkpoints: int
var laps_num: int = 1

#sistema bot para detectar cuando el auto no avanza
@onready var shock_sensor: RayCast3D = $shock_sensor
var recovery_mode: bool = false
@onready var shock_timer_sensor: Timer = $shock_timer_sensor

#@export var camera_distance: float = 4
#@export var camera_height: float = 4

#var target_offset = Vector2.ZERO
#var current_offset = Vector2.ZERO

func _ready() -> void:
	all_checkpoints = get_parent().num_checkpoints #esto hay que cambiarlo para el futuro ya que no se podra entrar al loby ni eventos de destruccion
func _physics_process(delta: float) -> void:
	if is_player and is_on_race:
		steering = move_toward(steering, Input.get_axis("ui_right", "ui_left") * MAX_STEER, delta * 10)
		engine_force = Input.get_axis("ui_down", "ui_up") * ENGINE_POWER
		
		
	if not is_player and is_on_race:
		#ESTO LO HACE SOLO EL BOT
		bot_sistem()
		
		if linear_velocity.length() < 10 and shock_sensor.collide_with_bodies and not is_player:
			var distance = shock_sensor.get_collision_point().distance_to(global_position)
			if distance < 3:
				recovery_mode = true
				shock_timer_sensor.start()
		
	if recovery_mode and not is_player and is_on_race:
		engine_force = -ENGINE_POWER
		
		
		

#func update_pcam():
#	var forward_direction = -global_transform.basis.z.normalized()
#	target_offset = Vector2(forward_direction.x * camera_distance, forward_direction.z * camera_distance)
#	current_offset = current_offset.lerp(target_offset, 0.05)
#	var pCam = get_parent().get_child(3) 
#	if pCam.name == "PhantomCamera3D":
#		pCam.follow_offset = Vector3(current_offset.x, camera_height, current_offset.y)
#	else:
#		print("no se encontro phanton camera")


func _on_checkpoint_sensor_area_entered(area: Area3D) -> void:
	if not checkpoint_store.has(area.name):
		checkpoint_store.append(area.name)
	
	if checkpoint_store.size() == all_checkpoints and area.name == "point_0":
		laps_num += 1
		print(name," lap: ", laps_num)
		checkpoint_store = ["point_0"]
		


func _on_shock_timer_sensor_timeout() -> void:
	recovery_mode = false
	shock_timer_sensor.stop()
	print(name, " uso el recovery")
	path_follow[path_to_follow].progress -= min_distance_to_point

func start_race():
	is_on_race = true

func bot_sistem():
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
	
	
