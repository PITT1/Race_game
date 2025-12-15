extends Node3D
@onready var pCam: PhantomCamera3D = $PhantomCamera3D
@onready var main_hud_cam: PhantomCamera3D = $main_hud_cam

var num_checkpoints: int = 0
var laps_num_to_finish = 5
var global_var = load("res://global_var.gd").new()
const LOBY_HUD = preload("res://huds/loby_menus/loby_hud.tscn")
const TACTIL_CONTROL_1 = preload("res://huds/controls_hud/tactil_control_1.tscn")
var is_race = false
var on_play: bool = false
var initialized: bool = false

func _ready() -> void:
	if Ads.admob_init:
		MobileAds.initialize()
		print("inicializando ads")
		Ads.admob_init = false
	
	main_hud_cam.priority_override = true
	global_var.init_save_canvas()
	var data = JSON.parse_string(global_var.load_data())
	var car_name = data.car
	var car_adrees = global_var.car_list[car_name][0]
	
	var car_selected = load(car_adrees)
	var car_instantia = car_selected.instantiate()
	add_child(car_instantia)
	car_instantia.global_position = Vector3(0, 5, 0)
	pCam.follow_target = car_instantia
	pCam.look_at_target = car_instantia
	
	Ads._create_ad_banner()
	
	Options.init_save_options_canvas()
	
	BgMusicManager.set_bg_volume(Options.load_data().music_volume)

func _physics_process(delta: float) -> void:
	if delta:
		pass
	if on_play and not initialized:
		var childs = get_children()
		for item in childs:
			if item.get_class() == "VehicleBody3D":
				item.is_on_race = true
		
		var hud_intantia = LOBY_HUD.instantiate()
		add_child(hud_intantia)
		
		var controls_instantia = TACTIL_CONTROL_1.instantiate()
		add_child(controls_instantia)
		
		initialized = true


func _on_grand_prix_btn_button_up() -> void:
	get_tree().change_scene_to_file("res://huds/grand_prix_hud/grand_prix_hud.tscn")
