extends VehicleBody3D

@export var MAX_STEER = 0.7
@export var ENGINE_POWER = 1500
var is_on_race = false
var dificulty: int = 0
var min_distance_to_point: int = 0
var poitn_desviation: int = 0
@onready var pCam: PhantomCamera3D = null

@export_category("CAMERA")
@export var camera_distance: float = 15
@export var camera_height: float = 8
var target_offset = Vector2.ZERO
var current_offset = Vector2.ZERO


@export var is_player: bool = true
@export var path_to_follow: int = 0
@onready var path_follow = [$"../Path3D/PathFollow_0", $"../Path3D/PathFollow_1", $"../Path3D/PathFollow_2", $"../Path3D/PathFollow_3", $"../Path3D/PathFollow_4", $"../Path3D/PathFollow_5", $"../Path3D/PathFollow_6", $"../Path3D/PathFollow_7"]

var checkpoint_store = []
var priority_point_store = []
var all_checkpoints: int
var laps_num: int = 1

var previous: int = -1

func _ready() -> void:
	all_checkpoints = get_parent().num_checkpoints #esto hay que cambiarlo para el futuro ya que no se podra entrar al loby ni eventos de destruccion
	var siblings = get_parent().get_children()
	for item in siblings:
		if item.name == "PhantomCamera3D":
			pCam = item

func _physics_process(delta: float) -> void:
	if is_player and is_on_race:
		brake = 0
		steering = move_toward(steering, Input.get_axis("ui_right", "ui_left") * MAX_STEER, delta * 10)
		engine_force = Input.get_axis("ui_down", "ui_up") * ENGINE_POWER
	else:
		brake = 100
	update_pcam()
	

func _on_checkpoint_sensor_area_entered(area: Area3D) -> void:
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
	elif priority_point_store.size() == get_parent().priority_points_num and area.name == "point_0" and get_parent().priority_points_num != 0:
		laps_num += 1
		checkpoint_store = ["point_0"]
	elif area.name == "point_0" and priority_point_store.size() == get_parent().priority_points_num:
		if get_parent().priority_points_num != 0:
			laps_num += 1
			checkpoint_store = ["point_0"]
	
	if laps_num >= get_parent().laps_num_to_finish + 1:
			print("FIN DE LA CARRERA")
			get_parent().race_result.append(name)
			print(get_parent().race_result)
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
