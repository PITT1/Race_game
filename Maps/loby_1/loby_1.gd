extends Node3D
@onready var pCam: PhantomCamera3D = $PhantomCamera3D
@onready var main_hud_cam: PhantomCamera3D = $main_hud_cam
@onready var car_spawner: MeshInstance3D = $car_spawner

var num_checkpoints: int = 0
var laps_num_to_finish = 5
var global_var = load("res://global_var.gd").new()
var is_race = false
var on_play: bool = false

func _ready() -> void:
	main_hud_cam.priority_override = true
	global_var.init_save_canvas()
	var data = JSON.parse_string(global_var.load_data())
	var car_name = data.car
	var car_adrees = global_var.car_list[car_name][0]
	
	var car_selected = load(car_adrees)
	var car_instantia : VehicleBody3D = car_selected.instantiate()
	add_child(car_instantia)
	car_instantia.set_global_position(car_spawner.get_global_position())
	car_instantia.set_rotation(car_spawner.get_rotation())
	car_instantia.steering = 0.5
	car_instantia.axis_lock_linear_x = true
	
	Options.init_save_options_canvas()
	
	BgMusicManager.set_bg_volume(Options.load_data().music_volume)
	
	#cargando anuncios
	Ads._load_interstitial_ad()


func _on_grand_prix_btn_button_up() -> void:
	get_tree().change_scene_to_file("res://huds/grand_prix_hud/grand_prix_hud.tscn")
