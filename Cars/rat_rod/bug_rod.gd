extends VehicleBody3D

@export var MAX_STEER = 0.7
@export var ENGINE_POWER = 200

func _physics_process(delta: float) -> void:
	steering = move_toward(steering, Input.get_axis("ui_right", "ui_left") * MAX_STEER, delta * 10)
	engine_force = Input.get_axis("ui_down", "ui_up") * ENGINE_POWER
