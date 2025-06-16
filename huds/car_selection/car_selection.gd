extends Node3D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var pCam: PhantomCamera3D = $PhantomCamera3D

var car_list: Array = []
var selector: int = 0

func _ready() -> void:
	anim.play("rotate")
	car_list.append($vehicles/bugrod)
	car_list.append($vehicles/hotrod1)


func _on_left_button_up() -> void:
	selector -= 1
	pCam.follow_target = car_list[selector]
	pCam.look_at_target = car_list[selector]


func _on_right_button_up() -> void:
	selector += 1
	pCam.follow_target = car_list[selector]
	pCam.look_at_target = car_list[selector]
