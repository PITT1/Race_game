extends Node3D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var pCam: PhantomCamera3D = $PhantomCamera3D
@onready var car_name_label: Label = $CanvasLayer/car_name_label
@onready var car_num: Label = $CanvasLayer/car_num

var car_list: Array = []
var selector: int = 0

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
	
	car_name_label.text = car_list[0].name
	car_num.text = str(0) + "/" + str(car_list.size() - 1)
	
	
func _on_left_button_up() -> void:
	if selector > 0:
		selector -= 1
	pCam.follow_target = car_list[selector]
	pCam.look_at_target = car_list[selector]
	pCam.follow_offset = Vector3(0, 1.455, 4.175)
	if pCam.follow_target.name == "empaler_truck":
		pCam.follow_offset = Vector3(0, 1.455, 6)
	
	car_name_label.text = car_list[selector].name
	car_num.text = str(selector) + "/" + str(car_list.size() - 1)

func _on_right_button_up() -> void:
	if selector + 1 < car_list.size():
		selector += 1
		pCam.follow_target = car_list[selector]
		pCam.look_at_target = car_list[selector]
		pCam.follow_offset = Vector3(0, 1.455, 4.175)
		if pCam.follow_target.name == "empaler_truck":
			pCam.follow_offset = Vector3(0, 1.455, 6)
		
		car_name_label.text = car_list[selector].name
		car_num.text = str(selector) + "/" + str(car_list.size() - 1)


func _on_go_back_button_up() -> void:
	get_tree().change_scene_to_file("res://Maps/loby_1/loby_1.tscn")


func _on_select_button_up() -> void:
	var data = JSON.parse_string(global_var.load_data())
	data.car = car_list[selector].name
	global_var.save_data(JSON.stringify(data))
