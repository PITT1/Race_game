extends VehicleBody3D

@export var MAX_STEER = 0.4
@export var ENGINE_POWER = 1000
@export var ACCELERATION = 3000
@export var ENGINE_PEAK = 1000

var oil_trap_on = false

func _physics_process(delta: float) -> void:
	steering = move_toward(steering, Input.get_axis("ui_right", "ui_left") * MAX_STEER, delta * 10)
	engine_force = Input.get_axis("ui_down", "ui_up") * ENGINE_POWER
	
	if linear_velocity.length() < 20:
		ENGINE_POWER = ACCELERATION
	else:
		ENGINE_POWER = ENGINE_PEAK
