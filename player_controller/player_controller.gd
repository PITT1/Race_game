extends VehicleBody3D
@onready var engine_sound: AudioStreamPlayer3D = $engine_sound

@export var MAX_STEER = 0.7
@export var ENGINE_POWER = 1500
@export var ENGINE_POWER_REDUCTOR: int = 800
@export var stering_asiste_on: bool = true 
var is_on_race = false
var dificulty: int = 0
var min_distance_to_point: int = 0
var poitn_desviation: int = 0
@onready var pCam: PhantomCamera3D = null

@export_category("CAMERA")
@export var camera_distance: float = 8
@export var camera_height: float = 3
var target_offset = Vector2.ZERO
var current_offset = Vector2.ZERO
var wheels: Array = []
var surface: String = ""
var is_on_pista: bool = true


@export var is_player: bool = true
@export var path_to_follow: int = 0
@onready var path_follow = [$"../Path3D/PathFollow_0", $"../Path3D/PathFollow_1", $"../Path3D/PathFollow_2", $"../Path3D/PathFollow_3", $"../Path3D/PathFollow_4", $"../Path3D/PathFollow_5", $"../Path3D/PathFollow_6", $"../Path3D/PathFollow_7"]

var checkpoint_store = []
var last_checkpoint
var priority_point_store = []
var all_checkpoints: int
var laps_num: int = 1
var position_from_hud: int = 0
var vel: int = 0

var previous: int = -1

func _ready() -> void:
	gravity_scale = 4
	all_checkpoints = get_parent().num_checkpoints 
	var siblings = get_parent().get_children()
	for item in siblings:
		if item.name == "PhantomCamera3D":
			pCam = item
	
	var childs = get_children()
	for item in childs:
		if item.get_class() == "VehicleWheel3D":
			wheels.append(item)
	
	engine_sound.play()

func _physics_process(delta: float) -> void:
	stering_asist()
	if is_player and is_on_race:
		brake = 0
		steering = move_toward(steering, Input.get_axis("ui_right", "ui_left") * MAX_STEER, delta * 10)
		if is_on_pista:
			engine_force = Input.get_axis("ui_down", "ui_up") * ENGINE_POWER
		else:
			engine_force = Input.get_axis("ui_down", "ui_up") * ENGINE_POWER_REDUCTOR
	else:
		brake = 20
	update_pcam()
	
	traction_by_terrain_control()
	
	engine_sound_controller()
	

func _on_checkpoint_sensor_area_entered(area: Area3D) -> void:
	last_checkpoint = area
	var num = area.name.split("_")[1]
	if num != "point" and num != "0":
		var numInt = int(num)
		if numInt >= previous:
			previous = numInt
		else:
			print("direccion erronea")
			previous = numInt
		
	if not checkpoint_store.has(area.name) and not area.name.contains("priority"):
		checkpoint_store.append(area.name)
	elif not checkpoint_store.has(area.name) and area.name.contains("priority"):
		if not priority_point_store.has(area.name):
			priority_point_store.append(area.name)
	
	if checkpoint_store.size() == all_checkpoints and area.name == "point_0":
		laps_num += 1
		checkpoint_store = ["point_0"]
		priority_point_store.clear()
	elif priority_point_store.size() == get_parent().priority_points_num and area.name == "point_0" and get_parent().priority_points_num != 0:
		laps_num += 1
		checkpoint_store = ["point_0"]
		priority_point_store.clear()
	elif area.name == "point_0" and priority_point_store.size() == get_parent().priority_points_num:
		if get_parent().priority_points_num != 0:
			laps_num += 1
			checkpoint_store = ["point_0"]
			priority_point_store.clear()
	
	if laps_num >= get_parent().laps_num_to_finish + 1:
			print("FIN DE LA CARRERA")
			get_parent().race_result = position_from_hud
			get_parent().player_is_finish = true
			is_on_race = false
			engine_force = 0
			steering = 0
			brake = 20

func start_race():
	is_on_race = true

func update_pcam():
	var forward_direction = -global_transform.basis.z.normalized()
	target_offset = Vector2(forward_direction.x * camera_distance, forward_direction.z * camera_distance)
	current_offset = current_offset.lerp(target_offset, 0.02)
	pCam.follow_offset = Vector3(current_offset.x, camera_height, current_offset.y)


func stering_asist():
	if stering_asiste_on:
		vel = int(linear_velocity.length())
		if vel < 10:
			MAX_STEER = 0.7
		elif vel < 20:
			MAX_STEER = 0.6
		elif vel < 25:
			MAX_STEER = 0.5
		elif vel < 30:
			MAX_STEER = 0.4
		elif vel < 35:
			MAX_STEER = 0.3
		elif vel < 40:
			MAX_STEER = 0.2


func traction_by_terrain_control():
	for wheel in wheels:
		surface = str(wheel.get_contact_body())
		if surface.contains("pista"):
			is_on_pista = true
		elif surface.contains("terrain"):
			is_on_pista = false
		

func call_lakitu():
	if last_checkpoint:
		set_global_position(last_checkpoint.get_global_position() + Vector3(0, 5, 0))
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
		rotation = last_checkpoint.rotation
	else:
		for item in get_parent().get_children():
			if item.name == "checkpoints_sistem":
				last_checkpoint = item.get_child(0)
		set_global_position(last_checkpoint.get_global_position() + Vector3(0, 5, 0))
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
		rotation = last_checkpoint.rotation

func engine_sound_controller():
	var speed = linear_velocity.length()
	var normalized_speed = clamp(speed, 0, 80)
	engine_sound.pitch_scale = 0.0125 * normalized_speed + 0.4
	
