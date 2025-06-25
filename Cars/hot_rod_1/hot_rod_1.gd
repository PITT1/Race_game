extends VehicleBody3D

@export var MAX_STEER = 0.7
@export var ENGINE_POWER = 1500
var is_on_race = false
var path_to_follow = 0

@export var is_player: bool = true

func _physics_process(delta: float) -> void:
	if is_player and is_on_race:
		steering = move_toward(steering, Input.get_axis("ui_right", "ui_left") * MAX_STEER, delta * 10)
		engine_force = Input.get_axis("ui_down", "ui_up") * ENGINE_POWER

func start_race():
	is_on_race = true
