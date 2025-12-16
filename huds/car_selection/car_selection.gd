extends Node3D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var pCam: PhantomCamera3D = $PhantomCamera3D
@onready var car_name_label: Label = $CanvasLayer/car_name_label
@onready var car_num: Label = $CanvasLayer/car_num
@onready var select_btn: Button = $CanvasLayer/select
@onready var money_display: HBoxContainer = $CanvasLayer/MoneyDisplay

@onready var pop_sound: AudioStreamPlayer = $pop_sound
@onready var reject_sound: AudioStreamPlayer = $reject_sound

var car_list: Array = []
var car_list_global: Dictionary = {}
var selector: int = 0
var cars_unloke_data: Dictionary = {}

var global_var = load("res://global_var.gd").new()

func _ready() -> void:
	anim.play("rotate")
	car_list.append($vehicles/bugrod)
	car_list.append($vehicles/hotrod1)
	car_list.append($vehicles/sentinel_gt)
	car_list.append($vehicles/empaler_truck)
	car_list.append($vehicles/raven_356)
	car_list.append($vehicles/racing_rod)
	car_list.append($vehicles/blade_rod)
	car_list.append($vehicles/thunderbolt)
	car_list.append($vehicles/pinkinator)
	car_list.append($vehicles/f1_70s)
	car_list.append($vehicles/montana)
	car_list.append($vehicles/monster)
	car_list.append($vehicles/z40)
	car_list.append($vehicles/toreto)
	car_list.append($vehicles/nomad)
	car_list.append($vehicles/coutach)
	car_list.append($vehicles/p_917k)
	car_list.append($vehicles/spyder)
	car_list.append($vehicles/vision_gt)
	car_list.append($vehicles/mcallen)
	car_list.append($vehicles/butti)
	car_list.append($vehicles/revolut)
	
	car_name_label.text = car_list[0].name
	car_num.text = str(0) + "/" + str(car_list.size() - 1)
	
	car_list_global = global_var.car_list
	
	var cars_data_saved = JSON.parse_string(global_var.load_data())
	cars_unloke_data = cars_data_saved["cars_data"]
	
	Ads._on_load_pressed_rewarded_ad()
	
	
func _on_left_button_up() -> void:
	pop_sound.play()
	if selector > 0:
		selector -= 1
	pCam.follow_target = car_list[selector]
	pCam.look_at_target = car_list[selector]
	pCam.follow_offset = Vector3(0, 1.455, 4.175)
	if pCam.follow_target.name == "empaler_truck":
		pCam.follow_offset = Vector3(0, 1.455, 6)
	
	car_name_label.text = car_list[selector].name
	car_num.text = str(selector) + "/" + str(car_list.size() - 1)
	
	
	if cars_unloke_data[car_list[selector].name] == false:
		select_btn.text = tr("id_16") + " $" + str(car_list_global[car_list[selector].name][1])
	else:
		select_btn.set_text("id_17") 

func _on_right_button_up() -> void:
	pop_sound.play()
	if selector + 1 < car_list.size():
		selector += 1
	pCam.follow_target = car_list[selector]
	pCam.look_at_target = car_list[selector]
	pCam.follow_offset = Vector3(0, 1.455, 4.175)
	if pCam.follow_target.name == "empaler_truck":
		pCam.follow_offset = Vector3(0, 1.455, 6)
	
	car_name_label.text = car_list[selector].name
	car_num.text = str(selector) + "/" + str(car_list.size() - 1)
	
	
	if cars_unloke_data[car_list[selector].name] == false:
		select_btn.text = tr("id_16") + " $" + str(car_list_global[car_list[selector].name][1])
	else:
		select_btn.set_text("id_17") 


func _on_go_back_button_up() -> void:
	pop_sound.play()
	get_tree().change_scene_to_file("res://Maps/loby_1/loby_1.tscn")


func _on_select_button_up() -> void:
	var data = JSON.parse_string(global_var.load_data())
	if select_btn.text.contains(tr("id_16")):
		if data.money >= car_list_global[car_list[selector].name][1]: #si el dinero del jugador es mayor o igual al costo del vehiculo
			data.money -= car_list_global[car_list[selector].name][1]
			select_btn.text = "id_17"
			cars_unloke_data[car_list[selector].name] = true
			data.cars_data = cars_unloke_data
			global_var.save_data(JSON.stringify(data))
			Ads._on_show_pressed_rewarded_ad()
			Ads._on_load_pressed_rewarded_ad()
		else:
			print("no puedes comprarlo")
			reject_sound.play()
	else:
		data.car = car_list[selector].name
		global_var.save_data(JSON.stringify(data))
	money_display.reset_money()
