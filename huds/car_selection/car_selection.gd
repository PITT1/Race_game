extends Node3D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var pCam: PhantomCamera3D = $PhantomCamera3D

var car_list: Array = []
var selector: int = 0

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


func _on_left_button_up() -> void:
	selector -= 1
	pCam.follow_target = car_list[selector]
	pCam.look_at_target = car_list[selector]
	pCam.follow_offset = Vector3(0, 1.455, 4.175)
	if pCam.follow_target.name == "empaler_truck":
		pCam.follow_offset = Vector3(0, 1.455, 6)

func _on_right_button_up() -> void:
	selector += 1
	pCam.follow_target = car_list[selector]
	pCam.look_at_target = car_list[selector]
	pCam.follow_offset = Vector3(0, 1.455, 4.175)
	if pCam.follow_target.name == "empaler_truck":
		pCam.follow_offset = Vector3(0, 1.455, 6)
